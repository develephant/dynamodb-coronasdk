local json = require('json')
local timer = require('timer')
local mime = require('socket').mime

local events = system.newEventDispatcher()

local AWSAuth = require('aws_auth')

local m = {}

function m:new( options )

  self.events = events

  self.options = options

  self.auth_opts = 
  {
    aws_key = options.aws_key,
    aws_secret = options.aws_secret,

    aws_service = 'dynamodb',
    aws_region = options.aws_region,

    host = 'dynamodb.'..options.aws_region..'.amazonaws.com',
    method = "POST",

    content_type = "application/x-amz-json-1.0; charset=UTF-8",
    headers = { },

    payload = "{}", --json

    log = options.log
  }

  self.request_url = nil
  self.request_params = nil
  self.request_id = nil

  self.last_error = nil

  self.retry_timer = nil
  self.retry_delay = 50 --delay in ms
end

function m:tryRequest()
  local function listener( evt )
    if (evt.isError) then
      print(evt.response, evt.status)
    else
      if evt.status == 200 then
        self:clearRetryTimer()
        local response_tbl = json.decode(evt.response)
        if self.options.debug then
          self:printTable(response_tbl)
        end
        self.events:dispatchEvent({name="DynamoDbEvent", isError=nil, result=response_tbl, response=evt.response})
      else
        --TODO: here we need to check error for retry
        --for now we just dispatch error
        self.events:dispatchEvent({name="DynamoDbEvent", isError=1, reason=evt.response, status=evt.status})
      end
    end
  end
  
  --send request
  self.request_id = network.request(self.request_url, self.auth_opts.method, listener, self.request_params)
end

function m:retryRequest()
  self.retry_timer = timer.performWithDelay(self.retry_delay, function() self:tryRequest(); end)
  --bump retry delay for exponential backoff, up to a minute
  self.retry_delay = self.retry_delay * 2
  if self.retry_delay >= 60000 then
    --cannot get request through
    self:clearRequest()
    self.events:dispatchEvent({name="DynamoDbEvent", isError=1, reason="Maximum retries exceeded. Failed after 1 min."})
  else
    self:tryRequest()
  end
end

function m:clearRetryTimer()
  if self.retry_timer then
    timer.cancel(self.retry_timer)
    self.retry_timer = nil
    self.retry_delay = 50 --reset
  end
end

function m:clearRequest()
  network.cancel(self.request_id)
  self.request_id = nil
  self:clearRetryTimer()
end

function m:request(action, payload_tbl, listener)

  --auth 
  self.auth_opts.headers = 
  {
    ["X-Amz-Target"] = "DynamoDB_20120810."..action
  }
  self.auth_opts.payload = json.encode( payload_tbl )

  AWSAuth:new( self.auth_opts )

  local request_headers = AWSAuth:getHeaders()
  request_headers["Accept-Encoding"] = "application/json"
  request_headers["Content-Length"] = #self.auth_opts.payload

  local params = 
  {
    headers = request_headers,
    body = self.auth_opts.payload
  }

  self.request_params = params
  self.request_url = 'https://'..self.auth_opts.host..'/'

  self:tryRequest()

end

--data type helpers
function m:Str(string_val)
  return {S = string_val}
end

function m:Num(number_val, raw)

  if not raw then
    number_val = tostring( number_val )
  end

  return {N = number_val}
end

function m:Bin(binary_val)
  return {B = mime.encode(binary_val)}
end

function m:Bool(bool_val)
  return {BOOL = bool_val}
end

function m:Null()
  return {NULL = json.null}
end

function m:Map(map_tbl)
  return {M = map_tbl}
end

function m:List(list_tbl)
  return {L = list_tbl}
end

function m:StrSet(string_set)
  return {SS = string_set}
end

function m:NumSet(number_set, raw)
  local number_set_encoded = {}

  for idx, v in ipairs( number_set ) do 
    if not raw then 
      table.insert(number_set_encoded, v)
    else
      table.insert(number_set_encoded, tostring( v ))
    end
  end

  return {NS = number_set_encoded}
end

function m:BinSet(binary_set)
  local binary_set_encoded = {}
  --base64 encode binary values
  for idx, v in ipairs( binary_set ) do 
    table.insert(binary_set_encoded, mime.encode( v ))
  end

  return {BS = binary_set_encoded}
end 

-- @tparam table t The table data to print.
-- @param[opt=""] indent Indentation char.
function m:printTable( t, indent )
  --== Print contents of a table, with keys sorted.
  local names = {}
  if not indent then indent = "" end
  for n,g in pairs(t) do
      table.insert(names,n)
  end
  table.sort(names)
  for i,n in pairs(names) do
      local v = t[n]
      if type(v) == "table" then
          if(v==t) then -- prevent endless loop if table contains reference to itself
              print(indent..tostring(n)..": <-")
          else
              print(indent..tostring(n)..":")
              self:printTable(v,indent.."   ")
          end
      else
          if type(v) == "function" then
              print(indent..tostring(n).."()")
          else
              print(indent..tostring(n)..": "..tostring(v))
          end
      end
  end
end

return m
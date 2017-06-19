
local auth_config = require('auth_config')
local ddb = require('dynamodb')

ddb:new({
  aws_key = auth_config.key,
  aws_secret = auth_config.secret,
  aws_region = "us-east-1",
  debug = true
})

-- local payload_tbl = 
-- {
--   TableName = "Music",
--   Key = 
--   {
--     Artist = ddb:Str("Super Fan"),
--     SongTitle = ddb:Str("A Big Taco")
--   }
-- }

local payload_tbl = 
{
  TableName = "Music"
}

function ddbEventListener( evt )
  if evt.isError then
    print(evt.reason, evt.status)
  else
    -- evt.result contains data table 
    -- evt.response contains raw json
  end
end

ddb.events:addEventListener( "DynamoDbEvent", ddbEventListener )

-- ddb:request("GetItem", payload_tbl)
ddb:request("Scan", payload_tbl)
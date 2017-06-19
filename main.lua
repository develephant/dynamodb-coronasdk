
local ddb = require('dynamodb')

ddb:new({
  aws_key = "AKIAIFBUN2GJRQB2FKKQ",
  aws_secret = "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",
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
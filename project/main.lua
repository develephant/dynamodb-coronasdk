
local auth_config = require('auth_config')
local db = require('dynamodb')

db:new({
  aws_key = auth_config.key,
  aws_secret = auth_config.secret,
  aws_region = "us-east-1",
  debug = true
})


-- PutItem
-- local put_payload_tbl = 
-- {
--   TableName = "Music",
--   Item = 
--   {
--     Artist = db:S("Monkey Fish"),
--     SongTitle = db:S("I like Milk"),
--     Coolness = db:NULL()
--     -- Length = db:N(100),
--     -- Tracks = db:L({db:S("Snappy"), db:S("Fun"), db:N(1000), db:L({db:S("Hippe"), db:BOOL(true)})})
--   }
-- }

-- {S="Hello"}
-- db:S("Hello")

-- GetItem
-- local get_payload_tbl = 
-- {
--   TableName = "Music",
--   Key = 
--   {
--     Artist = db:S("Monkey Fish"),
--     SongTitle = db:S("I like Milk")
--   }
-- }

-- Scan
-- local payload_tbl = 
-- {
--   TableName = "Music"
-- }

--Describe
-- local describe_payload_tbl = 
-- {
--   TableName = "Music"
-- }

--delete
-- local delete_payload_tbl = 
-- {
--   TableName = "Music",
--   Key = 
--   {
--     Artist = db:S("Super Fan"),
--     SongTitle = db:S("Somewhere Is Land")
--   }
-- }

--batchwrite
-- local batch_write_payload = 
-- {
--   RequestItems = 
--   {
--     Music = 
--     {
--       {
--         PutRequest = 
--         {
--           Item = 
--           {
--             Artist = db:S("Monkey Fish"),
--             SongTitle = db:S("Saucy Talk")
--           }
--         }
--       }
--     },
--     Menu = 
--     {
--       {
--         DeleteRequest = 
--         {
--           Key = 
--           {
--             Food = db:S("Fries")
--           }
--         }
--       },
--       {
--         DeleteRequest = 
--         {
--           Key = 
--           {
--             Food = db:S("Coke")
--           }
--         }
--       }
--     }
--   },
--   ReturnConsumedCapacity = "TOTAL"
-- }

--batchget
-- local batch_get_payload = 
-- {
--   RequestItems = 
--   {
--     Music = 
--     {
--       Keys = 
--       {
--         {
--           Artist = db:S("Super Fan"),
--           SongTitle = db:S("A Big Taco")
--         },
--         {
--           Artist = db:S("Monkey Fish"),
--           SongTitle = db:S("I like Milk")
--         }
--       },
--       ProjectionExpression = "SongTitle"
--     },
--     Menu = 
--     {
--       Keys = 
--       {
--         {
--           Food = db:S("Tacos")
--         }
--       },
--       ProjectionExpression = "Price"
--     }
--   },
--   ReturnConsumedCapacity = "TOTAL"
-- }

-- local query_payload = 
-- {
--   TableName = "Menu",
--   KeyConditionExpression = "Food = :v1",
--   ExpressionAttributeValues = 
--   {
--     [":v1"] = db:S("Tacos")
--   }
-- }

local create_table_payload = 
{
  AttributeDefinitions = 
  {
    {
      AttributeName = "Book",
      AttributeType = "S"
    }
  },
  TableName = "Books",
  KeySchema = 
  {
    {
      AttributeName = "Book",
      KeyType = "HASH"
    }
  },
  ProvisionedThroughput = 
  {
    ReadCapacityUnits = 5,
    WriteCapacityUnits = 5
  }
}

local describe_table_payload = 
{
  TableName = "Books"
}

local delete_table_payload = 
{
  TableName = "Menu"
}

function dbEventListener( evt )
  if evt.error then
    print(evt.reason, evt.status)
  else
    -- evt.result contains data table 
    -- evt.response contains raw json
    print(evt.response)
  end
end

db.events:addEventListener( "DynamoDbEvent", dbEventListener )

db:request("DeleteTable", delete_table_payload)
--db:request("ListTables", {Limit = 5})
--db:request("DescribeTable", describe_table_payload)
--db:request("CreateTable", create_table_payload)
--db:request("Query", query_payload)
--db:request("BatchGetItem", batch_get_payload)
--db:request("BatchWriteItem", batch_write_payload)
--db:request("DeleteItem", delete_payload_tbl)
--db:request("PutItem", put_payload_tbl)
--db:request("GetItem", get_payload_tbl)
--db:request("Scan", payload_tbl)
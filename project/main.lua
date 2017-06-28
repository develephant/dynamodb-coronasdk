
local db = require('dynamodb.client')

local auth = require('auth')
local payloads = require('test_payloads')

db:init({
  aws_key = auth.key,
  aws_secret = auth.secret,
  aws_region = "us-east-1",
  debug = true
})

function dbEventListener( evt )
  if evt.error then
    print(evt.reason, evt.status)
  else
    -- evt.result contains data table
  end
end

db.events:addEventListener( "DynamoDbEvent", dbEventListener )

--###############################################################################
--# Test Requests
--# The following requests require the proper DynamoDB databases set-up.
--# See: https://aws.amazon.com/getting-started/tutorials/create-nosql-table/
--###############################################################################

db:request("GetItem", payloads.getItem())
--db:request("PutItem", payloads.putItem())
--db:request("UpdateItem", payloads.updateItem())
--db:request("DeleteItem", payloads.deleteItem())

--db:request("Scan", payloads.scan())
--db:request("Query", payloads.query())

--db:request("CreateTable", payloads.createTable())
--db:request("ListTables", payloads.listTables())
--db:request("DescribeTable", payloads.describeTable())
--db:request("DeleteTable", payloads.deleteTable())

--db:request("BatchGetItem", payloads.batchGetItem())
--db:request("BatchWriteItem", payloads.batchWriteItem())


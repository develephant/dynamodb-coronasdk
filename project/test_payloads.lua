
local db = require('dynamodb.client')

local pl = {}

--###############################################################################
--# GetItem
--# http://docs.aws.amazon.com/amazondynamodb/latest/APIReference/API_GetItem.html
--###############################################################################
pl.getItem = function()
  return 
  {
    TableName = "Music",
    Key = 
    {
      Artist = db:S("The Acme Band"),
      SongTitle = db:S("Look Out, World")
    }
  }
end

--###############################################################################
--# PutItem
--# http://docs.aws.amazon.com/amazondynamodb/latest/APIReference/API_PutItem.html
--###############################################################################
pl.putItem = function()
  return 
  {
    TableName = "Music",
    Item = 
    {
      Artist = db:S("No One You Know"),
      SongTitle = db:S("The Best Song Ever"),
      Rating = db:N(5)
    }
  }
end

--###############################################################################
--# UpdateItem
--# http://docs.aws.amazon.com/amazondynamodb/latest/APIReference/API_UpdateItem.html
--###############################################################################
pl.updateItem = function()
  return
  {
    TableName = "Music",
    Key = {
      Artist = db:S("No One You Know"),
      SongTitle = db:S("The Best Song Ever")
    },
    UpdateExpression = "SET Rating = :val1",
    ConditionExpression = "Rating < :val2",
    ExpressionAttributeValues = 
    {
      [":val1"] = db:N(10),
      [":val2"] = db:N(10)
    },
    ReturnValues = "ALL_NEW"
  }
end

--###############################################################################
--# DeleteItem
--# http://docs.aws.amazon.com/amazondynamodb/latest/APIReference/API_DeleteItem.html
--###############################################################################
pl.deleteItem = function()
  return 
  {
    TableName = "Music",
    Key = 
    {
      Artist = db:S("The Acme Band"),
      SongTitle = db:S("Still In Love")
    }
  }
end

--###############################################################################
--# Scan
--# http://docs.aws.amazon.com/amazondynamodb/latest/APIReference/API_Scan.html
--###############################################################################
pl.scan = function()
  return 
  {
    TableName = "Music"
  }
end

--###############################################################################
--# Query
--# http://docs.aws.amazon.com/amazondynamodb/latest/APIReference/API_Query.html
--###############################################################################
pl.query = function()
  return 
  {
    TableName = "Music",
    KeyConditionExpression = "Artist = :val1",
    ExpressionAttributeValues = 
    {
      [":val1"] = db:S("No One You Know")
    }
  }
end

--###############################################################################
--# CreateTable
--# http://docs.aws.amazon.com/amazondynamodb/latest/APIReference/API_CreateTable.html
--###############################################################################
pl.createTable = function()
  return 
  {
    TableName = "Library",
    KeySchema = 
    {
      {
        AttributeName = "Book",
        KeyType = "HASH"
      }
    },
    AttributeDefinitions = 
    {
      {
        AttributeName = "Book",
        AttributeType = "S"
      }
    },
    ProvisionedThroughput = 
    {
      ReadCapacityUnits = 5,
      WriteCapacityUnits = 5
    }
  }
end 

--###############################################################################
--# ListTables
--# http://docs.aws.amazon.com/amazondynamodb/latest/APIReference/API_ListTables.html
--###############################################################################
pl.listTables = function()
  return 
  {
    Limit = 5
  }
end

--###############################################################################
--# DescribeTable
--# http://docs.aws.amazon.com/amazondynamodb/latest/APIReference/API_DescribeTable.html
--###############################################################################
pl.describeTable = function()
  return 
  {
    TableName = "Music"
  }
end

--###############################################################################
--# DeleteTable
--# http://docs.aws.amazon.com/amazondynamodb/latest/APIReference/API_DeleteTable.html
--###############################################################################
pl.deleteTable = function()
  return 
  {
    TableName = "Library"
  }
end

--###############################################################################
--# BatchGetItem
--# http://docs.aws.amazon.com/amazondynamodb/latest/APIReference/API_BatchGetItem.html
--###############################################################################
pl.batchGetItem = function()
  return 
  {
    RequestItems = 
    {
      Music = 
      {
        Keys = 
        {
          {
            Artist = db:S("No One You Know"),
            SongTitle = db:S("Call Me Today")
          },
          {
            Artist = db:S("The Acme Band"),
            SongTitle = db:S("Look Out, World")
          }
        },
        ProjectionExpression = "SongTitle"
      },
      Library = 
      {
        Keys = 
        {
          {
            Book = db:S("A Tale Of Three Eyes")
          }
        }
      }
    },
    ReturnConsumedCapacity = "TOTAL"
  }
end

--###############################################################################
--# BatchWriteItem
--# http://docs.aws.amazon.com/amazondynamodb/latest/APIReference/API_BatchWriteItem.html
--###############################################################################
pl.batchWriteItem = function()
  return 
  {
    RequestItems = 
    {
      Library = 
      {
        {
          PutRequest = 
          {
            Item = 
            {
              Book = db:S("1000 Degrees In The Sun")
            }
          }
        }
      },
      Music = 
      {
        {
          DeleteRequest = 
          {
            Key = 
            {
              Artist = db:S("The Acme Band"),
              SongTitle = db:S("Look Out, World")
            }
          }
        },
        {
          DeleteRequest = 
          {
            Key = 
            {
              Artist = db:S("No One You Know"),
              SongTitle = db:S("My Dog Spot")
            }
          }
        }
      }
    },
    ReturnConsumedCapacity = "TOTAL"
  }
end


return pl
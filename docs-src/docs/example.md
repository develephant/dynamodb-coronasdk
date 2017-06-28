# Basic Request

```lua
--require module
local db = require('dynamodb.client')

--create new instance
db:new({
  aws_key = "<AWS access key>",
  aws_secret = "<AWS secret key">,
  aws_region = "us-east-1",
  debug = true
})

--build request payload
local payload =
{
  TableName = "Music",
  Key = 
  {
    Artist = db:S("The Acme Band"),
    SongTitle = db:S("Look Out, World")
  }
}

--set up listener
function dbEventListener( evt )
  if evt.error then
    print(evt.reason, evt.status)
  else
    -- evt.result contains data table
  end
end

db.events:addEventListener( "DynamoDbEvent", dbEventListener )

--make DynamoDB request
db:request("GetItem", payload)

```

See also: __[Data Methods](api/#data-methods)__.

---

## Payloads

For full payload parameters and usage see the included links.

!!! important
    When viewing the __[DynamoDB API Documentation](http://docs.aws.amazon.com/amazondynamodb/latest/APIReference/API_Operations_Amazon_DynamoDB.html)__, all payloads for DynamoDB are built using JSON notation. You will need to convert the JSON stylings to Lua table structures. If you'd rather construct payloads using JSON, then be sure to `json.encode()` your payload before making a request.

All examples below are shown using Lua table structures, which have been converted from JSON.

### GetItem

[http://docs.aws.amazon.com/amazondynamodb/latest/APIReference/API_GetItem.html](http://docs.aws.amazon.com/amazondynamodb/latest/APIReference/API_GetItem.html)

```lua
{
  TableName = "Music",
  Key = 
  {
    Artist = db:S("The Acme Band"),
    SongTitle = db:S("Look Out, World")
  }
}
```

### PutItem

[http://docs.aws.amazon.com/amazondynamodb/latest/APIReference/API_PutItem.html](http://docs.aws.amazon.com/amazondynamodb/latest/APIReference/API_PutItem.html)

```lua
{
  TableName = "Music",
  Item = 
  {
    Artist = db:S("No One You Know"),
    SongTitle = db:S("The Best Song Ever"),
    Rating = db:N(5)
  }
}
```

### UpdateItem

[http://docs.aws.amazon.com/amazondynamodb/latest/APIReference/API_UpdateItem.html](http://docs.aws.amazon.com/amazondynamodb/latest/APIReference/API_UpdateItem.html)

```lua
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
```

### DeleteItem

[http://docs.aws.amazon.com/amazondynamodb/latest/APIReference/API_DeleteItem.html](http://docs.aws.amazon.com/amazondynamodb/latest/APIReference/API_DeleteItem.html)

```lua
  {
    TableName = "Music",
    Key = 
    {
      Artist = db:S("The Acme Band"),
      SongTitle = db:S("Still In Love")
    }
  }
```

### Scan

[http://docs.aws.amazon.com/amazondynamodb/latest/APIReference/API_Scan.html](http://docs.aws.amazon.com/amazondynamodb/latest/APIReference/API_Scan.html)

```lua
{
  TableName = "Music"
}
```

### Query

[http://docs.aws.amazon.com/amazondynamodb/latest/APIReference/API_Query.html](http://docs.aws.amazon.com/amazondynamodb/latest/APIReference/API_Query.html)

```lua
{
  TableName = "Music",
  KeyConditionExpression = "Artist = :val1",
  ExpressionAttributeValues = 
  {
    [":val1"] = db:S("No One You Know")
  }
}
```

### CreateTable
[http://docs.aws.amazon.com/amazondynamodb/latest/APIReference/API_CreateTable.html](http://docs.aws.amazon.com/amazondynamodb/latest/APIReference/API_CreateTable.html)

```lua
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
```

### ListTables

[http://docs.aws.amazon.com/amazondynamodb/latest/APIReference/API_ListTables.html](http://docs.aws.amazon.com/amazondynamodb/latest/APIReference/API_ListTables.html)

```lua
{
  Limit = 5
}
```

### DescribeTable
[http://docs.aws.amazon.com/amazondynamodb/latest/APIReference/API_DescribeTable.html](http://docs.aws.amazon.com/amazondynamodb/latest/APIReference/API_DescribeTable.html)

```lua
{
  TableName = "Music"
}
```

### DeleteTable
[http://docs.aws.amazon.com/amazondynamodb/latest/APIReference/API_DeleteTable.html](http://docs.aws.amazon.com/amazondynamodb/latest/APIReference/API_DeleteTable.html)

```lua
{
  TableName = "Library"
}
```

### BatchGetItem
[http://docs.aws.amazon.com/amazondynamodb/latest/APIReference/API_BatchGetItem.html](http://docs.aws.amazon.com/amazondynamodb/latest/APIReference/API_BatchGetItem.html)

```lua
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
```

### BatchWriteItem
[http://docs.aws.amazon.com/amazondynamodb/latest/APIReference/API_BatchWriteItem.html](http://docs.aws.amazon.com/amazondynamodb/latest/APIReference/API_BatchWriteItem.html)

```lua
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
```
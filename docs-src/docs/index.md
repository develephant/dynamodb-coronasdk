# DynamoDB Corona Module

The DynamoDB module provides access to the low-level AWS DynamoDB API.

## Prerequisites

To properly use this module it is assumed that you:

 - Have a current AWS account.
 - Understand how to use DynamoDB.
 - Know where to find documentation.
 - Can set up IAM users, as well as their permissions.

## Get the Module

You can download the module from the __[DynamoDB CoronaSDK](https://github.com/develephant/dynamodb-coronasdk)__ repo.

Click the green "Clone or download" button and select "Download ZIP" from the pop-up.

Expand the ___dynamodb-coronasdk-master.zip___ file.



## Add the Module

```lua
local dynamodb = require("dynamodb.client")
```

## Create an Instance

```lua
local db = dynamodb:new( config )
```

See __[new()](http://docs.aws.amazon.com/amazondynamodb/latest/APIReference/API_ListTables.html)__ for configuration options.

## Make a Request

```lua
local function dbListener( evt )
  if not evt.error then
    print(evt.result.some_key)
  end
end
db.events:addEventListener(dbListener)

db:request( action, payload )
```

See __[request()](api/#request)__ for more details.
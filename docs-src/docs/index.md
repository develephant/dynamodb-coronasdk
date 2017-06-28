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

Click the green __"Clone or download"__ button and select __"Download ZIP"__ from the pop-up.

Expand the ___dynamodb-coronasdk-master.zip___ file.

Copy the ___dynamodb___ directory found inside to your Corona project.

!!! important
    Be sure to copy over the actual ___dynamodb___ directory, not the files inside.

Your project tree should look something like:

```
CoronaProjectFolder
-- dynamodb
-- main.lua
-- ...
```

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
# Methods

## new

Create a new instance of the DynamoDB object.

```lua
local db = dynamodb:new( config )
```

__Config Properties__

|Name|Description|Type|
|----|-----------|----|
|aws_key|User AWS access key.|String|
|aws_secret|User AWS secret key.|String|
|aws_region|AWS region for DynamoDB.|String|
|debug|Output response data structure.|Boolean|

__Example__

```lua
local dynamodb = require("dynamodb.client")

local db = dynamodb:new(
{
  aws_key = auth.key,
  aws_secret = auth.secret,
  aws_region = "us-east-1",
  debug = true
})
```

!!! warning
    It should be noted that your service could be compromised if someone gets a hold of your secret key. Make sure to always create a unique IAM user, with the minimum permissions required.

---

## request

Make a request to the DynamoDB service.

!!! important
    A request requires an event listener to reteive the response data. See [Events](#events).

```lua
db:request(action, payload)
```

__Request Properties__

|Name|Description|Type|
|----|-----------|----|
|action|The DynamoDB action to perform.|String|
|payload|The required payload for the action.|Table|

See __[Actions](usage/#actions)__ for more details on action types.

See __[Examples](example/#payloads)__ for more details on payload types.

# Events

## DynamoDBEvent

To capture the request response data, you must register an event listener.

```lua
local function dynamoDBResponse( evt )
  if evt.error then
    print(evt.reason, evt.status)
  else
    --response as table data
    local data_table = evt.result --Table

    --response as JSON string
    print(evt.response) --JSON
  end
end

db.events:addEventListener("DynamoDBEvent", dynamoDBResponse)

db:request("GetItem", payload)
```

# Data Methods

DynamoDB values require a data type, denoted with a string code. While you can manually create each value entry, these methods offer another approach, as well as, make sure the encoding is properly handled.

## S

Returns a formatted string value as a table.

```lua
local str = db:S("A string value")
```

## N

Returns a formatted number value as a table.

```lua
local num = db:N(12)
```

## B

Returns encoded binary data as a table.

```lua
local bin = db:B(<binary-data>)
```

## M

Returns a map value as a table.

!!! tip
    A map is equivalent to a Lua data table. The values in a map must be typed. A map can hold any data type, including nested values.

```lua
local map = db:M({
  Artist = db:S("The Acme Band"),
  Rating = db:N(10) 
})
```

## L

Returns a list value as a table.

!!! tip
    A list is equivalent to a Lua table array. The values in a list must be typed. A list can hold any data type.

```lua
local list = db:L({
  db:S("Hello"),
  db:N(25),
  db:BOOL(false),
  db:M({Age=db:N(25), Name=db:S("John")})
})
```

## SS

Returns a string set as a table.

!!! tip
    A string set is equivalent to a table array that can only contain string data types.

```lua
local string_set = db:SS({
  db:S("Hello"),
  db:S("World")
})
```

## NS

Returns a number set as a table.

!!! tip
    A number set is equivalent to a table array that can only contain number data types.

```lua
local num_set = db:NS({
  db:N(12),
  db:N(34),
  db:N(2.34)
})
```

## BS

Returns a binary set as a table.

!!! tip
    A binary set is equivalent to a table array that can only contain binary data types.

```lua
local bin_set = db:BS({
  db:B(<binary-data>),
  db:B(<binary-data>)
})
```

## BOOL

Returns a boolean value as a table.

```lua
local bool = db:BOOL(false)
```

## NULL

Returns a null value type as a table.

```lua
local null = db:NULL()
```
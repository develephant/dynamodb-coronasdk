
# Building a Request

To perform operations on DynamoDB you will need to create a request that includes both an ___Action___ and ___Payload___. 

An ___Action___ is the operation you would like to perform. See __[Actions](#actions)__.

A ___Payload___ is a data structure that includes the needed parameters for an ___Action___. You can derive payload parameters by browsing the __[DynamoDB API Documentation](http://docs.aws.amazon.com/amazondynamodb/latest/APIReference/API_Operations_Amazon_DynamoDB.html)__.

All code in this documentaion is shown using Lua table structures, which have been converted from JSON.

!!! important
    When viewing the __[DynamoDB API Documentation](http://docs.aws.amazon.com/amazondynamodb/latest/APIReference/API_Operations_Amazon_DynamoDB.html)__, all payloads for DynamoDB are built using JSON notation. You will need to convert the JSON stylings to Lua table structures. If you'd rather construct payloads using JSON, then be sure to `json.encode()` your payload before making a request.

For examples of the different types of payloads see __[Examples](example/#payloads)__.

## Actions

Actions are the operations to be perfomed against the DynamoDB service. You must provide an action the `request` method.

```lua
db:request("GetItem", payload)
```

### Items

  - GetItem
  - PutItem
  - UpdateItem
  - DeleteItem

### Scan/Query

  - Scan
  - Query

### Tables

  - CreateTable
  - ListTables
  - DescribeTable
  - DeleteTable

### Batch

  - BatchGetItem
  - BatchWriteItem

!!! tip
    For a complete list of actions available see __[DynamoDB Actions](http://docs.aws.amazon.com/amazondynamodb/latest/APIReference/API_Operations.html)__.

# Payloads

A payload contains the required parameters for any given action. Payload details can be found in the __[DynamoDB API Documentation](http://docs.aws.amazon.com/amazondynamodb/latest/APIReference/API_Operations_Amazon_DynamoDB.html)__.

For some example payload structures see __[Examples](example/#payloads)__.

# Data Types

DynamoDB supports a variety of data types that you must specify when making requests. They are notated using a string code.

|Code|Type|
|----|----|
|S|String|
|N|Number|
|B|Binary|
|M|Map (data table)|
|L|List (table array)|
|SS|String Set|
|NS|Number Set|
|BS|Binary Set|
|BOOL|Boolean|
|NULL|Null|

To indicate a data type, you create a table with the data code as the key, and the data as the value.

```lua
{S="String data type"}
```

!!! tip
    You can use the API data methods as a shortcut to creating value entries. See __[Data Methods](api/#data-methods)__.

_Some examples:_

```lua
--String
local str = {S="My Best Song"}

--Number 
local num = {N=12}

--Map
local map = {M = 
{
  Artist = {S="The Acme Band"},
  SongTitle = {S= "Super Fan"},
  Rating = {N=10}
}}

--List
local list = {L =
{
  {S="Blue"}, {BOOL=false}, {N=23}
}}

--Number Set
local num_set = {NS = {
  {N=12}, {N=45}, {N=2.45}
}}
```

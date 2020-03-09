<p align="center">
    <img src="https://user-images.githubusercontent.com/1342803/36623515-7293b4ec-18d3-11e8-85ab-4e2f8fb38fbd.png" width="320" alt="API Template">
    <br>
    <br>
    <a href="http://docs.vapor.codes/3.0/">
        <img src="http://img.shields.io/badge/read_the-docs-2196f3.svg" alt="Documentation">
    </a>
    <a href="https://discord.gg/vapor">
        <img src="https://img.shields.io/discord/431917998102675485.svg" alt="Team Chat">
    </a>
    <a href="LICENSE">
        <img src="http://img.shields.io/badge/license-MIT-brightgreen.svg" alt="MIT License">
    </a>
    <a href="https://circleci.com/gh/vapor/api-template">
        <img src="https://circleci.com/gh/vapor/api-template.svg?style=shield" alt="Continuous Integration">
    </a>
    <a href="https://swift.org">
        <img src="http://img.shields.io/badge/swift-5.1-brightgreen.svg" alt="Swift 5.1">
    </a>
</p>

# ToDo_API

ToDo_API is an open source project that allows to list, create, edit and delete tasks through its ***endpoints***

## Task model information

```swift
name: String
state: Int (1: completed task/ 0: Not completed task / -1 Unknown state)
dueDate: String ("yyyy-MM-dd'T'HH:mm:ssZ")
id: String (UUID)
notes: String
```


## 1. Get task list

To retrieve the task list you have to call to ***/task*** endpoint 

Http method: ***GET***

Body: `null` (*Empty body*)

Sample response:

```javascript
[
    {
        "name": "Task 2",
        "state": 1,
        "dueDate": "2033-03-09T00:00:00Z",
        "id": "D40D3136-2C05-4C42-BB78-07DE363FBA19",
        "notes": "--"
    },
    {
        "name": "Task 1",
        "state": 0,
        "dueDate": "2028-03-09T00:00:00Z",
        "id": "7E8B1F6A-B799-4DEA-AF08-16E2F7EA4004",
        "notes": "--"
    }
]
```

Returns an Array with all the tasks

## 2. Create task

To create one task you have to call to ***/task*** endpoint 

Http method: ***POST***

Body: 

```javascript
{
	"id": "76B04C6D-6EE8-43DC-B956-5751024B4E84",
	"name": "Task 1",
	"dueDate": "12/05/2020",
	"state": 0,
	"notes": "notes 1"
}
```

Sample response: `null` (*Empty response*)

## 3. Update task

To update one task you have to call to ***/task*** endpoint 

Http method: ***PATCH***

Body: 

```javascript
{
"id": "76B04C6D-6EE8-43DC-B956-5751024B4E84",
"name": "Task 1 modified",
"dueDate": "12/05/2020",
"state": 1,
"notes": "notes updated"
}
```

Sample response: `null` (*Empty response*)

## 4. Delete task

To delete one task you have to call to ***/task/{{task_id}}*** endpoint.

(*{{task_id}} the task identifier of the task to be deleted*)

Http method: ***DELETE***

Body: `null` (*Empty body*)

Sample response: `null` (*Empty response*)








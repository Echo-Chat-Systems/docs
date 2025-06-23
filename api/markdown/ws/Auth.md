# Authentication API (`auth`)

The authentication API is responsible for all things relating to identities and user information.

## Actions

### `signup`

Required knowledge: 
- [Users](../definitions/User.md)

A signup can be conducted via either the REST API or the WebSocket API.

#### WebSocket

![WebSocket Connection Diagram](/api/diagrams//flows/ws/Signup.png)

#### REST

![REST Connection Diagram](/api/diagrams/flows/rest/Signup.png)

#### Fields

A signup is a single interaction process initiated always by the client. 

The client sends the following JSON object:

```json
{
    "target": "auth",
    "data": {
        "action": "signup",
        "params": {}
    }
}
```

Where:
- `params` is the signed [User](../definitions/User.md)

Depending on the success of the signup the server will respond with one of the following JSON objects:

### Success
```json
{
    "code": 201
}
```

### Failure

```json
{
    "code": 418,  // Code changes depending on error
    "info": {
        "msg": ""
    }
}
```

Where:
- `code` is the applicable [HTTP Status Code](https://developer.mozilla.org/en-US/docs/Web/HTTP/Reference/Status)
- `msg` is the error message returned by the server


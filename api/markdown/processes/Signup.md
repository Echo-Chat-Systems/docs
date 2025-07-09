# Processes - Signup

Required knowledge: 
- [Users](/api/markdown/definitions/User.md)

## Flow 

![Auth Signup Flow Diagram](/api/diagrams/flows/ws/auth/signup.png)

## Fields 

### Signup Initiate 

A signup is always initated by the client. 

The signup initiation is the following JSON object.

```json
{
    "target": "auth",
    "data": {
        "action": "signup-start",
        "params": {
            "keys": {},
            "profile": {
                "username": "",
                "tag": ""
            }
        }
    }
}
```

Where
- `keys` is the `keys` field in the [user](/api/markdown/definitions/User.md#simple)
- `profile` is the profile field from the [user](/api/markdown/definitions/User.md#simple). `username` and `tag` are the only required fields. 

### Response

If the signup is a success the following message will be sent.

```json 
{
    "target": "auth",
    "data": {
        "action": "signup-success",
        "params": {}
    }
}
```

Where


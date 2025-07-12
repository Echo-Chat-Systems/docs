# Error

A websocket error is a simple message stating that something about the most recent message was malformed or not as expected.

## Spec

```json 
{
    "target": "error",
    "data": {
        "action": "error",
        "params": {
            "message": ""
        }
    }
}
```


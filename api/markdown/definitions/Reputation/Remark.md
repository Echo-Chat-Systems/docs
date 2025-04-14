# Definitions - Reputation - Remark

A remark is simply a record on someones public reputation record signed and commited by a user.

## Fields

A remark is defined as the following JSON object:

```json
{
    "signature": {
        "direction": 0,
        "comment": "",
        "user": ""   
    }
}
```

Where 
- `sig` is the signature of
- `dir` is a signed integer between -1 and 1 indicating the direction of the remark.
- `com` is an optional 256 character string.
- `usr` is the user id

### Compacted

As with any object in Echo, the Remark schema has been micro-optimised to reduce network bandwidth requirements. Below is the optimised schema.

```json
{
    "sig": {
        "dir": 0,
        "com": "",
        "usr": ""   
    }
}
```
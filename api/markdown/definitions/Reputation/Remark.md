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
- `signature` is the signature of the remark computed by the user commiting it
- `direction` is a signed short (represented as an enum) between -1 and 1 indicating the direction of the remark.
- `comment` is an optional string denoting any comments the user may have.
- `user` is the public key of the user commiting the comment. 

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
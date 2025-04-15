# Processes - Login

Required knowledge: 
- [Users](../definitions/User.md)

A login is a WebSocket only process. 

## Flow

![Login Flow Diagram](/api/diagrams/flows/ws/Login.png)

## Fields

### Sign In Initiate

The sign in initiation is the following JSON object:

```json
{
    "target": "auth",
    "data": {
        "action": "signin",
        "encrypt-key": "",
        "sign-key": ""
    }
}
```

Where
- `ek` is the users public encrpytion key
- `sk` is the users public signing key

### Challenge

The server will always challenge the signing key as it is the main identity provider. It may also challenge the encryption key in the following circumstances:
- Login on a new device
- Encryption key change

For the purposes of this document, it is assumed that the encrpytion key has changed

```json
{
    "encrypted-challenge": "",
    "sc": ""
}
```

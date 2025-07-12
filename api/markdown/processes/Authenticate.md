# Processes - Verify

Required knowledge: 
- [Users](/api/markdown/definitions/User.md)

## Flow

![Auth Verify Flow Diagram](/api/diagrams/flows/ws/auth/verify.png)

## Fields

### Authenticate Initiate

An authentication is always initiated by the client.

The auth initiation is the following JSON object:

```json
{
    "target": "auth",
    "data": {
        "action": "signin-start",
        "params": {
            "sign-key": "",
            "encrypt-key": ""
        }
    }
}
```

Where
- `sign-key` is the users public signing key
- `encrypt-key` is the users public encrpytion key

### Challenge

The server will always challenge the signing key as it is the main identity provider. It may also challenge the encryption key in the following circumstances:
- Login on a new device
- Encryption key change

For the purposes of this document, it is assumed that the encrpytion key signature has changed and therefore needs to be challenged. In the event that it does not need to be challenged, the `encrypt-challenge` field is not present.

```json
{
    "target": "auth",
    "data": {
        "action": "signin-challenge",
        "params": {
            "sign-challenge": "",
            "encrypt-challenge": "",
            "ref": ""
        } 
    }
}
```

Where
- `sign-challenge` is a random 128 byte string
- `encrypt-challenge` is a random 128 byte string encrypted using the user's public encryption key
- `ref` is a challenge reference code valid for 60 seconds (UUID)

### Response

The client will send back the completed challenges in the following JSON object.

```json
{
    "target": "auth",
    "data": {
        "action": "signin-response",
        "params": {
            "signature": "",
            "decrypted": "",
            "ref": ""
        }
    }
}
```

Where
- `signature` is the signature of `sign-challenge` signed using the user's private signing key
- `decrypted` is the decrypted 128 byte encryption challenge 
- `ref` is the reference code provided in `signin-challenge`

### Verification

The server will verify these values and provided they are correct, will issue a new [Server Signed User Certificate](/api/markdown/definitions/User.md#server-signed-user-certificate).

```json
{
    "target": "auth",
    "data": {
        "action": "signin-complete",
        "params": {
            "status": 0,
            "cert": {},
            "msg": ""
        }
    }
}
```

Where
- `cert` is the [Server Signed User Certificate](/api/markdown/definitions/User.md#server-signed-user-certificate) provided on a successful login
- `msg` is an optional server provided error message
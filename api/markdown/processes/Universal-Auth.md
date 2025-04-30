# Process - Universal Auth

The universal authentication process is not a direct process on it's own, but rather a subprocess used by other processes to ensure authentication upon login and protected actions.

## Flow

![Universal Auth Process](/api/diagrams/flows/ws/Universal-Auth.png)

## Fields

### Sign In Initiate

The sign in initiation is the following JSON object:

```json
{
    "target": "auth",
    "data": {
        "action": "signin",
        "sign-key": "",
        "encrypt-key": ""
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
    "sign-challenge": "",
    "encrypt-challenge": ""
}
```

Where
- `sign-challenge`is a random 128 byte string
- `encrypt-challenge` is a random 128 byte string encrypted using the user's public encryption key

### Reply

The client will send back the completed challenges in the following form:

```json
{
    "signature": "",
    "decrypted": ""
}
```

Where
- `signature` is the signature of the `sign-challenge`, signed with the client signing key
- `decrypted` is the decrypted value of `encrypt-challenge`

### Certificate Issuance

If the server verifies the user's credentials as correct they will issue a [Server Signed User Certificate](/api/markdown/processes/Universal-Auth.md)
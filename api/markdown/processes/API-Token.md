# Process - Obtain API Token

## Flow

## Fields

### Token Request

The token request is initiated using the following JSON object:

```json
{
    "target": "auth",
    "data": {
        "action": "api-token-create",
        "sign-key": "",
        "encrypt-key": ""
    }
}
```

### Challenge

As with [logins](./Login.md), the server will always challenge the signing key. It may also challenge the encryption key if the signature has changed.
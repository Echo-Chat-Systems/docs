# Definitions - User

A user is defined as a collection of identifiying and non-identifying information about a specific individual or group of individuals making use of the platform. 

The most important aspect of a user is their Signing Key Pair (SKP) and their Encrypting Key Pair (EKP). The SKP is used to handle verification of public information such as profile information, profile updates, and public broadcasts whereas the EKP is used to handle encrpytion of incomming messages intended for that user.

## Fields

When another entity refers to the users ID, they are referring to the users Public Signing Key.

### Simple

A user may broadcast themselves as the following JSON object to any other user (NOTE: only contains public fields):

```json
{
    "package": {
        "origin": "",
        "keys": {
            "sk": "",
            "ek": ""
        },
        "profile": {
            "username": "",
            "tag": 2445,
            "pronouns": "",
            "bio": "",
            "css": "",
            "pfp": "",
            "banner": "",
            "timezone": "",
            "status": {}
        }
    },
    "sig": ""
}
```

Where:
- `origin` is the user's origin server
- `keys` is the users public key pair
- `status` is a [Status](./Status.md) object
- `sig` is the signature of the profile

### Server Signed User Certificate

In most cases, a Server Signed User Certificate is required. 

```json
{
    "package": {
        "package": {
            "origin": "",
            "keys": {
                "sk": "",
                "ek": ""
            },
            "profile": {
                "username": "",
                "pronouns": "",
                "bio": "",
                "css": "",
                "pfp": "",
                "banner": "",
                "timezone": "",
                "status": {
                    "type": "",
                    "text": ""
                }
            }
        },
        "rep": {
            "points": 100,
            "remarks    ": {
                "sig": {
                    "dir": 0,
                    "com": "",
                    "usr": ""   
                },
            }
        },
        "expiry": "",
        "sig": "",
        "origin": ""
    },
    "sig": ""
}
```

Where
- `marks` is an array of [Remarks](/api/components/Reputation/Remark.md).
- `expiry` is the point at which a user must have their certificate re-signed
- `package` is the user-signed `package` along with the server-provided information.
- `sig` is the server signature for the new package.
- `origin` is the origin server issuing this certificate.

As with any certificate, every server maintains a CRL or Certificate Revocation List.
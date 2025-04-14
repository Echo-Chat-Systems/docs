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
    "sig": ""
}
```

Where:
- `origin` is the user's origin server
- `keys` is the users public key pair
- `status` is a [Status](./Status.md) object
- `sig` is the signature of the profile

### Server Signed

In most cases however, their origin server will be involved in the creation of a signed user identifier that they will use for most purposes.

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
            "marks": {
                "sig": {
                    "dir": 0,
                    "com": "",
                    "usr": ""   
                },
            }
        },
        "sig": ""
    },
    "sig": ""
}
    
```

Where
- `marks` is an array of [Remarks](./Reputation/Remark.md).
- The 1st `package` is the user provided info and server context.
- The 1st `sig` is the server signature for the new package.

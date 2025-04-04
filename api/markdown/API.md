# API

The plan for the API is to have a REST API that can be used to interact with the system. Due to the nature of the
project, some parts of the API will actually be WebSockets.

Notes:

- The specified version in this document is `v1`.
- All requests must be made to the `/api/v1` endpoint.
- All requests are made over HTTPS.

## Authentication

To be able to used the API, you must have a token granted to your account. This token will be used to authenticate
your requests. The token will be sent in the `Authorization` header of the request.

In order to obtain a token, you must first create an account. This can be done using the `/users` endpoint. Once you
have an account, you must verify your email address by clicking the link sent to your email. After that, you can use
the `/auth` endpoint to obtain a token.

## Endpoints

### /users

#### POST

Note that this is the only endpoint that does not require authentication.

Create a new user. The body of the request must contain a JSON object with the following fields:

- `email`: The email address of the user. This will be used to log in.
- `password`: The password of the user. This will be used to log in.
- `username`: The username of the user. This will be displayed to other users.
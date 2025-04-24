# API

The API has two distinct components, the HTTPS endpoints and the WebSocket actions. This document will only cover the HTTPS endpoints, as the WebSocket actions are too numerous to contian in one document.

Notes:

- The specified version in this document is `v1`.
- All requests must be made to the `/api/v1` endpoint.
- All requests are made over HTTPS.

## Authentication

To be able to use the API, you must posess an API token. The process for obtaining an API token is described in [this document](./api/markdown/processes/API-Token.md)

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
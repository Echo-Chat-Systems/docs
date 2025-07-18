# TODO

## All REST Endpoints

-

## All WS Endpoints And Actions

- `auth`
  - `signin-start`
  - `signin-challenge` (Server -> User)
  - `signin-response`
  - `signin-complete` (Server -> User)
  - `signout`
- `users`
  - `get-profile` (Any public profile)
  - `get-self` (All current user information including settings)
  - `update-profile` (status is included)
  - `rep-add` (adds a reputation remark to a specific profile)
- `guilds`
  - `create`
  - `delete`
  - `get`
  - `update`
  - `list` (guilds user has access to)
- `invites` (guild invites)
  - `create`
  - `get`
  - `update`
  - `delete`
  - `list` (list invites in a specified guild)
  - `list-mine` (list pending invites addressed to this user)
- `channels`
  - `create`
  - `delete`
  - `get`
  - `update`
  - `list`
- `messages`
  - `send`
  - `edit`
  - `delete`
  - `get-single`
  - `get-many`
- `postie`
  - `subscribe`
  - `unsubscribe`
  - `event` (Server -> Client)
- `admin` (not implemented)
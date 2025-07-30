# TODO

- Add some react magic to permissions.mdx to do interactive rendering and display for the bitmask

## All REST Endpoints

-

## All WS Endpoints And Actions

✅

| Target     | Action             | Description                                                               | Completed |
|------------|--------------------|---------------------------------------------------------------------------|-----------|
| `auth`     | `signin-start`     | Starts the sign-in flow by sending the user’s public key                  | ✅         |
| ~          | `signin-challenge` | Server sends challenges for signing and encryption                        | ✅         |
| ~          | `signin-response`  | User responds to the challenge using their keys                           | ✅         |
| ~          | `signin-complete`  | Server confirms sign-in and sends session information                     | ✅         |
| ~          | `signout`          | Signs out the current session                                             | ✅         |
| ~          | `signup`           | Registers a new user with keys and basic profile info                     | ✅         |
| `users`    | `get`              | Retrieves a public user by ID                                             | ✅         |
| ~          | `get-self`         | Retrieves full private user information including settings                | ✅         |
| ~          | `update`           | Updates user profile and status                                           | ✅         |
| ~          | `rep-add`          | Adds a reputation remark to a profile                                     | ✅         |
| ~          | `rep-del`          | Allows a user to delete a reputation remark they have previously made.    | ✅         |
| ~          | `rep-query`        | Allows a user to query what reputation remarks they have made in the past | ✅         |
| `guilds`   | `create`           | Creates a new guild                                                       | ✅         |
| ~          | `delete`           | Deletes a guild                                                           | ✅         |
| ~          | `get`              | Retrieves guild metadata                                                  | ✅         |
| ~          | `update`           | Updates guild information                                                 |           |
| ~          | `list`             | Lists guilds the user has access to                                       |           |
| `roles`    | `list`             | List all roles in a guild the user is in                                  |           |
| ~          | `create`           | Creates a new role.                                                       |           |
| ~          | `delete`           | Deletes a role                                                            |           |
| ~          | `update`           | Updates a role.                                                           |           | 
| ~          | `assign`           | Assigns a role to a user                                                  |           |
| ~          | `revoke`           | Revokes a role from a user                                                |           |
| `invites`  | `create`           | Creates an invite for a guild                                             |           |
| ~          | `get`              | Retrieves a specific invite                                               |           |
| ~          | `update`           | Updates an existing invite                                                |           |
| ~          | `delete`           | Deletes an invite                                                         |           |
| ~          | `list`             | Lists all invites for a specified guild                                   |           |
| ~          | `list-incoming`    | Lists all invites addressed to the current user                           |           |
| `channels` | `create`           | Creates a new channel in a guild                                          |           |
| ~          | `delete`           | Deletes a channel                                                         |           |
| ~          | `get`              | Retrieves metadata for a single channel                                   |           |
| ~          | `update`           | Updates channel metadata                                                  |           |
| ~          | `list`             | Lists all channels in a guild                                             |           |
| `messages` | `send`             | Sends a message to a channel                                              |           |
| ~          | `edit`             | Edits a previously sent message                                           |           |
| ~          | `delete`           | Deletes a message                                                         |           |
| ~          | `get`              | Retrieves a specific message                                              |           |
| ~          | `query`            | Retrieves multiple messages from a channel                                |           |
| ~          | `react-add`        | Adds a reaction to a message                                              |           |
| ~          | `react-remove`     | Removes a reaction from a message                                         |           |
| ~          | `reacts-edit`      | Moderation endpoint to alter reactions                                    |           |
| `social`   | `send`             | Sends a friend request to a specified user-id or username-tag combo       |           |
| ~          | `get-incoming`     | Gets all incoming friend requests.                                        |           |
| ~          | `get-outgoing`     | Gets all outgoing friend requests.                                        |           |
| ~          | `respond`          | Accepts or declines an incoming friend request.                           |           |
| ~          | `cancel`           | Cancels an outgoing friend request                                        |           |
| `postie`   | `subscribe`        | Subscribes to a topic or data feed                                        |           |
| ~          | `unsubscribe`      | Unsubscribes from a topic or data feed                                    |           |
| ~          | `event`            | Server-sent event pushed to subscribed clients                            |           |
| `admin`    | –                  | Reserved for future administrative commands                               |           |


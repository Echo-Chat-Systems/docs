# Websockets API

The Echo-API makes extremely extensive use of websockets to provide most services. All functions of the API are performed within the context of a signluar websocket connection. 

## Table of Contents

<!-- TOC -->
* [Websockets API](#websockets-api)
  * [Table of Contents](#table-of-contents)
  * [Schema](#schema)
  * [Global Actions](#global-actions)
    * [Ping (`ping`)](#ping-ping)
<!-- TOC -->

## Schema

All websockets communication with the Echo-API is done using schema-enforced JSON objects. Each endpoint has their own 
sub-schema dependent on the actions they support. 

General usage of the server occurs through the `/ws` endpoint. This endpoint establishes a connection to the server and
allows for the sending of actions and receiving of responses.

Client communication with the server must follow the following schema:

```json
{
    "target": "target_endpoint",
    "data": {
        "action": "endpoint_action",
        "params": {}
    }
}
```

The server directs the data to the appropriate endpoint dictated by the `target` and de-encapsulates the first `data` object.
All other information outside of these required keys is ignored.

## Global Actions

The websocket gateway provides the following global target commands:

| Name               | Code   |
|--------------------|--------|
| [Ping](#ping-ping) | `ping` |

### Ping (`ping`)

Basic debug action used to test the link.

Always responds with `{"target": "pong"}`.
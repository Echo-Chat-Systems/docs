# Status

Echo represents statuses as a JSON object internally. This object has two fields: `type` and `text`.

The `type` field can be one of the values in this enum:

```csharp
public enum StatusType
{
	Offline = 0,
	Online = 1,
	Away = 2,
	DoNotDisturb = 3,
	Playing = 4,
	Watching = 5,
	Listening = 6,
	Custom = 7
}
```

When constructing the status object, the `type` field must be one of the values in the enum. The `text` field is a
string that can be set to any value.

Example for default status

```json
{
  "type": 0,
  "text": ""
}
```

Example for default online status

```json
{
  "type": 1,
  "text": ""
}
```

Example for playing Skyrim. The `text` field is set to " Skyrim" (note the leading space) as the client will display the
status as "Playing Skyrim".

```json
{
  "type": 4,
  "text": " Skyrim"
}
```

Example for custom status. The `text` field is user-controlled.

```json
{
  "type": 7,
  "text": "This is a custom status"
}
```

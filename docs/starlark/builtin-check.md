# Builtin: `Check(..)`

`Check` registers hooks.

```python
Check(
	name = "string",
	after_response = lambda ctx: bla(ctx),
	tags = ["some", "optional", "string", "list"],
	state = {
		"an": "optional",
		"string keys": "dict",
	},
)
```

Checks have a unique name.

Tags can be attached to checks so `monkey fuzz --tags=some,list` skips checks which do not 
contain the tags `"some"` or `"list"` (or both). See also: `--exclude-tags`.

The `after_response` hook takes one positional argument: `ctx` where `ctx.state` is mutable and initially set to `state` (or the empty dict).

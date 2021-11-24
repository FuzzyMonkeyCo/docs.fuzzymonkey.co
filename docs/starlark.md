# The Stalark Language


>Starlark is a dialect of Python intended for use as a configuration language. Like Python, it is an untyped dynamic language with high-level data types, first-class functions with lexical scope, and garbage collection. Unlike CPython, independent Starlark threads execute in parallel, so Starlark workloads scale well on parallel machines. Starlark is a small and simple language with a familiar and highly readable syntax.

For a comprehensive guide visit [docs.bazel.build](https://docs.bazel.build/versions/main/skylark/language.html).

See the [official specification](https://github.com/bazelbuild/starlark/blob/master/spec.md).

See the [language design document](https://github.com/bazelbuild/starlark/blob/master/design.md).

TODO: generate here from https://github.com/bazelbuild/bazel/blob/2c13ea7eb3de2a6c095821faabf9c0a499fb2061/src/main/java/net/starlark/java/eval/StarlarkList.java#L60


## Builtins

Built-ins are additions to Starlark for use in the context of `monkey`.


### Builtin: `Check(..)`

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


### Builtin: `Env(..)`

`Env` reads and freezes values of OS environment. What isn't explicitely read is not considered as having an impact on the system under test.

```python
Env("my_var", "its default value")
```

Evaluation stops if the variable isn't set and no default value was provided.



### Spec: `OpenAPIv3(..)`
TODO
```python
OpenAPIv3(
    name = "string",

    file = "string",
    host = "string",
    header_authorization = "an optional string",

	ExecReset = "an optional string",
	ExecStart = "an optional string",
	ExecStop = "an optional string",
)
```



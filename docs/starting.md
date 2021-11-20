# Getting started

```shell
monkey init --OpenAPIv3 my/file.yaml --OpenAPIv3-host http://localhost:4000
```
See ./monkey/init.md

Gives:
https://squidfunk.github.io/mkdocs-material/reference/code-blocks/#adding-a-title
```python
OpenAPIv3(
    name = "my_{{info.name}}-{{info.version}}",

    file = "{{from args}}",
    host = "{{from args}}",
    # header_authorization = "Bearer {}".format(Env("DEV_API_KEY")),

	ExecReset = """
	true
	""",
)

## Ensure a general property about response times

Check(
    name = "responds_in_a_timely_manner",
    after_response = lambda ctx: assert.that(ctx.response.elapsed_ns).is_at_most(500e6),
    tags = ["timing"],
)
```

We'll come back to this. First let's generate tests!

```shell
monkey fuzz
```

<!-- TODO -->
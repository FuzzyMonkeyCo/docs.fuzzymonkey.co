# An example configuration file for fuzzymonkey.co's `monkey`.

## A spec describing Web APIs in the OpenAPIv3 format

# Documentation validation errors will show up when running
# * `monkey lint` or
# * `monkey fuzz`
# as documentation validation is the first step of fuzzing.
# Note though that once that beofre the 'start' step is executed,
#  no changes to documentation will be taken into account.

monkey.openapi3(
    name = "my_simple_spec",
    # A typo was introduced in the documentation!
    file = "priv/openapi3v1_typo.json",
    host = "http://localhost:6773",
)

monkey.shell(
    name = "my_simple_spec_implementation",
    provides = ["my_simple_spec"],

    # Start
    start = """
echo Starting...
until (RELX_REPLACE_OS_VARS=true ./_build/prod/rel/sample/bin/sample status) 1>&2; do
    (RELX_REPLACE_OS_VARS=true ./_build/prod/rel/sample/bin/sample daemon) 1>&2
    sleep 1
done
echo Started
""",

    # Stop
    stop = """
echo Stopping...
RELX_REPLACE_OS_VARS=true ./_build/prod/rel/sample/bin/sample stop || true
echo Stopped
""",
)

## A simple check that runs after every HTTP call

monkey.check(
    name = "responds_within_300ms",
    after_response = lambda ctx: assert that(ctx.response.elapsed_ms).is_at_most(300),
    tags = ["timing"],
)

## A stateful model checking our CRUD Web app

def matches(ctx, method, path, status):
    return all([
        ctx.request.method == method,
        path in ctx.request.url,
        ctx.response.status_code == status,
    ])

def url_item_id(req):
    start = req.url.index("/item/")
    id_str = req.url[start + len("/item/"):]
    return str(int(id_str))

def model_single_user(ctx):
    """A user model of my Web app that stores items"""

    # Remove all items from model state
    if matches(ctx, "DELETE", "/items", 204):
        ctx.state.clear()
        return

    # Compare items seen with remote data
    if matches(ctx, "GET", "/items", 200) and ctx.response.body != []:
        body = ctx.response.body
        for item_id, item in ctx.state.items():
            assert that(item).is_in(body)
        return

    # Remove item from model state
    if matches(ctx, "DELETE", "/item/", 204):
        item_id = url_item_id(ctx.request)
        ctx.state.pop(item_id, None)
        return

    # Add/update a single item in model state
    if any([
        matches(ctx, "PUT", "/item/", 201),
        matches(ctx, "POST", "/item/", 200),
        matches(ctx, "PATCH", "/item/", 200),
    ]):
        item = ctx.response.body
        item_id = str(int(item["id"]))
        ctx.state[item_id] = item
        return

    # Check reading an item matches model state
    if matches(ctx, "GET", "/item/", 200):
        item = ctx.response.body
        item_id = str(int(item["id"]))
        if item_id in ctx.state:
            assert that(ctx.state[item_id]).is_equal_to(item)
        return

monkey.check(
    name = "some_simple_web_app_model",
    after_response = model_single_user,
    state = {},  # map of ItemID (str) to Item (dict)
    tags = ["crud", "api_contract"],
)

def verify_overwriting(ctx):
    """Ensure PATCH returns it's input untouched"""

    #
    # Note: you can ensure your assertions work as you intend
    #
    # This passes (which can be surprising):
    assert that({"my": "value"}).contains_all_in({"my": 42})
    # This however fails:
    # assert that({"my": "value"}).contains_all_in({"key": 42})

    if not matches(ctx, "PATCH", "/item/", 200):
        return

    # Ensure an item gets merged correctly
    patch = ctx.request.body
    print("Updating item #{}\n  with: {}".format(url_item_id(ctx.request), patch))

    # PATCH /item/{item_id} returns the ID in the body
    merged = {k: v for k, v in ctx.response.body.items() if k != "id"}

    # Ensures all pairs in request payload appear in response body
    for key, value in patch.items():
        assert that(merged).contains_item(key, value)

monkey.check(
    name = "verify_overwriting",
    after_response = verify_overwriting,
    tags = ["api_contract"],
)

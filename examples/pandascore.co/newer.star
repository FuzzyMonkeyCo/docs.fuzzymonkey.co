model = "newer"
print("Using model:", model)

monkey.openapi3(
    name = model,
    file = "pandascore_2.23.1.yml",
)

monkey.shell(
    name = "id",
    provides = [model],
    reset = "true",
)

model = "bigger"
print("Using model:", model)

monkey.openapi3(
    name = model,
    file = "pandascore.json",
)

monkey.shell(
    name = "id",
    provides = [model],
    reset = "true",
)

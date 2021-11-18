# Builtin: `Env(..)`

`Env` reads and freezes values of OS environment. What isn't explicitely read is not considered as having an impact on the system under test.

```python
Env("my_var", "its default value")
```

Evaluation stops if the variable isn't set and no default value was provided.

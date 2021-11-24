# Updating `monkey`

This page describes how to update `monkey`.

TODO

See the [Backwards Compatibility](./backwards-compatibility.md) notes to understand what this involves for tests and specification owners.


Failing tests are guaranteed to always be generatable by FuzzyMonkey. `monkey` follows a continuous release process which may add new features.
Running failing tests with an old seed will first try to reproduce the issue then try and reproduce it with the newer tools that `monkey` offers.

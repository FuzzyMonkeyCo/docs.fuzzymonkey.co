# `monkey` usage

```
monkey M.m.p go1.15.5 linux amd64

Usage:
  monkey [-vvv] fuzz [--intensity=N] [--seed=SEED] [--label=KV]...
                     [--tags=TAGS | --exclude-tags=TAGS]
                     [--no-shrinking]
                     [--progress=PROGRESS]
                     [--time-budget-overall=DURATION]
                     [--only=REGEX]... [--except=REGEX]...
                     [--calls-with-input=SCHEMA]... [--calls-without-input=SCHEMA]...
                     [--calls-with-output=SCHEMA]... [--calls-without-output=SCHEMA]...
  monkey [-vvv] lint [--show-spec]
  monkey [-vvv] fmt [-w]
  monkey [-vvv] schema [--validate-against=REF]
  monkey [-vvv] exec (repl | start | reset | stop)
  monkey [-vvv] env [VAR ...]
  monkey        logs [--previous=N]
  monkey        pastseed
  monkey [-vvv] update
  monkey        version | --version
  monkey        help    | --help    | -h

Options:
  -v, -vv, -vvv                   Debug verbosity level
  version                         Show the version string
  update                          Ensures monkey is the latest version
  --intensity=N                   The higher the more complex the tests [default: 10]
  --time-budget-overall=DURATION  Stop testing after DURATION (e.g. '30s' or '5h')
  --seed=SEED                     Use specific parameters for the Random Number Generator
  --label=KV                      Labels that can help classification (format: key=value)
  --tags=TAGS                     Only run Check.s whose tags match at least one of these (comma separated)
  --progress=PROGRESS             dots, bar, ci (defaults: dots)
  --only=REGEX                    Only test matching calls
  --except=REGEX                  Do not test these calls
  --calls-with-input=SCHEMA       Test calls which can take schema PTR as input
  --calls-without-output=SCHEMA   Test calls which never output schema PTR
  --validate-against=REF          Schema $ref to validate STDIN against

Try:
     export FUZZYMONKEY_API_KEY=42
  monkey update
  monkey exec reset
  monkey fuzz --only /pets --calls-without-input=NewPet --seed=$(monkey pastseed)
  echo '"kitty"' | monkey schema --validate-against=#/components/schemas/PetKind
```

<!-- TODO: a subcategory per subcommand -->
<!-- TODO: examples and notes/suggestions -->

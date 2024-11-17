# bits-coq

[![CI](https://github.com/henrytill/bits-coq/actions/workflows/ci.yml/badge.svg)](https://github.com/henrytill/bits-coq/actions/workflows/ci.yml)

Creating a local opam switch for this project:

```sh
opam switch create ./ ocaml-system --repos default,coq-released=https://coq.inria.fr/opam/released  --deps-only --with-test
```

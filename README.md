# External consumer of an internal type re-export

Keep this repository beside the provider repository, with directory names
`consumer` and `library`. `moon.work` resolves the library locally while keeping
the two modules distinct. Run the commands below from this directory.

Toolchain tested: moon 0.1.20261021 (a4f8933), moonc
v0.10.17+093cb8f9c (2026-10-21).

## Results

| Case | Result |
| --- | --- |
| Library's own `y/y_test.mbt` | 3 tests pass on wasm, wasm-gc, js, native |
| External `@y.TypeA::VariantA` | Compiler error 4037: owning internal package is not imported |
| External `(value : @y.TypeA).method1()` | Compiler error 4037: owning internal package is not imported |
| External qualified `ResolveError` catch | Compiler error 4037 |
| External inferred `CurrentDirectoryUnavailable` catch | Compiler error 4037 |
| Same API with a non-internal owner | 3 tests pass on all four backends |
| Direct import of the internal owner | Rejected by internal visibility rules |

The enum and suberror use `pub(all)`, and the method is `pub`, so constructor
privacy is not the reason for these failures. The facade uses `pub using`.
The ordinary consumer tests import only the public facade.

## Reproduce

Passing controls:

```sh
moon test ../library/y --target all --deny-warn
moon test public_control --target all --deny-warn
```

Expected compiler failures (run separately):

```sh
moon check constructor --target all --deny-warn
moon check method --target all --deny-warn
moon check error --target all --deny-warn
moon check error_inferred --target all --deny-warn
```

The direct-import control has a disabled manifest because an illegal import
prevents package resolution for the entire workspace. Temporarily enable it,
observe the package-visibility error, and disable it again:

```sh
mv direct_internal/moon.pkg.disabled direct_internal/moon.pkg
moon check direct_internal --deny-warn
mv direct_internal/moon.pkg direct_internal/moon.pkg.disabled
```

A workspace-wide `moon check` or `moon test` is expected to fail: this repository
deliberately preserves negative test cases. It does not claim that every
package should compile. Build outputs are ignored; generated library `.mbti`
files are included for inspection.

## Implication for public APIs

An in-module black-box test can pass while external consumers cannot construct,
match, or call methods on an internal type re-export. Public concrete types
should be owned by a public package. For the path API, move the shared error to
a public package such as `path/error` and re-export it from the facade packages.

# Architecture

This document describes the high-level architecture of StringToNumber.
If you want to familiarize yourself with the codebase, you are in the
right place.

## Bird's Eye View

StringToNumber converts French written numbers into Ruby integers. A
string like `"deux millions trois cent mille"` goes in, and `2_300_000`
comes out.

The conversion pipeline is:

1. **Normalize** — downcase and strip whitespace
2. **Cache lookup** — return immediately if this string was converted before
3. **Parse** — recursively decompose the French phrase into factor/multiplier
   pairs (e.g. `cinq` × `cent` = 500), then sum the parts
4. **Cache store** — save the result for future lookups

The parsing relies on two data tables: direct word-to-value mappings
(`WORD_VALUES`) and power-of-ten multipliers (`MULTIPLIERS`). French
number grammar has irregular patterns — especially the `quatre-vingt`
(4×20) family — that require dedicated regex handling.

## Code Map

### `lib/string_to_number.rb`

Public API module. Exposes three class methods: `in_numbers`,
`clear_caches!`, and `cache_stats`. Also provides `valid_french_number?`
for input validation.

This file is the only entry point consumers interact with. It delegates
to either `Parser` or `ToNumber` based on the `use_optimized` flag
(default: `true`).

Key methods: `StringToNumber.in_numbers`, `StringToNumber.valid_french_number?`.

### `lib/string_to_number/parser.rb`

High-performance parser. Owns all caching logic (LRU conversion cache,
instance cache) and thread-safety (two mutexes: `@cache_mutex` for
conversions, `@instance_mutex` for parser instances).

The parsing algorithm mirrors `ToNumber`'s recursive extraction but
operates on pre-compiled regex patterns (`MULTIPLIER_PATTERN`,
`QUATRE_VINGT_PATTERN`) instead of building them per call.

Key types: `Parser.convert` (class-level entry point),
`Parser#parse_optimized` and `Parser#extract_optimized` (recursive core).

**Architecture Invariant:** `Parser` imports data tables from `ToNumber`
(`WORD_VALUES = ToNumber::EXCEPTIONS`) but never calls `ToNumber` methods.
The dependency is data-only.

### `lib/string_to_number/to_number.rb`

Original (legacy) implementation. Owns the canonical data tables:
`EXCEPTIONS` (word-to-value map for 0–90 plus regional variants) and
`POWERS_OF_TEN` (multiplier words to exponent values, up to `googol`).

Uses the same recursive `extract`/`match` algorithm as `Parser` but
rebuilds regex patterns on every instantiation and has no caching.

Key types: `ToNumber::EXCEPTIONS`, `ToNumber::POWERS_OF_TEN`,
`ToNumber#to_number`.

**Architecture Invariant:** `ToNumber` has no knowledge of `Parser`.
It must remain independently functional for backward compatibility.

### `lib/string_to_number/version.rb`

Single constant `StringToNumber::VERSION`. Updated before gem releases.

### `spec/`

RSpec test suites. `string_to_number_spec.rb` covers correctness across
number ranges (0–9, 10–19, 20–29, ..., millions). `performance_spec.rb`
validates throughput thresholds.

### `benchmark.rb`, `microbenchmark.rb`, `profile.rb`, `performance_comparison.rb`

Standalone scripts for measuring and profiling performance. Not part of
the gem distribution (excluded by gemspec).

## Invariants

`Parser` depends on `ToNumber` for data constants only, never for
parsing logic. This keeps the legacy implementation independently
testable while the optimized path reuses proven word mappings.

All shared mutable state lives in `Parser`'s class-level instance
variables and is accessed exclusively through `@cache_mutex` or
`@instance_mutex`. No other module holds mutable state.

The `EXCEPTIONS` and `POWERS_OF_TEN` hashes in `ToNumber` are frozen.
Any new word mapping must be added there — `Parser` inherits changes
automatically.

Load order matters: `to_number.rb` must be required before `parser.rb`
because `Parser` references `ToNumber::EXCEPTIONS` and
`ToNumber::POWERS_OF_TEN` at class body evaluation time.

## Cross-Cutting Concerns

**Caching.** Two layers in `Parser`: an LRU conversion cache (string →
integer, capped at 1000 entries) and an instance cache (string → Parser
object). Both are thread-safe. Call `StringToNumber.clear_caches!` to
reset.

**Thread safety.** Achieved through two separate mutexes to reduce
contention — one for conversion results, one for parser instances.
`ToNumber` is not thread-safe but is stateless per call, so concurrent
use is safe in practice.

**Testing.** RSpec with two suites: correctness (`spec/string_to_number_spec.rb`)
and performance (`spec/performance_spec.rb`). Run both via `rake spec`
or individually with `bundle exec rspec <file>`.

## A Typical Change

**Adding a new French number word** (e.g., a regional variant):

1. Add the word-to-value mapping in `ToNumber::EXCEPTIONS` or
   `ToNumber::POWERS_OF_TEN` in `lib/string_to_number/to_number.rb`
2. Add test cases in `spec/string_to_number_spec.rb`
3. Run `rake spec` — `Parser` picks up the new mapping automatically
   since it references `ToNumber`'s constants

No changes to `parser.rb` or `string_to_number.rb` are needed.

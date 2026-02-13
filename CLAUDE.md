# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

Ruby gem that converts French written numbers into integers. Single public entry point: `StringToNumber.in_numbers(french_string)`.

## Commands

```bash
bundle install              # Install dependencies
rake spec                   # Run all tests (correctness + performance)
bundle exec rspec spec/string_to_number_spec.rb       # Correctness tests only
bundle exec rspec spec/performance_spec.rb            # Performance tests only
bundle exec rspec spec/string_to_number_spec.rb -e "vingt"  # Run single test by name
rake rubocop                # Lint (or: bundle exec rubocop)
rake                        # Default: rubocop + spec
rake console                # Interactive REPL with gem loaded
```

## Architecture

Three files under `lib/` matter:

- `lib/string_to_number.rb` — public API module. Delegates to `Parser` (default) or `ToNumber` (legacy, via `use_optimized: false`).
- `lib/string_to_number/parser.rb` — optimized implementation. Owns all caching (LRU + instance cache) and thread-safety (two mutexes). Imports data tables from `ToNumber` but never calls its methods.
- `lib/string_to_number/to_number.rb` — legacy implementation. Owns the canonical data tables: `EXCEPTIONS` (word→value) and `POWERS_OF_TEN` (multiplier→exponent). Must be loaded before `parser.rb`.

**Key constraint:** New word mappings go in `ToNumber::EXCEPTIONS` or `ToNumber::POWERS_OF_TEN` — `Parser` inherits them automatically. Don't duplicate data between the two implementations.

Both parsers use the same recursive algorithm: decompose input into `factor × multiplier` pairs via regex, with special-case handling for `quatre-vingt` forms.

See `docs/ARCHITECTURE.md` for the full code map and invariants.

## Style

- RuboCop enforced (`rake rubocop`). Config in `.rubocop.yml`.
- Single quotes for strings. `frozen_string_literal: true` in every file.
- Max line length: 120 (specs exempt).
- Target Ruby: 2.7+.

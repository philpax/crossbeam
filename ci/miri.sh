#!/bin/bash
set -euxo pipefail
IFS=$'\n\t'
cd "$(dirname "$0")"/..

export RUSTFLAGS="${RUSTFLAGS:-} -Z randomize-layout"

MIRIFLAGS="-Zmiri-strict-provenance -Zmiri-symbolic-alignment-check -Zmiri-disable-isolation" \
    cargo miri test \
    -p crossbeam-queue \
    -p crossbeam-utils

# -Zmiri-ignore-leaks is needed because we use detached threads in tests/docs: https://github.com/rust-lang/miri/issues/1371
MIRIFLAGS="-Zmiri-strict-provenance -Zmiri-symbolic-alignment-check -Zmiri-disable-isolation -Zmiri-ignore-leaks" \
    cargo miri test \
    -p crossbeam-channel

# -Zmiri-disable-stacked-borrows is needed for https://github.com/crossbeam-rs/crossbeam/issues/545
MIRIFLAGS="-Zmiri-check-number-validity -Zmiri-symbolic-alignment-check -Zmiri-disable-isolation -Zmiri-disable-stacked-borrows" \
    cargo miri test \
    -p crossbeam-epoch

# -Zmiri-ignore-leaks is needed for https://github.com/crossbeam-rs/crossbeam/issues/614
# -Zmiri-disable-stacked-borrows is needed for https://github.com/crossbeam-rs/crossbeam/issues/545
MIRIFLAGS="-Zmiri-check-number-validity -Zmiri-symbolic-alignment-check -Zmiri-disable-isolation -Zmiri-disable-stacked-borrows -Zmiri-ignore-leaks" \
    cargo miri test \
    -p crossbeam-skiplist

MIRIFLAGS="-Zmiri-check-number-validity -Zmiri-symbolic-alignment-check -Zmiri-compare-exchange-weak-failure-rate=1.0" \
    cargo miri test \
    -p crossbeam-deque

MIRIFLAGS="-Zmiri-check-number-validity -Zmiri-symbolic-alignment-check" \
    cargo miri test \
    -p crossbeam

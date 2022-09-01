---
title: "Testing debug info of optimised programs"
date: 2022-09-15
publishDate: 2022-09-01
summary:
  "In this preliminary work, we symbolically execute unoptimised and optimised
  versions of a program which are then checked for debug info consistency. We
  expect this to allow testing correctness of debug info generation across a
  much larger portion of the compiler."
---

Workshop talk to be presented at [KLEE 2022](https://srg.doc.ic.ac.uk/klee22/)

## Abstract

Debuggers rely on compiler-produced metadata to present correct variable values
and line numbers in the source language. While this tends to work for
unoptimised programs, current compilers either throw away or corrupt debugging
info in optimised programs. Current approaches for testing debug info rely on
manual test cases or only reach a small portion of the compiler. In this
preliminary work, we symbolically execute unoptimised and optimised versions of
a program which are then checked for debug info consistency. We expect this to
allow testing correctness of debug info generation across a much larger portion
of the compiler.

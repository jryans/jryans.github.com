---
title: "Accurate coverage metrics for compiler-generated debugging information"
date: 2024-04-11
lastmod: 2024-07-13
summary:
  "In this talk, we propose some new metrics, computable by our tools, which
  could serve as motivation for language implementations to improve debugging
  quality."
---

Conference talk ([video](https://www.youtube.com/watch?v=LePAdLTRa4Q), [slides](</talks/2024/EuroLLVM/Debug info metrics.pdf>))
presented at [EuroLLVM 2024](https://llvm.swoogo.com/2024eurollvm/agenda)

[![](video.png)](https://www.youtube.com/watch?v=LePAdLTRa4Q)

This talk covers research I worked on together with Stephen Kell. See also our
CC 2024 [paper](/cv/#debug-info-metrics) on this topic.

## Abstract

Many debugging tools rely on compiler-produced metadata to present a
source-language view of program states, such as variable values and source line
numbers. While this tends to work for unoptimised programs, current compilers
often generate only partial debugging information in optimised programs. Current
approaches for measuring the extent of coverage of local variables are based on
crude assumptions (for example, assuming variables could cover their whole
parent scope) and are not comparable from one compilation to another. In this
talk, we propose some new metrics, computable by our tools, which could serve as
motivation for language implementations to improve debugging quality.

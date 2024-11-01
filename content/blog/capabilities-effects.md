---
title: "Fearless extensibility: Capabilities and effects"
date: 2024-11-01T16:10:32+00:00
tags: [Malleable, Challenge, Extensibility, Capabilities, Effects]
---

_This is a submission for the [fearless extensibility challenge
problem][problem] organised by the [Malleable Systems Collective][collective]._

---

Much of today's software limits user extensibility.
If you're lucky, there may be a plugin system of some kind,
but that will only support whatever actions
the upstream vendor imagines and deigns to support.
If it's open source, you could fork and customise,
but that's not accessible to most.
Even if you have the expertise,
it entails a pile of maintenance work to stay up to date.
If it's closed source,
you're essentially out of luck.

There have been some historical extension systems that allowed
a high degree of freedom (e.g. legacy Firefox extensions).
As mentioned by the [challenge problem][problem],
while those approaches may offer a high degree of user freedom,
they also open the door to malware and
create maintenance issues for the extension host.

This article explores one potential route forward using
capabilities, effects, and extension-time type checking
to provide a more predictable extension path for
users, extension authors, and platform maintainers alike.

## Disclaimers and assumptions

I've perhaps already spooked the dynamic language fans with words like
"type checking" and "effect" above... 😅
I'm not attempting to claim that static types are the only way here.
I just returned from SPLASH (an academic PL conference)
where several statically typed effects systems were in the air,
so my thoughts just happen to biased in that direction at the moment.
I've scribbled a few more thoughts about a dynamic version
towards the end in the Implementation section.

This article focuses on cases where
the source (or a typed IR derived from source)
for both the extension and the extension host are available,
as tooling would need to analyse the combination of both.

## Goal

The key ability we wish to achieve is arbitrary extension / modification of the
extension host while preserving safe and correct operation overall and also
permitting host maintainers to refactor without fear.

As an example,
let's imagine the host program we want to extend is a
graphics canvas (e.g. akin to Figma).
This host program has a built-in color picking feature
that displays a UI to choose a color
which is then added to the recent colors palette.
Our extension author would like to extend color picking
so that all colors are adjusted to meet accessibility standards.

```scala
// host
def pickColor() {
    val color = colorPicker.choose()
    palette.add(color)
}

// extension
def onClickPick() {
    // We want to call `host.pickColor`,
    // but we need adjust `color` before it goes into the palette
}
```

The only accessible and relevant API the host offers for extensions to use
for this case is the `pickColor` function, but our extension wants to add
behaviour in the middle of `pickColor`, so we can't use it as-is.

Dynamic languages might allow host functions like `pickColor`
to be copied by the extension and redefined,
but this is too broad for the change we wish to make.
The extension now needs to keep its modified `pickColor` up to date
with changes upstream in the host copy,
even though they aren't related to the behaviour it's adding.
From the host maintainer perspective,
you don't feel that you can safely refactor your code,
since every extension might contain old copies of host functions
that could break after your refactoring.

We'd like to express the intent of the extension's behaviour change
in a targeted and precise manner
that avoids these issues.

## Effects and capabilities

Before we get there, let's talk about effects.

[Effects][effects] are a (relatively) newer programming language concept that
allows tracking user-defined side effects as types (e.g. IO, memory access,
exceptions) and also supports effect handlers to take some action when these
effects occur. They've been percolating in experimental languages ([Koka][koka],
[Effekt][effekt], [Unison][unison]) for a while now, and are starting to appear
in more established ones ([Scala][scala], [OCaml][ocaml]).

If you haven't encountered effects before, I suggest skimming the
[Effekt][effekt] language site, as they have an approachable intro to the key
[concepts][effekt-concepts]. I don't think I can do it justice myself, and
introducing effects is beyond the scope of this article anyway.

Effect handlers can resume the computation that was suspended when the effect
occurred, and may even resume multiple times. Effects and their handlers
generalise many forms of control flow, including exceptions, generators, and
multithreading, allowing libraries to [flexibly provide][bt-practical] these
features, rather than requiring language designers to add special functionality
for each one.

Various works have [made][koka-handling] [connections][effekt-concepts]
between effects and capabilities.
A function that has e.g. a "file read" effect can be thought of as
requiring a "file read" capability.
Effect handlers can even be added to some existing languages
if we pass the handler / capability as an extra function argument
(referred to as "capability-passing style").

## Implicit effects

Effects systems today focus on what I'll call "explicit" effects: both the code
performing the effect and its corresponding handler are written explicitly in
the program source. If you want to model additional user-defined effects, you
would add both handlers and effect performing steps to do so.

We can also imagine "implicit" effects that represent existing language
operations. For example, function calls could be treated as an implicit effect.
If we then allow handlers to be defined for these implicit effects, we gain
quite powerful control over deeply nested code.

Extensions can leverage this ability to make arbitrary changes to the extension
host. While that is quite a powerful technique, the static types present in both
the host and extension help to ensure reasonable behaviour is maintained by
ensuring required values are still provided as expected.

This code modification ability bears some resemblance to the power of
[aspect-oriented programming][aop]. Effect systems (especially those with
lexical effect handlers) avoid the "spooky action at a distance" issue that can
make AOP approaches hard to understand. Additional tooling can help further by
highlighting modified operations in the combined system (host with extensions).
Some amount of surprising host control flow seems tolerable when we gain the
ability to make arbitrary changes via extensions. Extension-time type checking
should ameliorate some concerns by ensure all modules fit together as expected.

{{<callout icon="🚧">}}
This would be a good place to show a running example...
I'll try to add one in a future version.
{{</callout>}}

## Safety via capabilities and isolation

Host maintainers often fear nefarious extensions
may perform various undesirable actions.
Dangerous abilities (e.g. "delete home directory") can be avoided
by restricting or not providing those capabilities
to extension execution contexts.

In a system where extensions can modify deeply nested code,
there will likely be a need to isolate extensions
both from the host and from each other.
For example,
extension A uses handles a call effect to alter host function `foo`,
while extension B depends on its default behaviour.
Fortunately, the desired isolation falls out naturally
from a lexical effect handler model:
extension A's code modification is only active inside the scope of its handler.
It has no effect on other code paths in extension A,
and certainly not on other extensions.

It's likely ideal to go further and ensure execution contexts
actually are isolated from each other.
Existing concepts like
[mirrors][mirror],
[compartments][compartment], and
[realms][realm]
suggest a way forward.

## Extension host code changes

In today's dynamic systems where extension might mean
wholly replacing host functions with modified copies,
it can be hard to predict what madness may ensue
when the host platform refactors some code.
Issues usually only present themselves at run time
when the modified host code is somehow invoked,
or alternatively the modified code may be silently unused
if the extension includes
an outdated copy of a modified host function.

These concerns are easily avoided
when leveraging static types and
code modification via effects.
Effects allow for precision code modification,
so there's no need to copy an entire host function
just to modify one line.
Static types give extension-time assurance
that the extension and host continue to fit together
in a reasonable way.
If the host refactoring creates an incompatibility,
it will be clearly surfaced when trying to _load_ the extension
(which is far better than waiting until feature _use_).

## Open questions

We've examined a mechanism to modify code
nested beneath some function an extension calls,
but what if you need to modify some behaviour
that cannot be reached by any function exposed to extensions?
At first glance, it would seem like some form of reflection
is needed to gain access to these internals.
Perhaps a controlled form of reflection using
[mirrors as capabilities][mirrors-capabilities]...?
I am confident there's an elegant approach to be found
that integrates well with the thoughts on effects and capabilities above,
while avoiding the messy approaches of AOP.

## Implementation

This approach would seem to require an execution environment that
allows dynamically hooking / modifying code
in response to changes made by extensions.
While various [dynamic programming systems][tratt-dynamic]
like those associated with JavaScript, Smalltalk, Lisp, etc.
may have some support for this,
it's less likely to be found in the statically typed languages,
as those often assume type checking
should be paired with ahead-of-time compilation.

I imagine [metaobject protocols][mop]
(e.g. from Common Lisp, Smalltalk, etc.)
could accomplish similar modifications at run time.
The approach described here also makes uses of capabilities,
so [Newspeak][newspeak] might be the closest match among dynamic languages.

It's less clear to me how dynamically typed languages
might provide extension-time sanity checks,
so that's a big part of why I focused on a statically typed approach.
If you see a way to do something similar in a more dynamic environment,
please do let me know!

A few stacks that could allow for
type-checked extension-time code modification
include:

- Wasm with GC and stack switching extensions (plus additional metadata)
- Scala 3 (which preserves a [typed AST][tasty] for metaprogramming)

Are there other technologies that might be well suited to such an approach?
Please do let me know,
as it may save me quite a lot of time and energy
as I explore this idea further!

## Summary

In the article, we've taken a look at
(an in-progress sketch of)
one potential extensibility approach.
Is it complicated? Yes.
Is it over-engineered...? Perhaps.
I'm okay with jumping through a few hoops if it will restore deep extensibility
while also balancing safety and maintenance concerns.

I'd love to hear feedback on this!
Assuming I manage to stay focused on this topic,
I'd like to implementing an extension system using some of the ideas here.
There are clearly some rough edges and likely better alternate approaches, so do
let me know what comes to mind.

## Related work

As already mentioned, there are various languages that support some form of
effects, capabilities, or both, so do take a look at those.

There are many resources on
effects, capabilities, metaprogramming, etc.
that could be mentioned...
The list below mentions those that connect more directly
to the ideas in this article.
This is certainly not a comprehensive list...!

- Aleksander Boruch-Gruszecki, Adrien Ghosn, Mathias Payer, and Clément
Pit-Claudel. 2024. Gradient: Gradual compartmentalization via object
capabilities tracked in types. Proc. ACM Program. Lang. 8, OOPSLA2.
https://doi.org/10.1145/3689751

- Gilad Bracha and David Ungar. 2004. Mirrors:
Design principles for meta-level facilities of object-oriented programming
languages. In Proc. of OOPSLA ’04.
https://doi.org/10.1145/1028976.1029004

- Gilad Bracha. 2010. Through the looking glass darkly.
https://gbracha.blogspot.com/2010/03/through-looking-glass-darkly.html

- Jonathan Immanuel Brachthäuser, Philipp Schuster, and Klaus Ostermann. 2020.
Effects as capabilities: Effect handlers and lightweight effect polymorphism.
Proc. ACM Program. Lang. 4, OOPSLA.
https://doi.org/10.1145/3428194

- Jonathan Immanuel Brachthäuser. 2022. What you see is what you get:
Practical effect handlers in capability-passing style.
https://doi.org/10.1007/978-3-030-83128-8_3

- Chip Morningstar. 2017. What are capabilities?
http://habitatchronicles.com/2017/05/what-are-capabilities/

- Éric Tanter. 2006. Reflection and open implementations.
University of Chile.
https://www.dcc.uchile.cl/TR/2009/TR_DCC-20091123-013.pdf

- Jeremy Yallop. 2023. Effects bibliography.
https://github.com/yallop/effects-bibliography

[problem]: https://forum.malleable.systems/t/challenge-problem-fearless-extensibility/205
[collective]: https://malleable.systems

[tasty]: https://docs.scala-lang.org/scala3/guides/tasty-overview.html

[mop]: https://en.wikipedia.org/wiki/Metaobject
[tratt-dynamic]: https://tratt.net/laurie/research/pubs/html/tratt__dynamically_typed_languages/
[newspeak]: https://newspeaklanguage.org

[effects]: https://en.wikipedia.org/wiki/Effect_system

[koka]: https://koka-lang.github.io
[effekt]: https://effekt-lang.org
[unison]: https://www.unison-lang.org/docs/fundamentals/abilities/

[scala]: https://docs.scala-lang.org/scala3/reference/experimental/canthrow.html
[ocaml]: https://ocaml.org/manual/5.0/effects.html

[bt-practical]: https://doi.org/10.1007/978-3-030-83128-8_3

[koka-handling]: https://koka-lang.github.io/koka/doc/book.html#sec-handling
[effekt-concepts]: https://effekt-lang.org/docs/concepts/effect-safety

[aop]: https://en.wikipedia.org/wiki/Aspect-oriented_programming

[mirror]: https://en.wikipedia.org/wiki/Mirror_(programming)
[compartment]: https://github.com/tc39/proposal-compartments
[realm]: https://github.com/tc39/proposal-shadowrealm

[mirrors-capabilities]: https://gbracha.blogspot.com/2010/03/through-looking-glass-darkly.html

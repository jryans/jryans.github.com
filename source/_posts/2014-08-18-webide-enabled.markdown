---
layout: post
title: "WebIDE enabled in Nightly"
date: 2014-08-18 10:44
comments: true
categories: [Open Source, Mozilla, Developer Tools, Firefox OS]
---

I am excited to announce that [WebIDE][1] is now enabled by default in Nightly
(Firefox 34)!  Everyone on the App Tools team has been working hard to polish
this new tool that we originally [announced][2] back in June.

<iframe src="//www.youtube-nocookie.com/embed/n8c34wk4OnY?rel=0" allowfullscreen="" frameborder="0" height="315" width="560"></iframe>

## Features

While the previous App Manager tool was great, that tool's UX held us
back when trying support more complex workflows.  With the redesign into WebIDE,
we've already been able to add:

* Project Editing
  * Great for getting started without worrying about an external editor
* Project Templates
  * Easy to focus on content from the start by using a template
* Improved DevTools Toolbox integration
  * Many UX issues arose from the non-standard way that App Manager used the
    DevTools
* [Monitor][4]
  * Live memory graphs help diagnose performance issues

<img src="https://thefiletree.com/jan/shots/monitor/monitor.png"/>

## Transition

All projects you may have created previously in the App Manager are also
available in WebIDE.

While the App Manager is now hidden, it's accessible for now at
`about:app-manager`.  We do intend to remove it entirely in the future, so
it's best to start using WebIDE today.  If you find any issues, please [file bugs][3]!

## What's Next

Looking ahead, we have many more exciting things planned for WebIDE, such as:

* Command line integration
* Improved support for app frameworks like Cordova
* Validation that matches the Firefox Marketplace

If there are features you'd like to see added, [file bugs][3] or contact the
team via [various channels][5].

[1]: https://developer.mozilla.org/docs/Tools/WebIDE
[2]: https://hacks.mozilla.org/2014/06/webide-lands-in-nightly/
[3]: https://bugzilla.mozilla.org/enter_bug.cgi?product=Firefox&component=Developer%20Tools%3A%20WebIDE
[4]: https://developer.mozilla.org/docs/Tools/WebIDE/Monitor
[5]: https://wiki.mozilla.org/DevTools/GetInvolved#Communication

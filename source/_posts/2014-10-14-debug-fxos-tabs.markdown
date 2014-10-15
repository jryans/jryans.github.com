---
layout: post
title: "DevTools for Firefox OS browser tabs"
date: 2014-10-14 13:29
comments: true
categories: [Open Source, Mozilla, Developer Tools, Firefox OS]
---

We've had various tools for inspecting apps on remote devices for some time now,
but for a long time we've not had the same support for remote browser tabs.

To remedy this, [WebIDE][1] now supports inspecting browser tabs running on Firefox OS devices.

![Inspecting a tab in WebIDE][webide-tab]

A few weeks back, WebIDE gained support for [inspecting tabs][2] on the remote
device, but many of the likely suspects to connect to weren't quite ready for
various reasons.

We've just [landed][3] the necessary server-side bits for Firefox OS, so you
should be able try this out by updating your device to the next nightly build
after 2014-10-14.

## How to Use

After connecting to your device in WebIDE, any open browser tabs will appear at
the bottom of WebIDE's project list.

![Browser tab list in WebIDE][webide-tab-list]

The toolbox should open automatically after choosing a tab.  You can also toggle
the toolbox via the "Pause" icon in the top toolbar.

## What's Next

We're planning to make this work for Firefox for Android as well.  Much of
that work is already done, so I am hopeful that it will be available soon.

If there are features you'd like to see added, [file bugs][bugs] or contact the
team via [various channels][involved].

[1]: https://developer.mozilla.org/docs/Tools/WebIDE
[2]: https://bugzilla.mozilla.org/show_bug.cgi?id=1009604
[3]: https://bugzilla.mozilla.org/show_bug.cgi?id=975084
[bugs]: https://bugzilla.mozilla.org/enter_bug.cgi?product=Firefox&component=Developer%20Tools%3A%20WebIDE
[involved]: https://wiki.mozilla.org/DevTools/GetInvolved#Communication
[webide-tab]: /images/posts/webide-tab.png
[webide-tab-list]: /images/posts/webide-tab-list.png

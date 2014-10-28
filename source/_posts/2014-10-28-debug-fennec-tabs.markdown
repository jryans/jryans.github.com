---
layout: post
title: "Debugging Tabs with Firefox for Android"
date: 2014-10-28 16:08
comments: true
categories: [Open Source, Mozilla, Developer Tools, Firefox for Android]
---

For quite a while, it has been possible to debug tabs on Firefox for Android
devices, but there were many steps involved, including manual port forwarding
from the terminal.

As I [hinted][hint] a few weeks ago, [WebIDE][1] would soon support connecting
to Firefox for Android via ADB Helper support, and that time is now!

## How to Use

You'll need to assemble the following bits and bobs:

* Firefox 36 (2014-10-25 or later)
* ADB Helper 0.7.0 or later
* Firefox for Android 35 or later

Opening WebIDE for the first time should install ADB Helper if you don't already
have it, but double-check it is the right version in the add-on manager.

![Firefox for Android runtime appears][fennec-usb-runtime]

Inside WebIDE, you'll see an entry for Firefox for Android in the Runtime menu.

![Firefox for Android tab list][fennec-tab-list]

Once you select the runtime, tabs from Firefox for Android will be available in
the (now poorly labelled) apps menu on the left.

![Inspecting a tab in WebIDE][fennec-tab-toolbox]

Choosing a tab will open up the DevTools toolbox for that tab.  You can also
toggle the toolbox via the "Pause" icon in the top toolbar.

If you would like to debug Firefox for Android's system-level / chrome code,
instead of a specific tab, you can do that with the "Main Process" option.

## What's Next

We have even more connection UX improvements on the way, so I hope to have more
to share soon!

If there are features you'd like to see added, [file bugs][bugs] or contact the
team via [various channels][involved].

[1]: https://developer.mozilla.org/docs/Tools/WebIDE
[hint]: /blog/2014/10/14/debug-fxos-tabs/
[3]: https://bugzilla.mozilla.org/show_bug.cgi?id=975084
[bugs]: https://bugzilla.mozilla.org/enter_bug.cgi?product=Firefox&component=Developer%20Tools%3A%20WebIDE
[involved]: https://wiki.mozilla.org/DevTools/GetInvolved#Communication
[fennec-usb-runtime]: /images/posts/fennec-usb-runtime.png
[fennec-tab-list]: /images/posts/fennec-tab-list.png
[fennec-tab-toolbox]: /images/posts/fennec-tab-toolbox.png

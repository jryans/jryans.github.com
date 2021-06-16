---
title: "WiFi Debugging for Firefox for Android"
date: 2015-08-05 15:33
categories: [Open Source, Mozilla, Developer Tools, Firefox for Android]
---

I am excited to announce that we're now [shipping][impl] WiFi debugging for
Firefox for Android!  It's available in [Firefox for Android 42][fennec-nightly]
with [Firefox Nightly][desktop-nightly] on desktop.

The rest of this post will sound quite similar to the [previous announcement for
Firefox OS][fxos-post] support.

WiFi debugging allows [WebIDE][webide] to connect to Firefox for Android via
your local WiFi network instead of a USB cable.

The connection experience is generally more straightforward (especially after
connecting to a device the first time) than with USB and also more convenient to
use since you're no longer tied down by a cable.

## Security

A large portion of this project has gone towards making the debugging
connection secure, so that you can use it safely on shared network, such as an
office or coffee shop.

We use TLS for encryption and authentication.  The computer and device both
create self-signed certificates.  When you connect, a QR code is scanned to
verify that the certificates can be trusted.  During the connection process, you
can choose to remember this information and connect immediately in the future if
desired.

## How to Use

You'll need to assemble the following bits and bobs:

* [Firefox 42][desktop-nightly]
* [Firefox for Android 42][fennec-nightly]
* [Barcode Scanner Android app by ZXing Team][qr-reader] (for QR code scanning)

On your Android device:

1. Install the [Barcode Scanner Android app by ZXing Team][qr-reader]
2. Open Firefox for Android
3. Go to Developer Tools Settings on device (Settings -> Developer Tools)
4. Enable Remote Debugging via Wi-Fi

![Firefox for Android WiFi Debugging Options][fennec-wifi-opts]

To connect from Firefox Desktop:

1. Open WebIDE in Firefox Nightly (Tools -> Web Developer -> WebIDE)
2. Click "Select Runtime" to open the runtimes panel
3. Your Firefox for Android device should show up in the "WiFi Devices" section
4. A connection prompt will appear on device, choose "Scan" or "Scan and Remember"
5. Scan the QR code displayed in WebIDE

![WebIDE WiFi Runtimes][webide-wifi-runtime]
![WebIDE Displays the QR Code][webide-qr-code]

After scanning the QR code, the QR display should disappear and the "device"
icon in WebIDE will turn blue for "connected".

You can then access all of your remote browser tabs just as you can today over
USB.

## Technical Aside

This process does not use ADB at all on the device, so if you find ADB
inconvenient while debugging or would rather not install ADB at all, then
WiFi debugging is the way to go.  

By skipping ADB, we don't have to worry about driver confusion, especially on
Windows and Linux.

## Supported Devices

This feature should be supported on any Firefox for Android device.  So far,
I've tested it on the LG G2.

## Acknowledgments



Thanks to all who helped via advice and reviews while working on Android support,
including (in semi-random order):

* Margaret Leibovic
* Karim Benhmida

And from the larger WiFi debugging effort:

* Brian Warner
* Trevor Perrin
* David Keeler
* Honza Bambas
* Patrick McManus
* Jason Duell
* Panos Astithas
* Jan Keromnes
* Alexandre Poirot
* Paul Rouget
* Paul Theriault

I am probably forgetting others as well, so I apologize if you were omitted.  

## What's Next

If there are features you'd like to see added, [file bugs][bugs] or contact the
team via [various channels][involved].

[impl]: https://bugzil.la/1180996
[fxos-post]: /blog/2015/03/25/wifi-debug-fxos/

[bugs]: https://bugzilla.mozilla.org/enter_bug.cgi?product=Firefox&component=Developer%20Tools%3A%20WebIDE
[involved]: https://wiki.mozilla.org/DevTools/GetInvolved#Communication

[fennec-wifi-opts]: /images/posts/fennec-wifi-opts.png
[webide-wifi-runtime]: /images/posts/webide-wifi-runtime.png
[webide-qr-code]: /images/posts/webide-qr-code.png

[fennec-nightly]: https://nightly.mozilla.org/
[desktop-nightly]: https://nightly.mozilla.org/
[qr-reader]: https://play.google.com/store/apps/details?id=com.google.zxing.client.android
[webide]: https://developer.mozilla.org/docs/Tools/WebIDE

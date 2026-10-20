# AltStore

> AltStore is an alternative app store for non-jailbroken iOS devices. 

[![Swift Version](https://img.shields.io/badge/swift-5.0-orange.svg)](https://swift.org/)
[![License: AGPL v3](https://img.shields.io/badge/License-AGPL%20v3-blue.svg)](https://www.gnu.org/licenses/agpl-3.0)
[![PRs Welcome](https://img.shields.io/badge/PRs-welcome-brightgreen.svg?style=flat-square)](http://makeapullrequest.com)

AltStore is an iOS application that allows you to sideload other apps (.ipa files) onto your iOS device with just your Apple ID. AltStore resigns apps with your personal development certificate and sends them to a desktop app, AltServer, which installs the resigned apps back to your device using iTunes WiFi sync. To prevent apps from expiring, AltStore will also periodically refresh your apps in the background when on the same WiFi as AltServer.

For the initial release, I focused on building a solid foundation for distributing my own apps — primarily Delta, [my all-in-one emulator for iOS](https://github.com/rileytestut/Delta). Now that Delta has been released, however, I'm beginning work on adding support for *anyone* to list and distribute their apps through AltStore (contributions welcome! 🙂).

## Features
- Installs apps over WiFi using AltServer
- Resigns and installs any app with your Apple ID
- Refreshes apps periodically in the background to prevent them from expiring (when on same WiFi as AltServer)
- Handles app updates directly through AltStore 

## Minimum Project Requirements
- Xcode 15
- Swift 5.9
- iOS 14.0 (AltStore)
- macOS 11.0 (AltServer)

## Project Overview

### AltStore
AltStore is a just regular, sandboxed iOS application. The AltStore app target contains the vast majority of AltStore's functionality, including all the logic for downloading and updating apps through AltStore. AltStore makes heavy use of standard iOS frameworks and technologies most iOS developers are familiar with, such as:
* Core Data
* Storyboards/Nibs
* Auto Layout
* Background App Refresh
* Network.framework (new in iOS 12)

### AltServer
AltServer is also just a regular, sandboxed macOS application. AltServer is significantly less complex than AltStore though, and for that reason consists of only a handful of files.

### AltKit
AltKit is a shared framework that includes common code between AltStore and AltServer.

### AltSign
AltSign is my internal framework used by both AltStore and AltServer to communicate with Apple's servers and resign apps. For more info, check the [AltSign repo](https://github.com/rileytestut/altsign).

### Roxas
Roxas is my internal framework used across all my iOS projects, developed to simplify a variety of common tasks used in iOS development. For more info, check the [Roxas repo](https://github.com/rileytestut/roxas).

## Compilation Instructions
AltStore and AltServer are both fairly straightforward to compile and run if you're already an iOS or macOS developer. To compile AltStore and/or AltServer:

1. Clone the repository 
	``` 
	git clone https://github.com/rileytestut/AltStore.git
	```
2. Update submodules: 
	```
	cd AltStore 
	git submodule update --init --recursive
	```
3. **(AltServer, `rigwig-release-macos27` branch)** Download `idevice-xcframework-v0.1.62.zip` from the [jkcoxson/idevice v0.1.62 release](https://github.com/jkcoxson/idevice/releases/tag/v0.1.62) and extract `IDevice.xcframework` into `Dependencies/idevice/swift/`. The xcframework is a prebuilt binary that isn't committed to git, and the build fails without it (`local binary target 'IDevice' … does not contain a binary artifact`). The release version must match the submodule's pinned tag (`git -C Dependencies/idevice describe --tags`).
4. Open `AltStore.xcworkspace` and select the AltStore project in the project navigator. On the `Signing & Capabilities` tab, change the team from `Yvette Testut` to your own account.
5. **(AltStore only)** Change the value for `ALTDeviceID` in the Info.plist to your device's UDID. Normally, AltServer embeds the device's UDID in AltStore's Info.plist during installation. When running through Xcode you'll need to set the value yourself or else AltStore won't resign (or even install) apps for the proper device.
6. **(AltStore only)** Change the value for `ALTServerID` in the Info.plist to your AltServer's serverID. This is embedded by AltServer during installation to help AltStore distinguish between multiple AltServers on the same network, and you can find this by using a Bonjour browsing application and noting the serverID advertised by AltServer. This isn't strictly necessary, because if AltStore can't find the AltServer with the embedded serverID it still falls back to trying another AltServer. However, this will help in cases where there are multiple AltServers running (plus the error messages are more helpful).
7. Build + run app! 🎉

### AltServer anisette data on macOS 26+ (`rigwig-release-macos27` branch)

macOS 26 and later no longer provide anisette data to unentitled apps, and since October 2026 Apple has been rejecting the usual third-party workarounds in quick succession (Android-emulated anisette with `-80045`/HTTP 503 since October 12–14, then widely-shared Windows identities with `-45061` since ~October 17). On macOS 27, AltServer therefore fetches anisette data from a remote anisette v3 server and signs in to Apple with that server's client identity.

- The server must report Windows or Mac `client_info` on `/v3/client_info`; Android identities are rejected by Apple.
- The default server is `https://ani.jkcoxson.com` (Windows identity). As of October 19 2026 that identity also draws `-45061`, and the working choice is the Mac-identity server:
  ```
  defaults write com.rileytestut.AltServer AnisetteServerURL https://mac-ani.jkcoxson.com
  ```
- The provisioned identity is cached in `~/Library/Application Support/com.rileytestut.AltServer/RemoteAnisetteWindows/identity.json`. Changing the server re-provisions automatically; to force a fresh identity, quit AltServer and delete that directory.
- Your Apple ID password and 2FA code are only ever sent to Apple — the anisette server only sees the throwaway anisette identity it provisions.

This is an ongoing cat-and-mouse situation; if sign-in breaks again, check [altstoreio/AltStore#1828](https://github.com/altstoreio/AltStore/issues/1828) and related PRs for the current state.

## Licensing

Due to the licensing of some dependencies used by AltStore, I have no choice but to distribute AltStore under the **AGPLv3 license**. That being said, my goal for AltStore is for it to be an open source project *anyone* can use without restrictions, so I explicitly give permission for anyone to use, modify, and distribute all *my* original code for this project in any form, with or without attribution, without fear of legal consequences (dependencies remain under their original licenses, however).

## Contact Me

* Email: riley@altstore.io
* Mastodon (Preferred): [@rileytestut@mastodon.social](https://mastodon.social/@rileytestut)
* Twitter (Less active nowadays): [@rileytestut](https://twitter.com/rileytestut)

Questions about AltStore in general? Make sure to read the FAQ at https://altstore.io/faq/

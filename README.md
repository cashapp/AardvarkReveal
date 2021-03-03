# AardvarkReveal

[![CI Status](https://img.shields.io/github/workflow/status/cashapp/AardvarkReveal/CI/main)](https://github.com/cashapp/AardvarkReveal/actions?query=workflow%3ACI+branch%3Amain)
[![Version](https://img.shields.io/cocoapods/v/AardvarkReveal.svg)](https://cocoapods.org/pods/AardvarkReveal)
[![License](https://img.shields.io/cocoapods/l/AardvarkReveal.svg)](https://cocoapods.org/pods/AardvarkReveal)
[![Platform](https://img.shields.io/cocoapods/p/AardvarkReveal.svg)](https://cocoapods.org/pods/AardvarkReveal)

AardvarkReveal is an extension to [Aardvark](https://github.com/square/Aardvark) that provides components for generating a bug report attachment containing a [Reveal](https://revealapp.com/) file.

## Installation

### CocoaPods

To install AardvarkReveal via [CocoaPods](https://cocoapods.org/), simply add the following line to your Podfile:

```ruby
pod 'AardvarkReveal'
```

## Getting Started

AardvarkReveal provides a simple utility class for generating a bug report attachment containing a compressed Reveal bundle. To get started, create a `RevealAttachmentGenerator` and tell it to begin listening for the Reveal server.

```swift
self.revealAttachmentGenerator = RevealAttachmentGenerator()
self.revealAttachmentGenerator.startListeningForRevealServer()
```

The generator will then listen for Reveal's Bonjour service and automatically connect in the background. Since this process is asynchronous, it's important to initialize the generator and start listening early. It's recommended to hold onto the generator in your app/scene delegate.

When you're ready to file a bug report, call the generator's `captureCurrentAppState(completionQueue:completion:)` method.

```swift
revealAttachmentGenerator.captureCurrentAppState(completionQueue: .main) { attachment in
    if let attachment = attachment {
        // Attach it to the bug report
    }

    // Continue with the bug reporting flow
}
```

This will asynchronously capture the application state, generate the Reveal bundle, create a compressed archive from the data, and call the completion with the final bug report attachment.

For an example of how this setup works, check out the [SceneDelegate](https://github.com/square/AardvarkReveal/blob/main/Example/AardvarkRevealDemo/SceneDelegate.swift) in the demo app. To make the experience smoother, for example by presenting a loading screen while the generator is capturing the snapshot, you can add a delegate conforming to the [`RevealAttachmentGeneratorDelegate`](https://github.com/square/AardvarkReveal/blob/main/Sources/AardvarkReveal/RevealAttachmentGenerator.swift) protocol.

The generator communicates with the Reveal service using Bonjour. You will need to ensure that Reveal is allowed to broadcast over Bonjour, otherwise the generator will fail to connect. See the [support article](https://support.revealapp.com/hc/en-us/articles/900002728683-Supporting-iOS-14-Permission-Changes-) for more information.

You will also need to enable insecure HTTP connections to `localhost` to allow the generator to communicate with the Reveal service. You can enable this by adding the following to your `Info.plist`:

```xml
<key>NSAppTransportSecurity</key>
<dict>
    <key>NSExceptionDomains</key>
    <dict>
        <key>localhost</key>
        <dict>
            <key>NSExceptionAllowsInsecureHTTPLoads</key>
            <true/>
            <key>NSIncludesSubdomains</key>
            <true/>
        </dict>
    </dict>
</dict>
```

Alternatively, you can add a build phase to update the `Info.plist`, as demonstrated [in the demo app](https://github.com/square/AardvarkReveal/commit/b492ea785d45d015b4e89e57421ac5b545d128f4). We highly recommend using a build phase in your app and restricting it to only run in the desired build configurations.

## Demo App

AardvarkReveal includes a demo app that shows how the framework can be used. To run the demo app:

1. Clone the repo.
2. Open the `Example` directory.
3. Run `bundle exec pod install`.
4. Open `AardvarkRevealDemo.xcworkspace`.
5. Enable code signing for the `AardvarkRevealDemo` to use your development team.
6. Run the `AardvarkRevealDemo` scheme on your device.

Note that the demo app uses an email-based bug reporter, so it will not be able to file the report from a simulator since the simulator does not include the Mail app. The demo app runs on iOS 13 and later.

## Requirements

* Xcode 11.0 or later
* iOS 12.0 or later

## Contributing

We’re glad you’re interested in AardvarkReveal, and we’d love to see where you take it. Please read our [contributing guidelines](CONTRIBUTING.md) prior to submitting a Pull Request.

## License

```
Copyright 2021 Square, Inc.

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

   http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
```

# ios

Practical Course: iOS - Group project (2019/2020)

## Development
Install [XcodeGen](https://github.com/yonaskolb/XcodeGen) and [CocoaPods](https://cocoapods.org/) via [Homebrew](https://brew.sh/) `brew install xcodegen cocoapods`.

Follow the instructions everytime you checkout a new branch or pull new files from remote origin.

1. Close Xcode.app
2. Run the following commands in the console within the `ios`-Folder
```sh
xcodegen generate && pod install --repo-update
```
3. Open `SpotUp.xcworkspace` in Xcode.app

### Requirements
- macOS Catalina Version 10.15.2
- Xcode.app Version 11.3
- Homebrew

## Architecture

- Swift 5.1.2
- SwiftUI
- Firebase Authentication
- Firebase Cloud Firestore
- Google Maps
- Google Places

## Contributors (Group 7)

- Andreas Ellwanger
- Timo Erdelt
- Havy Ha
- Fangli Lu

## Credits / Attributions

- Icons made by [Freepik](https://www.flaticon.com/authors/freepik) from [www.flaticon.com](https://www.flaticon.com/).
- Icons may be altered in color and shape.

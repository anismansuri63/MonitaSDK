# Monita SDK

Monita SDK provides powerful monitoring and analytics capabilities for your iOS applications, including request monitoring, analytics integration, and performance tracking.

## Installation

To integrate Monita SDK into your iOS project, follow the steps below.

### Step 1: Add Package Dependency...

In Xcode, go to File -> Swift Packages -> Add Package Dependency...:

In the search box put ```https://github.com/rnadigital/monita-ios-sdk.git``` and click next.

### Step 2: Add the token

Add MonitaSDKToken to Info.plist
Open your project in Xcode and navigate to your Info.plist file.
Add a new key called MonitaSDKToken with your SDK token as the value:

  `<key>MonitaSDKToken</key>`
  
  `<string>Your-Token-Here</string>`
  


## Usage

After successful integration, you can initialize Monita SDK in your application class:

```swift
import MonitaSDK

func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
    // Override point for customization after application launch.

    // Initialize Monita SDK
    MonitaSDK.configure(enableLogger: true, batchSize: 10, customerId: "123456", consentString: "Granted", sessionId: "123456", appVersion: "1.0")

    return true
}
```

## Features

- Automatic request monitoring
- Analytics integration (Google, Facebook, Firebase)
- Performance tracking
- Easy to integrate

## Troubleshooting

If you encounter any issues:

1. In Xcode, go to File -> Packages -> Reset Package Caches

## License

This project is licensed under the [MIT License](LICENSE).

## Contact

For any issues or support, please reach out to [support@monita.com](mailto:support@monita.com).


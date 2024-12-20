# Monita iOS SDK

With Monita for iOS you can make sure that your tracking is going as you planned without changing your current analytics stack or code.

Monita will monitor traffic between your app and data destinations and automatically detect any changes in your analytics implementation and warn you about inconsistencies like hit drops, missing properties, rogue events, and more.


Monita is currently available for Web, iOS and Android. More clients will come soon.

Please request your ```TrackingplanId``` at <a href='https://www.trackingplan.com'>trackingplan.com</a> or write us directly team@trackingplan.com.


## Install the SDK

The recommended way to install Monita for iOS is using Swift Package Manager because it makes it simple to install and upgrade.

First, add the Monita dependency using Xcode, like so:

In Xcode, go to File -> Swift Packages -> Add Package Dependency...

<img src="https://user-images.githubusercontent.com/47759/125598926-ab3b6af9-cf09-4fac-97f8-b3242c9acf21.png" width="300" />

If you are asked to choose the project, please choose the one you want to add Monita to.

<img src="https://user-images.githubusercontent.com/47759/125629839-f7090646-503e-4cf8-b669-5bfe0f442937.png" width="300" />

In the search box please put ```https://github.com/rnadigital/monita-ios-sdk.git``` and click next.

<img src="https://user-images.githubusercontent.com/47759/125630384-b4544f77-202f-4567-87bb-c3582535099e.png" width="300" />

Choose the `Version` and leave the default selection for the latest version or customize if needed.

<img src="https://i.ibb.co/TvpmLGK/git-url.png" width="300" />

Click finish and you will see the library added to the Swift Package Dependencies section.

<img src="https://i.ibb.co/th9Rx3V/git-add.png" width="300" />


Add MonitaSDKToken to Info.plist
Open your project in Xcode and navigate to your Info.plist file.
Add a new key called MonitaSDKToken with your SDK token as the value:

  `<key>MonitaSDKToken</key>`
  
  `<string>Your-Token-Here</string>`
  
  
Then in your application delegate’s -  `application(_:didFinishLaunchingWithOptions:)` method, set up the SDK like so:

```swift
// AppDelegate.swift
import MonitaSDK
func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
    // Override point for customization after application launch.

    // Initialize Monita SDK
    MonitaSDK.configure(enableLogger: true | false, batchSize: 5, cid: "cid value", appVersion: appVersion)

    return true
}
```


Build and run your app.
The MonitaSDK should be successfully integrated, and it will initialize when the app is launched.


## Additional Information
For more information on how to use the SDK, refer to the official documentation.
If you encounter any issues, please check the FAQ section or open an issue in our repository.

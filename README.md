Big Bang SDK for iOS and OSX
=================

Big Bang lets you create realtime applications in seconds.  It makes event streaming and data synchronization a snap!

Requirements 
==========

* iOS 8.0+ / Mac OSX 10.9+
* XCode 7.0+


Cocoapods
=========

The Big Bang SDK for iOS and OSX is now available via [CocoaPods](https://cocoapods.org/?q=bigbang)  CocoaPods simplifies the process of adding dependencies to your iOS and OSX projects.  Get started by installing the CocoaPods gem:

    gem install cocoapods
    
Integrate the SDK into your XCode project by adding it to your `Podfile`

    pod 'BigBangClient', '0.0.2'
    
Then run the following command to install the SDK

    pod install
   
           
Quick Start - iOS
============

Start by importing the framework.  See installation instructions for importing the framework into your XCode project.

```swift
import BigBang
//Support for JSON messages
import SwiftyJSON
```

Once you have imported the framework, you can easily get connected to BigBang and start sending realtime events.

```swift
var client = DefaultBigBangClient(appURL: "https://demo.bigbang.io");
client.connect { (err) -> Void in
    if let connectErr = err  {
        println("Connection error: " + connectErr)
    }
    else {
        println("Connected!")
        client.subscribe("test_channel", callback: { (cerr, channel) -> Void in
            
            if let subscribeErr  = cerr  {
                println("Subscribe error: " + subscribeErr )
            }
            else {
                println("Subscribed to " + channel!.name );
            }
            
            channel!.onMessage({ (channelMessage) in
                println("GOT A MESSAGE");
            })
            
            var json = JSON.newJSONObject()
            json["message"] = "hello"
            
            channel!.publish(json)
        })
    }
}
```


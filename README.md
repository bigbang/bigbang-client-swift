Big Bang SDK for iOS and OSX
=================

Big Bang lets you create realtime applications in seconds.  It makes event streaming and data synchronization a snap!

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


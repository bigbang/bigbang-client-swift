
import Cocoa
import XCPlayground

import BigBang
import SwiftyJSON

XCPSetExecutionShouldContinueIndefinitely(continueIndefinitely: true)

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
                println("Received a message!");
            })
            
            var json = JSON.newJSONObject()
            json["message"] = "hello"
            
            channel!.publish(json)
        })
    }
}




import XCPlayground

import BigBang
import SwiftyJSON

XCPSetExecutionShouldContinueIndefinitely(true)

var client = DefaultBigBangClient(appURL: "https://demo.bigbang.io");
client.connect { (err) -> Void in
    if let connectErr = err  {
        print("Connection error: " + connectErr)
    }
    else {
        print("Connected!")
        client.subscribe("test_channel", callback: { (cerr, channel) -> Void in
            
            if let subscribeErr  = cerr  {
                print("Subscribe error: " + subscribeErr )
            }
            else {
                print("Subscribed to " + channel!.name );
            }
            
            channel!.onMessage({ (channelMessage) in
                print("Received a message!");
            })
            
            var json = JSON.newJSONObject()
            json["message"] = "hello"
            
            channel!.publish(json)
        })
    }
}



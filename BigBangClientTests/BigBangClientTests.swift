
import Cocoa
import XCTest
import BigBang
import SwiftyJSON

class BigBangClientTests: XCTestCase {
    
    private var TEST_HOST = "http://demo.bigbang.io"
    private var SECURE_TEST_HOST = "https://demo.bigbang.io"
    
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testConnect() {
    
        let expectation = expectationWithDescription("connect to demo instance");
        
        getMeAClient(TEST_HOST, callback: { (client) in
            expectation.fulfill()
        })
        
        waitForExpectationsWithTimeout(5.0, handler:nil)
    }
    
    func testConnectHttps() {
        
        let expectation = expectationWithDescription("connect to demo instance");
        
        getMeAClient(SECURE_TEST_HOST, callback: { (client) in
            expectation.fulfill()
        })
        
        waitForExpectationsWithTimeout(5.0, handler:nil)
    }
    
    func testChannelEcho() {
        
        let channelName =  "channel-\(NSUUID().UUIDString)"
        let expectation = expectationWithDescription("echo on channel");
        
        var message = JSON.newJSONObject()
        message["test"] = "messages are awesome"
        
        clientOnChannel(TEST_HOST, channelName: channelName) { (client) -> Void in
            var channel = client.getChannel(channelName)
            
            channel!.onMessage({ (channelMessage) in
                
                XCTAssertNotNil(channelMessage, "Message not null")
                XCTAssertEqual(message, channelMessage.payload.getBytesAsJson(), "Stuff")
                expectation.fulfill()
            })
            
            channel!.publish(message)
            
        }
        
        waitForExpectationsWithTimeout(5.0, handler:nil)
    }
    
    func testSubscribers() {
        
        let channelName =  "channel-\(NSUUID().UUIDString)"
        let expectation = expectationWithDescription("subscribers");
        
        
        
        clientOnChannel(TEST_HOST, channelName: channelName) { (client) -> Void in
            var channel = client.getChannel(channelName)
            
            channel!.onJoin({(joined) in
                XCTAssertNotNil(joined, "joined id should not be null")
                XCTAssertEqual(client.getClientId(), joined, "The client, its me!")
                expectation.fulfill()
            })
        }
        
        waitForExpectationsWithTimeout(5.0, handler:nil)
    }
    
    
    
    func testNamespace() {
        
        let expectationAdd = expectationWithDescription("add to keyspace");
        let expectationUpdate = expectationWithDescription("update keyspace");
        let expectationRemove = expectationWithDescription("Remove the key!")
        
        let channelName =  "channel-\(NSUUID().UUIDString)"
        let ns = "ns-\(NSUUID().UUIDString)"
        
        
        var testData = JSON.newJSONObject()
        testData["foo"] = "bar"
        testData["one"] = 23
        testData["float"] = 456.1
        
        
        var testDataUpdate = JSON.newJSONObject()
        testDataUpdate["foo"] = "barr"
        testDataUpdate["one"] = 1348
        testDataUpdate["float"] = 789.2
        
        
        clientOnChannel(TEST_HOST, channelName: channelName, callback: { (client) -> Void in
            
            
            var channel = client.getChannel(channelName)
            var cd = channel!.getChannelData(ns)
            
            cd.onAdd({ (key,val) in
                XCTAssertEqual("foo", key, "add key and put key are same")
                XCTAssertEqual(testData, val, "values are equal")
                
                expectationAdd.fulfill()
                cd.put("foo", value:testDataUpdate)
            })
            
            cd.onUpdate({ (key,val) in
                XCTAssertEqual("foo", key, "update key and put key are same")
                XCTAssertEqual(testDataUpdate, val, "values are equal")
                expectationUpdate.fulfill()
                cd.remove("foo")
            })
            
            cd.onRemove({ (key) in
                XCTAssertEqual("foo", key, "remove key and put key are same")
                expectationRemove.fulfill()
            })
            
            
            cd.put("foo", value:testData)
        })
        
        
        waitForExpectationsWithTimeout(5.0, handler:nil)
        
    }
    
    func getMeAClient( host:String, callback:(BigBangClient) -> Void ) -> Void {
        let client = DefaultBigBangClient(appURL: host)
        client.connect({ (err) in
            XCTAssertTrue(err == nil, "No errors, no problems")
            callback(client)
            return
        })
        
    }
    
    func clientOnChannel( host:String, channelName:String, callback:(BigBangClient) -> Void ) ->Void {
        getMeAClient(host, callback: { (client) -> Void in
            client.subscribe( channelName, callback:{ (err, channel) in
                XCTAssertTrue( err == nil, "No errors, no problems")
        
                callback(client)
                return
            })
        })
    }
    
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measureBlock() {
            // Put the code you want to measure the time of here.
        }
    }
    
}

/*
 BSD LICENSE

 Copyright (c) 2015, Big Bang IO, LLC
 All rights reserved.

 Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:

 1. Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.

 2. Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.

 3. Neither the name of the copyright holder nor the names of its contributors may be used to endorse or promote products derived from this software without specific prior written permission.

 THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 */

/**
*  GENERATED CODE. DON'T EDIT.  Reference: PewProtocol.st
*/

import Foundation
import SwiftyJSON


internal protocol WireProtocolProtocolListener {
    func onWireChannelDataCreate( msg: WireChannelDataCreate ) -> Void 
    func onWireChannelDataDel( msg: WireChannelDataDel ) -> Void 
    func onWireChannelDataDelete( msg: WireChannelDataDelete ) -> Void 
    func onWireChannelDataPut( msg: WireChannelDataPut ) -> Void 
    func onWireChannelDataUpdate( msg: WireChannelDataUpdate ) -> Void 
    func onWireChannelJoin( msg: WireChannelJoin ) -> Void 
    func onWireChannelLeave( msg: WireChannelLeave ) -> Void 
    func onWireChannelMessage( msg: WireChannelMessage ) -> Void 
    func onWireChannelSubscribe( msg: WireChannelSubscribe ) -> Void 
    func onWireChannelUnSubscribe( msg: WireChannelUnSubscribe ) -> Void 
    func onWireConnectFailure( msg: WireConnectFailure ) -> Void 
    func onWireConnectRequest( msg: WireConnectRequest ) -> Void 
    func onWireConnectSuccess( msg: WireConnectSuccess ) -> Void 
    func onWireDisconnectRequest( msg: WireDisconnectRequest ) -> Void 
    func onWireDisconnectSuccess( msg: WireDisconnectSuccess ) -> Void 
    func onWirePing( msg: WirePing ) -> Void 
    func onWirePong( msg: WirePong ) -> Void 
    func onWireQueueMessage( msg: WireQueueMessage ) -> Void 
    func onWireRpcMessage( msg: WireRpcMessage ) -> Void 

}


internal class WireProtocol : PewProtocol {

    internal var listener: WireProtocolProtocolListener!

    internal init() {

    }

    enum MessageTypes : Int {
        case WireChannelDataCreate  = 0
        case WireChannelDataDel  = 1
        case WireChannelDataDelete  = 2
        case WireChannelDataPut  = 3
        case WireChannelDataUpdate  = 4
        case WireChannelJoin  = 5
        case WireChannelLeave  = 6
        case WireChannelMessage  = 7
        case WireChannelSubscribe  = 8
        case WireChannelUnSubscribe  = 9
        case WireConnectFailure  = 10
        case WireConnectRequest  = 11
        case WireConnectSuccess  = 12
        case WireDisconnectRequest  = 13
        case WireDisconnectSuccess  = 14
        case WirePing  = 15
        case WirePong  = 16
        case WireQueueMessage  = 17
        case WireRpcMessage  = 18

    }

    internal func protocolHash() -> String  {
        return "d96a44664eff8b2a710ded18e07ab927"
    }

    internal func wrapNetstring( msg: PewMessage) -> String {
        var msgString:String! = msg.serializeJson().rawString()
        msgString = String(msg.messageType) + ":" + msgString!
        let len = msgString.characters.count
        return String(len) + ":" + msgString + ","
    }

    internal func dispatchNetstring(msgStr: String) {
        let idx = msgStr.indexOf(":")
        let typeInt = Int( msgStr.subString(0, length: idx))
        let mt:MessageTypes = MessageTypes( rawValue: typeInt!)!
        let jsonString = msgStr.subString(idx + 1, length: msgStr.length - ( idx + 1 ))

      switch (mt) {
            case MessageTypes.WireChannelDataCreate:
              let WireChannelDataCreate_msg = WireChannelDataCreate();
              WireChannelDataCreate_msg.deserializeJson(JSON.newJSONFromString(jsonString))
              listener.onWireChannelDataCreate( WireChannelDataCreate_msg );

              break;
            case MessageTypes.WireChannelDataDel:
              let WireChannelDataDel_msg = WireChannelDataDel();
              WireChannelDataDel_msg.deserializeJson(JSON.newJSONFromString(jsonString))
              listener.onWireChannelDataDel( WireChannelDataDel_msg );

              break;
            case MessageTypes.WireChannelDataDelete:
              let WireChannelDataDelete_msg = WireChannelDataDelete();
              WireChannelDataDelete_msg.deserializeJson(JSON.newJSONFromString(jsonString))
              listener.onWireChannelDataDelete( WireChannelDataDelete_msg );

              break;
            case MessageTypes.WireChannelDataPut:
              let WireChannelDataPut_msg = WireChannelDataPut();
              WireChannelDataPut_msg.deserializeJson(JSON.newJSONFromString(jsonString))
              listener.onWireChannelDataPut( WireChannelDataPut_msg );

              break;
            case MessageTypes.WireChannelDataUpdate:
              let WireChannelDataUpdate_msg = WireChannelDataUpdate();
              WireChannelDataUpdate_msg.deserializeJson(JSON.newJSONFromString(jsonString))
              listener.onWireChannelDataUpdate( WireChannelDataUpdate_msg );

              break;
            case MessageTypes.WireChannelJoin:
              let WireChannelJoin_msg = WireChannelJoin();
              WireChannelJoin_msg.deserializeJson(JSON.newJSONFromString(jsonString))
              listener.onWireChannelJoin( WireChannelJoin_msg );

              break;
            case MessageTypes.WireChannelLeave:
              let WireChannelLeave_msg = WireChannelLeave();
              WireChannelLeave_msg.deserializeJson(JSON.newJSONFromString(jsonString))
              listener.onWireChannelLeave( WireChannelLeave_msg );

              break;
            case MessageTypes.WireChannelMessage:
              let WireChannelMessage_msg = WireChannelMessage();
              WireChannelMessage_msg.deserializeJson(JSON.newJSONFromString(jsonString))
              listener.onWireChannelMessage( WireChannelMessage_msg );

              break;
            case MessageTypes.WireChannelSubscribe:
              let WireChannelSubscribe_msg = WireChannelSubscribe();
              WireChannelSubscribe_msg.deserializeJson(JSON.newJSONFromString(jsonString))
              listener.onWireChannelSubscribe( WireChannelSubscribe_msg );

              break;
            case MessageTypes.WireChannelUnSubscribe:
              let WireChannelUnSubscribe_msg = WireChannelUnSubscribe();
              WireChannelUnSubscribe_msg.deserializeJson(JSON.newJSONFromString(jsonString))
              listener.onWireChannelUnSubscribe( WireChannelUnSubscribe_msg );

              break;
            case MessageTypes.WireConnectFailure:
              let WireConnectFailure_msg = WireConnectFailure();
              WireConnectFailure_msg.deserializeJson(JSON.newJSONFromString(jsonString))
              listener.onWireConnectFailure( WireConnectFailure_msg );

              break;
            case MessageTypes.WireConnectRequest:
              let WireConnectRequest_msg = WireConnectRequest();
              WireConnectRequest_msg.deserializeJson(JSON.newJSONFromString(jsonString))
              listener.onWireConnectRequest( WireConnectRequest_msg );

              break;
            case MessageTypes.WireConnectSuccess:
              let WireConnectSuccess_msg = WireConnectSuccess();
              WireConnectSuccess_msg.deserializeJson(JSON.newJSONFromString(jsonString))
              listener.onWireConnectSuccess( WireConnectSuccess_msg );

              break;
            case MessageTypes.WireDisconnectRequest:
              let WireDisconnectRequest_msg = WireDisconnectRequest();
              WireDisconnectRequest_msg.deserializeJson(JSON.newJSONFromString(jsonString))
              listener.onWireDisconnectRequest( WireDisconnectRequest_msg );

              break;
            case MessageTypes.WireDisconnectSuccess:
              let WireDisconnectSuccess_msg = WireDisconnectSuccess();
              WireDisconnectSuccess_msg.deserializeJson(JSON.newJSONFromString(jsonString))
              listener.onWireDisconnectSuccess( WireDisconnectSuccess_msg );

              break;
            case MessageTypes.WirePing:
              let WirePing_msg = WirePing();
              WirePing_msg.deserializeJson(JSON.newJSONFromString(jsonString))
              listener.onWirePing( WirePing_msg );

              break;
            case MessageTypes.WirePong:
              let WirePong_msg = WirePong();
              WirePong_msg.deserializeJson(JSON.newJSONFromString(jsonString))
              listener.onWirePong( WirePong_msg );

              break;
            case MessageTypes.WireQueueMessage:
              let WireQueueMessage_msg = WireQueueMessage();
              WireQueueMessage_msg.deserializeJson(JSON.newJSONFromString(jsonString))
              listener.onWireQueueMessage( WireQueueMessage_msg );

              break;
            case MessageTypes.WireRpcMessage:
              let WireRpcMessage_msg = WireRpcMessage();
              WireRpcMessage_msg.deserializeJson(JSON.newJSONFromString(jsonString))
              listener.onWireRpcMessage( WireRpcMessage_msg );

              break;


      }
    }
}


internal class WireChannelDataCreate  : PewMessage {

    // Message Type
    private var _messageType: Int = 0

    internal var messageType: Int {
        get { return _messageType }
    }

    internal var key: String?
    internal var ks: String?
    internal var name: String?
    internal var payload: ByteArray?


    internal init( ) {
    }

    internal func serializeJson() -> SwiftyJSON.JSON {
        var json = JSON(NSDictionary())
        json["key"].string = key
        json["ks"].string = ks
        json["name"].string = name
        json["payload"].string =  payload!.getBytesAsBase64()


        return json
    }

    internal func deserializeJson(json:SwiftyJSON.JSON) ->Void  {
        self.key = json["key"].stringValue
        self.ks = json["ks"].stringValue
        self.name = json["name"].stringValue
        self.payload = ByteArray( b64bytes:json["payload"].stringValue );


    }
}
 internal class WireChannelDataDel  : PewMessage {

    // Message Type
    private var _messageType: Int = 1

    internal var messageType: Int {
        get { return _messageType }
    }

    internal var key: String?
    internal var ks: String?
    internal var name: String?


    internal init( ) {
    }

    internal func serializeJson() -> SwiftyJSON.JSON {
        var json = JSON(NSDictionary())
        json["key"].string = key
        json["ks"].string = ks
        json["name"].string = name

        return json
    }

    internal func deserializeJson(json:SwiftyJSON.JSON) ->Void  {
        self.key = json["key"].stringValue
        self.ks = json["ks"].stringValue
        self.name = json["name"].stringValue

    }
}
 internal class WireChannelDataDelete  : PewMessage {

    // Message Type
    private var _messageType: Int = 2

    internal var messageType: Int {
        get { return _messageType }
    }

    internal var key: String?
    internal var ks: String?
    internal var name: String?
    internal var payload: ByteArray?


    internal init( ) {
    }

    internal func serializeJson() -> SwiftyJSON.JSON {
        var json = JSON(NSDictionary())
        json["key"].string = key
        json["ks"].string = ks
        json["name"].string = name
        json["payload"].string =  payload!.getBytesAsBase64()


        return json
    }

    internal func deserializeJson(json:SwiftyJSON.JSON) ->Void  {
        self.key = json["key"].stringValue
        self.ks = json["ks"].stringValue
        self.name = json["name"].stringValue
        self.payload = ByteArray( b64bytes:json["payload"].stringValue );


    }
}
 internal class WireChannelDataPut  : PewMessage {

    // Message Type
    private var _messageType: Int = 3

    internal var messageType: Int {
        get { return _messageType }
    }

    internal var key: String?
    internal var ks: String?
    internal var name: String?
    internal var payload: ByteArray?


    internal init( ) {
    }

    internal func serializeJson() -> SwiftyJSON.JSON {
        var json = JSON(NSDictionary())
        json["key"].string = key
        json["ks"].string = ks
        json["name"].string = name
        json["payload"].string =  payload!.getBytesAsBase64()


        return json
    }

    internal func deserializeJson(json:SwiftyJSON.JSON) ->Void  {
        self.key = json["key"].stringValue
        self.ks = json["ks"].stringValue
        self.name = json["name"].stringValue
        self.payload = ByteArray( b64bytes:json["payload"].stringValue );


    }
}
 internal class WireChannelDataUpdate  : PewMessage {

    // Message Type
    private var _messageType: Int = 4

    internal var messageType: Int {
        get { return _messageType }
    }

    internal var key: String?
    internal var ks: String?
    internal var name: String?
    internal var payload: ByteArray?


    internal init( ) {
    }

    internal func serializeJson() -> SwiftyJSON.JSON {
        var json = JSON(NSDictionary())
        json["key"].string = key
        json["ks"].string = ks
        json["name"].string = name
        json["payload"].string =  payload!.getBytesAsBase64()


        return json
    }

    internal func deserializeJson(json:SwiftyJSON.JSON) ->Void  {
        self.key = json["key"].stringValue
        self.ks = json["ks"].stringValue
        self.name = json["name"].stringValue
        self.payload = ByteArray( b64bytes:json["payload"].stringValue );


    }
}
 internal class WireChannelJoin  : PewMessage {

    // Message Type
    private var _messageType: Int = 5

    internal var messageType: Int {
        get { return _messageType }
    }

    internal var name: String?
    internal var success: Bool
    internal var channelPermissions: [String]?
    internal var errorMessage: String?


    internal init( ) {
        self.success = false

    }

    internal func serializeJson() -> SwiftyJSON.JSON {
        var json = JSON(NSDictionary())
        json["name"].string = name
        json["success"].bool =  success

        json["channelPermissions"] =  JSON( channelPermissions! )

        json["errorMessage"].string = errorMessage

        return json
    }

    internal func deserializeJson(json:SwiftyJSON.JSON) ->Void  {
        self.name = json["name"].stringValue
        self.success = json["success"].boolValue

        self.channelPermissions = json["channelPermissions"].arrayObject as! [String]?
        self.errorMessage = json["errorMessage"].stringValue

    }
}
 internal class WireChannelLeave  : PewMessage {

    // Message Type
    private var _messageType: Int = 6

    internal var messageType: Int {
        get { return _messageType }
    }

    internal var name: String?


    internal init( ) {
    }

    internal func serializeJson() -> SwiftyJSON.JSON {
        var json = JSON(NSDictionary())
        json["name"].string = name

        return json
    }

    internal func deserializeJson(json:SwiftyJSON.JSON) ->Void  {
        self.name = json["name"].stringValue

    }
}
 internal class WireChannelMessage  : PewMessage {

    // Message Type
    private var _messageType: Int = 7

    internal var messageType: Int {
        get { return _messageType }
    }

    internal var senderId: String?
    internal var name: String?
    internal var payload: ByteArray?


    internal init( ) {
    }

    internal func serializeJson() -> SwiftyJSON.JSON {
        var json = JSON(NSDictionary())
        json["senderId"].string = senderId
        json["name"].string = name
        json["payload"].string =  payload!.getBytesAsBase64()


        return json
    }

    internal func deserializeJson(json:SwiftyJSON.JSON) ->Void  {
        self.senderId = json["senderId"].stringValue
        self.name = json["name"].stringValue
        self.payload = ByteArray( b64bytes:json["payload"].stringValue );


    }
}
 internal class WireChannelSubscribe  : PewMessage {

    // Message Type
    private var _messageType: Int = 8

    internal var messageType: Int {
        get { return _messageType }
    }

    internal var name: String?
    internal var jsonConfig: String?


    internal init( ) {
    }

    internal func serializeJson() -> SwiftyJSON.JSON {
        var json = JSON(NSDictionary())
        json["name"].string = name
        json["jsonConfig"].string = jsonConfig

        return json
    }

    internal func deserializeJson(json:SwiftyJSON.JSON) ->Void  {
        self.name = json["name"].stringValue
        self.jsonConfig = json["jsonConfig"].stringValue

    }
}
 internal class WireChannelUnSubscribe  : PewMessage {

    // Message Type
    private var _messageType: Int = 9

    internal var messageType: Int {
        get { return _messageType }
    }

    internal var name: String?


    internal init( ) {
    }

    internal func serializeJson() -> SwiftyJSON.JSON {
        var json = JSON(NSDictionary())
        json["name"].string = name

        return json
    }

    internal func deserializeJson(json:SwiftyJSON.JSON) ->Void  {
        self.name = json["name"].stringValue

    }
}
 internal class WireConnectFailure  : PewMessage {

    // Message Type
    private var _messageType: Int = 10

    internal var messageType: Int {
        get { return _messageType }
    }

    internal var failureMessage: String?


    internal init( ) {
    }

    internal func serializeJson() -> SwiftyJSON.JSON {
        var json = JSON(NSDictionary())
        json["failureMessage"].string = failureMessage

        return json
    }

    internal func deserializeJson(json:SwiftyJSON.JSON) ->Void  {
        self.failureMessage = json["failureMessage"].stringValue

    }
}
 internal class WireConnectRequest  : PewMessage {

    // Message Type
    private var _messageType: Int = 11

    internal var messageType: Int {
        get { return _messageType }
    }

    internal var version: Int?
    internal var clientKey: String?


    internal init( ) {
    }

    internal func serializeJson() -> SwiftyJSON.JSON {
        var json = JSON(NSDictionary())
        json["version"].int =  version
        json["clientKey"].string = clientKey

        return json
    }

    internal func deserializeJson(json:SwiftyJSON.JSON) ->Void  {
        self.version = json["version"].intValue
        self.clientKey = json["clientKey"].stringValue

    }
}
 internal class WireConnectSuccess  : PewMessage {

    // Message Type
    private var _messageType: Int = 12

    internal var messageType: Int {
        get { return _messageType }
    }

    internal var clientId: String?
    internal var clientToServerPingMS: Int?


    internal init( ) {
    }

    internal func serializeJson() -> SwiftyJSON.JSON {
        var json = JSON(NSDictionary())
        json["clientId"].string = clientId
        json["clientToServerPingMS"].int =  clientToServerPingMS

        return json
    }

    internal func deserializeJson(json:SwiftyJSON.JSON) ->Void  {
        self.clientId = json["clientId"].stringValue
        self.clientToServerPingMS = json["clientToServerPingMS"].intValue

    }
}
 internal class WireDisconnectRequest  : PewMessage {

    // Message Type
    private var _messageType: Int = 13

    internal var messageType: Int {
        get { return _messageType }
    }


    internal init( ) {
    }

    internal func serializeJson() -> SwiftyJSON.JSON {
        var json = JSON(NSDictionary())
        return json
    }

    internal func deserializeJson(json:SwiftyJSON.JSON) ->Void  {
    }
}
 internal class WireDisconnectSuccess  : PewMessage {

    // Message Type
    private var _messageType: Int = 14

    internal var messageType: Int {
        get { return _messageType }
    }


    internal init( ) {
    }

    internal func serializeJson() -> SwiftyJSON.JSON {
        var json = JSON(NSDictionary())
        return json
    }

    internal func deserializeJson(json:SwiftyJSON.JSON) ->Void  {
    }
}
 internal class WirePing  : PewMessage {

    // Message Type
    private var _messageType: Int = 15

    internal var messageType: Int {
        get { return _messageType }
    }


    internal init( ) {
    }

    internal func serializeJson() -> SwiftyJSON.JSON {
        var json = JSON(NSDictionary())
        return json
    }

    internal func deserializeJson(json:SwiftyJSON.JSON) ->Void  {
    }
}
 internal class WirePong  : PewMessage {

    // Message Type
    private var _messageType: Int = 16

    internal var messageType: Int {
        get { return _messageType }
    }


    internal init( ) {
    }

    internal func serializeJson() -> SwiftyJSON.JSON {
        var json = JSON(NSDictionary())
        return json
    }

    internal func deserializeJson(json:SwiftyJSON.JSON) ->Void  {
    }
}
 internal class WireQueueMessage  : PewMessage {

    // Message Type
    private var _messageType: Int = 17

    internal var messageType: Int {
        get { return _messageType }
    }

    internal var id: String?
    internal var name: String?
    internal var payload: ByteArray?


    internal init( ) {
    }

    internal func serializeJson() -> SwiftyJSON.JSON {
        var json = JSON(NSDictionary())
        json["id"].string = id
        json["name"].string = name
        json["payload"].string =  payload!.getBytesAsBase64()


        return json
    }

    internal func deserializeJson(json:SwiftyJSON.JSON) ->Void  {
        self.id = json["id"].stringValue
        self.name = json["name"].stringValue
        self.payload = ByteArray( b64bytes:json["payload"].stringValue );


    }
}
 internal class WireRpcMessage  : PewMessage {

    // Message Type
    private var _messageType: Int = 18

    internal var messageType: Int {
        get { return _messageType }
    }

    internal var id: String?
    internal var ns: String?
    internal var payload: ByteArray?


    internal init( ) {
    }

    internal func serializeJson() -> SwiftyJSON.JSON {
        var json = JSON(NSDictionary())
        json["id"].string = id
        json["ns"].string = ns
        json["payload"].string =  payload!.getBytesAsBase64()


        return json
    }

    internal func deserializeJson(json:SwiftyJSON.JSON) ->Void  {
        self.id = json["id"].stringValue
        self.ns = json["ns"].stringValue
        self.payload = ByteArray( b64bytes:json["payload"].stringValue );


    }
}
 

/*
Copyright (c) 2015, Big Bang IO LLC

Redistribution and use in source and binary forms, with or without
modification, are permitted provided that the following conditions are met:
* Redistributions of source code must retain the above copyright
notice, this list of conditions and the following disclaimer.
* Redistributions in binary form must reproduce the above copyright
notice, this list of conditions and the following disclaimer in the
documentation and/or other materials provided with the distribution.
* Neither the name of the <organization> nor the
names of its contributors may be used to endorse or promote products
derived from this software without specific prior written permission.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
DISCLAIMED. IN NO EVENT SHALL <COPYRIGHT HOLDER> BE LIABLE FOR ANY
DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
(INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
(INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
*/

import Foundation
import Alamofire
import SwiftyJSON
import Starscream

public class DefaultBigBangClient : BigBangClient, WebSocketDelegate, WireProtocolProtocolListener {
    

    private var instanceURL:NSURL
    private var proto:WireProtocol
    private var clientToServerPingMS:Int = 60000;
    private var channelSubscribeMap = [String:SubscribeCallback]()
    private var channelMap = [String:DefaultChannel]()
    
    
    private var clientKey:String!
    private var bufString:String!
    private var theSocket:WebSocket?
    private var clientId:String!
    
    
    private var connectCallback: ConnectCallback!
    private var disconnectCallback: DisconnectCallback!
    
    public required init(appURL:String) {
        proto = WireProtocol()
        instanceURL = NSURL(string: appURL)!
        proto.listener = self
    }
    
    public func getClientId() -> String {
        return clientId!
    }
    
    public func connect(callback:ConnectCallback) -> Void {
        self.connectCallback = callback
        login("",passwd:"")
    }
    
    public func connect(email:String, password:String, callback:ConnectCallback) -> Void {
        callback("email/password connect not implemented")
    }
    
    
    public func disconnect() -> Void {
        sendToServer(WireDisconnectRequest())
    }
    
    public func disconnected( callback: DisconnectCallback ) -> Void {
        self.disconnectCallback = callback
    }
    
    
    func login(user:String, passwd:String) {
        
        Alamofire.request(.GET, instanceURL.absoluteString!+"/loginAnon", parameters: ["wireprotocolhash": proto.protocolHash()])
            .responseString{ (request, response, jsonString, error) in
                
                if let connectError = error {
                    self.connectCallback("Unable to connect. Try again later")
                }
                else {
                    if let dataFromString = jsonString!.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false) {
                        let json = JSON(data: dataFromString)
                        
                        if(json["authenticated"]) {
                            self.clientKey = json["clientKey"].string
                            self.internalConnect(self.clientKey)
                        }
                        else {
                            println("AUTHENTICATION ERROR.")
                        }
                    }
                }
        }
    }
    
    func internalConnect(clientKey:String) {
        
        var scheme =  (instanceURL.scheme  == "http") ? "ws" : "wss"
        var port = instanceURL.port
        var url = "\(scheme)://\(instanceURL.host!)"
        
        if( port != nil) {
            url += ":\(port)"
        }
        
        url += "/sjs/websocket"
        var socket = WebSocket(url: NSURL(string: url)!)
        socket.delegate = self
        socket.connect()
    }
    
    public func websocketDidConnect(socket: WebSocket) {
        self.theSocket = socket
        var req = WireConnectRequest()
        req.clientKey = self.clientKey
        req.version = 1234
        sendToServer(req)
    }
    
    
    public func websocketDidDisconnect(ws: WebSocket, error: NSError?) {
        if( nil != disconnectCallback) {
            disconnectCallback()
        }
    }
    
    
    //text
    public func websocketDidReceiveMessage(socket: WebSocket, text: String) {
        if( bufString == nil || bufString.isEmpty) {
            bufString = ""
        }
        
        bufString! += text
        
        while(parseTextStream()) {
            //super elegant.
        }
    }
    
    //binary
    public func websocketDidReceiveData(socket: WebSocket, data: NSData) {
        println("got some data: \(data.length)")
    }
    
    func sendToServer(msg:PewMessage) {
        if let var s = theSocket {
             s.writeString(proto.wrapNetstring(msg))
        }
        else {
            //TODO EXCEPTIONS
            println("ERROR: SOCKET INVALID.")
        }
    }
    
    func parseTextStream() -> Bool  {
        var delimIdx = bufString.indexOf(":")
        
        if( delimIdx != -1) {
            var lenStr = bufString.subString(0, length: delimIdx)
            var msgLen:Int! = lenStr.toInt()
            
            //Save the earth, recycle.
            if (bufString.length < msgLen + 1 + delimIdx) {
                //just give up, leave the bufString alone for now..
                return false;
            } else {
                var body = bufString.subString(delimIdx + 1, length:msgLen + 1 );
                //Needs to end with a delimiter
                if ( !body.hasSuffix(",")  ) {
                    //TODO ERROR
                    println("TextProtocol decode exception, not terminated with comma");
                }
                
                var actualBody = body.subString (0, length:body.length - 1);
                
                proto.dispatchNetstring(actualBody)
                
                if (bufString.length > msgLen + 1 + delimIdx + 1) {
                    var start = msgLen + 1 + delimIdx + 1
                    var left = bufString.subString( start, length: bufString.length - start )
                    self.bufString = left
                    return true;
                } else {
                    self.bufString = ""
                    return false;
                }
            }
        }
        else {
            return false
        }
    }
    
    public func onWireConnectSuccess( msg: WireConnectSuccess ) -> Void {
        self.clientId = msg.clientId
        self.clientToServerPingMS = msg.clientToServerPingMS!
        
        self.connectCallback( nil )
    }
    
    public func onWireConnectFailure( msg: WireConnectFailure ) -> Void {
        self.clientId = nil
        self.connectCallback(msg.failureMessage!)
    }
    
    
    public func subscribe( name: String, callback: SubscribeCallback) {
        channelSubscribeMap[name] = callback
        var msg = WireChannelSubscribe()
        msg.name = name
        sendToServer(msg)
    }
    
    public func onWireChannelJoin( msg: WireChannelJoin ) -> Void {
        
        var callback:SubscribeCallback = channelSubscribeMap[msg.name!]!
        
        if( !msg.success ) {
            callback("Unable to join channel", nil )
            return
        }
        
        
        var channel:DefaultChannel = DefaultChannel(name: msg.name!, client: self)
        channel.channelPermissions = msg.channelPermissions
        
        channelMap[channel.name] = channel
        
        callback( nil, channel )
    }
    
    public func onWireChannelMessage( msg: WireChannelMessage ) -> Void {
        channelMap[msg.name!]!.onWireChannelMessage(msg)
    }
    
    public func getChannel( name:String ) -> Channel? {
        return channelMap[name]
    }
    
    public func onWireChannelDataCreate( msg: WireChannelDataCreate ) -> Void {
        channelMap[msg.name!]!.onWireChannelDataCreate(msg)
    }

    public func onWireChannelDataUpdate( msg: WireChannelDataUpdate ) -> Void {
        channelMap[msg.name!]!.onWireChannelDataUpdate(msg)
    }
    
    public func onWireChannelDataDelete( msg: WireChannelDataDelete ) -> Void {
        channelMap[msg.name!]!.onWireChannelDataDelete(msg)
    }
    
    public func onWireChannelLeave( msg: WireChannelLeave ) -> Void {
        
    }
    
    public func onWireChannelSubscribe( msg: WireChannelSubscribe ) -> Void {
        
    }
    public func onWireChannelUnSubscribe( msg: WireChannelUnSubscribe ) -> Void {
        
    }
    
    public func onWireConnectRequest( msg: WireConnectRequest ) -> Void {
        
    }
    
    public func onWireDisconnectRequest( msg: WireDisconnectRequest ) -> Void {
        
    }
    public func onWireDisconnectSuccess( msg: WireDisconnectSuccess ) -> Void {
        
    }
    public func onWirePing( msg: WirePing ) -> Void {
        sendToServer(WirePong())
    }
    public func onWirePong( msg: WirePong ) -> Void {
        
    }
    public func onWireQueueMessage( msg: WireQueueMessage ) -> Void {
        //nada
    }
    public func onWireRpcMessage( msg: WireRpcMessage ) -> Void {
        //nada
    }
    
    public func onWireChannelDataPut( msg: WireChannelDataPut ) -> Void {
        //nada
    }
    
    public func onWireChannelDataDel( msg: WireChannelDataDel ) -> Void {
        //nada
    }
    
}




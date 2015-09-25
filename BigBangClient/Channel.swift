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

import Foundation
import SwiftyJSON

public class DefaultChannel : Channel {
    
    private var _name: String;
    private var _client: DefaultBigBangClient
    private var messageHandler: MessageCallback!
    private var joinHandler: PresenceCallback!
    private var leaveHandler: PresenceCallback!
    
    
    private var namespaces = [String:DefaultChannelData]()
    
    public var name:String {
        get {
            return _name
        }
    }
    
    public var channelPermissions: [String]!
    
    init(name:String, client:DefaultBigBangClient) {
        self._name = name
        self._client = client
        
        namespaces["_meta"] = DefaultChannelData(channel: self, ns: "_meta", client: _client)
        namespaces["def"] = DefaultChannelData(channel: self, ns: "def", client: _client)
    
        metaNamespace().on("subs", callback: { ( value, op) -> Void in
            self.updateSubscribers()
        })
    }
    
    public func onMessage( callback: MessageCallback) ->Void {
        self.messageHandler = callback
    }
    
    public func publish(message:JSON) ->Void {
        let msg:WireChannelMessage = WireChannelMessage()
        msg.name = self.name
        msg.payload = message.toByteArray()
        
        _client.sendToServer(msg)
    }
    
    public func getSubscribers() -> [String] {
        var ret = [String]()
        
        let subs = metaNamespace().get("subs")
  
        for (_,val) in subs! {
            let ary = val.arrayValue
            for client in ary {
                ret.append(client.string!)
            }
        }
        
        return ret
    }
    
    var currentSubscribers = Set<String>()
    
    private func updateSubscribers() -> Void {
    
        let old = currentSubscribers
        currentSubscribers = Set( getSubscribers() )
        
        let diff = old.exclusiveOr(currentSubscribers)
        
        
        for id in diff {
            if( old.contains(id)) {
                
                if( nil != leaveHandler) {
                    leaveHandler(id)
                }
            }
            else {
                if( nil != joinHandler) {
                    joinHandler(id)
                }
            }
        }
    }
    
    
    
    public func getChannelData() -> ChannelData {
        return getOrCreateChannelData("def")
    }
    
    public func getChannelData(namespace:String) -> ChannelData {
        return getOrCreateChannelData(namespace)
    }
    
    public func onJoin( callback: PresenceCallback) -> Void {
        self.joinHandler = callback
    }
    
    public func onLeave( callback: PresenceCallback ) -> Void {
        self.leaveHandler = callback
    }
    
    
    
    public func onWireChannelMessage(msg:WireChannelMessage) -> Void {
        if(messageHandler != nil) {
            messageHandler(ChannelMessage( senderId:msg.senderId!, payload:msg.payload!, channel:self))
        }
        else {
            //TODO 
            print("WARN: No message handler.", terminator: "")
        }
    }
    
    public func onWireChannelDataCreate( msg: WireChannelDataCreate ) -> Void {
        getOrCreateChannelData(msg.ks).onWireChannelDataCreate(msg)
    }
    public func onWireChannelDataUpdate( msg: WireChannelDataUpdate ) -> Void {
        getOrCreateChannelData(msg.ks).onWireChannelDataUpdate(msg)
    }
    public func onWireChannelDataDelete( msg: WireChannelDataDelete ) -> Void {
        getOrCreateChannelData(msg.ks).onWireChannelDataDelete(msg)
    }
    

    private func metaNamespace() -> ChannelData {
        return getChannelData("_meta")
    }
    

    private func getOrCreateChannelData( ns:String?) -> DefaultChannelData {
        
        var cd:DefaultChannelData? = nil
        
        
        if( nil == ns || "def" == ns) {
            cd = namespaces["def"]
        }
        else {
            cd = namespaces[ns!]
        }
        
        
        if( nil == cd )  {
            cd = DefaultChannelData(channel: self, ns:ns!, client:_client )
            namespaces[ns!] = cd
        }
    
        return cd!
    }

}


public class ChannelMessage {
    
    public var senderId:String
    public var payload:ByteArray
    public var channel:Channel
    
    public init( senderId:String, payload:ByteArray, channel:Channel) {
        self.senderId = senderId
        self.payload = payload
        self.channel = channel
    }
}

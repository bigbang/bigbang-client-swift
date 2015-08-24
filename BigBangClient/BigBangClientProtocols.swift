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

//Client
public typealias SubscribeCallback = ((String?, Channel?) -> Void)
public typealias ConnectCallback = ((String?) -> Void)
public typealias DisconnectCallback = (() -> Void)

//Channel
public typealias MessageCallback = (ChannelMessage) -> Void
public typealias PresenceCallback = (String) -> Void

//ChannelData
public typealias AddCallback = (String,JSON) -> Void
public typealias UpdateCallback = (String,JSON) -> Void
public typealias RemoveCallback = (String) -> Void
public typealias OperationCallback = ( JSON?, Operation) -> Void


/// The Big Bang Client!
public protocol BigBangClient {
    ///
    /// :param: appURL The URL for your application.
    ///
    init(appURL:String)
    
    ///
    /// :returns: A String representing your unique clientId for this connection. The clientId can be used to identify messages from and to you.
    ///
    func getClientId() -> String
    
    ///
    /// Call this method to connect to your application.
    /// :param: callback
    ///
    func connect(callback:ConnectCallback) -> Void
    
    func connect(email:String, password:String, callback:ConnectCallback) -> Void
    
    ///
    /// :returns: Void
    ///
    func disconnect() -> Void
    
    ///
    /// :param: callback The callback fires when the client is disconnected, either from calling disconnect() or through external forces beyond your control.
    ///
    func disconnected( callback: DisconnectCallback ) -> Void
    
    ///
    ///  Get a reference to the specified channel. The returned Channel object can be used to further interact with the channel.
    ///  :param: name The channel to retrieve
    ///  :returns: A channel if you have previously subscribed.
    ///
    func getChannel( name:String ) -> Channel?
    
    ///
    /// Subscribe to the specified channel. If the channel doesn't exist it will be created. Channel creators own the channels they create.
    /// :param: name The channel name
    //  :param: callback The callback will fire when the subscription is complete.
    //
    func subscribe( name: String, callback: SubscribeCallback) -> Void
}


public protocol Channel {
    
    ///
    /// Retrieve the channel's name
    /// :returns: The channel's name
    ///
    var name : String {
        get
    }
    
    ///
    /// Send a message to the channel. Payload can be any JSON object.
    /// :param: message A JSON message
    func publish(message:JSON) ->Void
    
    func onMessage( callback: MessageCallback) ->Void
    
    func getSubscribers() -> [String]
    
    func onJoin( callback: PresenceCallback) -> Void
    
    func onLeave( callback: PresenceCallback ) -> Void
    
    func getChannelData() -> ChannelData
    
    func getChannelData(namespace:String) -> ChannelData

}


public enum Operation {
    case Add
    case Update
    case Remove
}



public protocol ChannelData {
    
    func get(key:String) -> JSON?
    
    func keys() -> [String]
    
    func put(key:String, value:JSON ) -> Void
    
    func remove(key:String) -> Void
    
    func onAdd( callback:AddCallback ) -> Void
    
    func onUpdate( callback:UpdateCallback ) -> Void
    
    func onRemove( callback:RemoveCallback) -> Void
    
    func on( key:String, callback:OperationCallback) -> Void
    
}




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

public class DefaultChannelData : ChannelData {
        
    private var channel:DefaultChannel
    private var ns:String
    private var client:DefaultBigBangClient
    
    private var elementMap = [String:JSON]()
    private var addList = [AddCallback]()
    private var updateList = [UpdateCallback]()
    private var delList = [RemoveCallback]()
    private var keysMap = [String:[OperationCallback]]()
    
    
    public init( channel:DefaultChannel, ns:String, client:DefaultBigBangClient) {
        self.ns = ns
        self.channel = channel
        self.client = client
    }
    
    
    public func get(key:String) -> JSON? {
        return elementMap[key]
    }
    
    public func keys() -> [String] {
        return [String](elementMap.keys)
        //return elementMap.keys.array
    }
    
    public func put(key:String, value:JSON ) -> Void {
        
        let put = WireChannelDataPut()
        put.key = key
        put.ks = self.ns
        put.name = channel.name
        put.payload = value.toByteArray()
        
        client.sendToServer(put)
    
    }
    
    public func remove(key:String) -> Void {
        let rem = WireChannelDataDel()
        rem.key = key
        rem.ks = self.ns
        rem.name = self.channel.name
        
        client.sendToServer(rem)
    }
    
    public func onAdd( callback:AddCallback ) -> Void {
        addList.append(callback)
    }
    
    public func onUpdate( callback:UpdateCallback ) -> Void {
        updateList.append(callback)
    }
    
    public func onRemove( callback:RemoveCallback) -> Void {
        delList.append(callback)
    }
    
    public func on( key:String, callback:OperationCallback) -> Void {
        
        if var ops = keysMap[key] {
          ops.append(callback)
        }
        else {
            var list = [OperationCallback]()
            list.append(callback)
            keysMap[key] = list
        }
    }
    
    public func onWireChannelDataCreate( msg: WireChannelDataCreate ) -> Void {
        let o = msg.payload?.getBytesAsJson()
        
        elementMap[msg.key!] = o
        
        
        for add in addList {
            add(msg.key!, o! )
        }
   
        if let ops = keysMap[msg.key!] {
            for op in ops {
                op(o, Operation.Add)
            }
        }
    }

    public func onWireChannelDataUpdate( msg: WireChannelDataUpdate ) -> Void {
       
        let o = msg.payload?.getBytesAsJson()
        elementMap[msg.key!] = o
        
        for update in updateList {
            update(msg.key!, o!)
        }
        
        if let ops = keysMap[msg.key!] {
            for op in ops {
                op(o, Operation.Update)
            }
        }
    }
    
    public func onWireChannelDataDelete( msg: WireChannelDataDelete ) -> Void {
        elementMap[msg.key!] = nil
        
        for del in delList {
            del(msg.key!)
        }
        
        if let ops = keysMap[msg.key!] {
            for op in ops {
                op(nil, Operation.Remove)
            }
        }
        
    }
}
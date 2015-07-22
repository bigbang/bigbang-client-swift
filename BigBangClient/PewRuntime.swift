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
import SwiftyJSON
import Alamofire

public protocol PewMessage {
    
    func serializeJson() -> SwiftyJSON.JSON
    
    func deserializeJson(json:SwiftyJSON.JSON) ->Void
    
    var messageType: Int {
        get
    }
    
}


public protocol PewProtocol {
    func protocolHash() -> String
    func wrapNetstring( msg: PewMessage) -> String
    func dispatchNetstring( msg: String ) -> Void
}


public class ByteArray {
    
    private var _b64Bytes:String
    
    public init(b64bytes:String) {
        self._b64Bytes = b64bytes
    }
    
    public func getBytesAsBase64() -> String {
        return _b64Bytes  
    }
    
    public func getBytesAsJson() -> JSON {
        let data = NSData(base64EncodedString: _b64Bytes, options:   NSDataBase64DecodingOptions(rawValue: 0))
        let base64Decoded = NSString(data: data!, encoding: NSUTF8StringEncoding)
        return JSON.newJSONFromString( String(base64Decoded!) )
    }
}

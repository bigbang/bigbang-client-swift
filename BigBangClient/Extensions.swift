import Foundation
import SwiftyJSON

extension JSON {
    public static func newJSONFromString( jsonString:String ) -> JSON {
        if let dataFromString = jsonString.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false) {
            return JSON(data: dataFromString)
        }
        else {
            return JSON.nullJSON
        }
    }
    
    public static func newJSONObject() -> JSON {
        return  JSON(NSDictionary())
    }
    
    public func toByteArray() -> ByteArray {
        let utf8 = self.rawString()!.dataUsingEncoding(NSUTF8StringEncoding)
        let base64Encoded = utf8!.base64EncodedStringWithOptions(NSDataBase64EncodingOptions(rawValue: 0))
        return ByteArray(b64bytes: base64Encoded)
    }
    
}

extension String
{
    var length: Int {
        get {
            return count(self)
        }
    }
    
    func contains(s: String) -> Bool
    {
        return (self.rangeOfString(s) != nil) ? true : false
    }
    
    func replace(target: String, withString: String) -> String
    {
        return self.stringByReplacingOccurrencesOfString(target, withString: withString, options: NSStringCompareOptions.LiteralSearch, range: nil)
    }
    
    subscript (i: Int) -> Character
        {
        get {
            let index = advance(startIndex, i)
            return self[index]
        }
    }
    
    subscript (r: Range<Int>) -> String
        {
        get {
            let startIndex = advance(self.startIndex, r.startIndex)
            let endIndex = advance(self.startIndex, r.endIndex - 1)
            
            return self[Range(start: startIndex, end: endIndex)]
        }
    }
    
    func subString(startIndex: Int, length: Int) -> String
    {
        var start = advance(self.startIndex, startIndex)
        var end = advance(self.startIndex, startIndex + length)
        return self.substringWithRange(Range<String.Index>(start: start, end: end))
    }
    
    func indexOf(target: String) -> Int
    {
        var range = self.rangeOfString(target)
        if let range = range {
            return distance(self.startIndex, range.startIndex)
        } else {
            return -1
        }
    }
    
    func indexOf(target: String, startIndex: Int) -> Int
    {
        var startRange = advance(self.startIndex, startIndex)
        
        var range = self.rangeOfString(target, options: NSStringCompareOptions.LiteralSearch, range: Range<String.Index>(start: startRange, end: self.endIndex))
        
        if let range = range {
            return distance(self.startIndex, range.startIndex)
        } else {
            return -1
        }
    }
    
    func lastIndexOf(target: String) -> Int
    {
        var index = -1
        var stepIndex = self.indexOf(target)
        while stepIndex > -1
        {
            index = stepIndex
            if stepIndex + target.length < self.length {
                stepIndex = indexOf(target, startIndex: stepIndex + target.length)
            } else {
                stepIndex = -1
            }
        }
        return index
    }
    
    func isMatch(regex: String, options: NSRegularExpressionOptions) -> Bool
    {
        var error: NSError?
        var exp = NSRegularExpression(pattern: regex, options: options, error: &error)
        
        if let error = error {
            println(error.description)
        }
        var matchCount = exp!.numberOfMatchesInString(self, options: nil, range: NSMakeRange(0, self.length))
        return matchCount > 0
    }
    
    func getMatches(regex: String, options: NSRegularExpressionOptions) -> [NSTextCheckingResult]
    {
        var error: NSError?
        var exp = NSRegularExpression(pattern: regex, options: options, error: &error)
        
        if let error = error {
            println(error.description)
        }
        var matches = exp!.matchesInString(self, options: nil, range: NSMakeRange(0, self.length))
        return matches as! [NSTextCheckingResult]
    }
}
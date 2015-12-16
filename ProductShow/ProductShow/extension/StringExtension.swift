//
//  StringExtension.swift
//  CryptoSwift
//
//  Created by Marcin Krzyzanowski on 15/08/14.
//  Copyright (c) 2014 Marcin Krzyzanowski. All rights reserved.
//

import Foundation

/** String extension */
extension String {
    
//    var md5: String{
//        return (self as NSString).md5()
//    }
    
    var md5 : String{
        let str = self.cStringUsingEncoding(NSUTF8StringEncoding)
        let strLen = CC_LONG(self.lengthOfBytesUsingEncoding(NSUTF8StringEncoding))
        let digestLen = Int(CC_MD5_DIGEST_LENGTH)
        let result = UnsafeMutablePointer<CUnsignedChar>.alloc(digestLen);
        
        CC_MD5(str!, strLen, result);
        
        let hash = NSMutableString();
        for i in 0 ..< digestLen {
            hash.appendFormat("%02x", result[i]);
        }
        result.destroy();
        result.dealloc(digestLen)
        
        return hash as String
    }
    
    var URLQueryAllowedString: String{
        
        return self.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())!
    }
    
    var URL: NSURL?{
        let url = NSURL(string: self)
        if url != nil{
            return url
        }else{
            let url = NSURL(string: self.URLQueryAllowedString)
            return url
        }
    }

}


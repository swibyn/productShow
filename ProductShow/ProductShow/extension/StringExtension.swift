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
        let str = self.cString(using: String.Encoding.utf8)
        let strLen = CC_LONG(self.lengthOfBytes(using: String.Encoding.utf8))
        let digestLen = Int(CC_MD5_DIGEST_LENGTH)
        let result = UnsafeMutablePointer<CUnsignedChar>.allocate(capacity: digestLen);
        
        CC_MD5(str!, strLen, result);
        
        let hash = NSMutableString();
        for i in 0 ..< digestLen {
            hash.appendFormat("%02x", result[i]);
        }
        result.deinitialize();
        result.deallocate(capacity: digestLen)
        
        return hash as String
    }
    
    var URLQueryAllowedString: String{
        
        return self.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!
    }
    
    var URL: Foundation.URL?{
        let url = Foundation.URL(string: self)
        if url != nil{
            return url
        }else{
            let url = Foundation.URL(string: self.URLQueryAllowedString)
            return url
        }
    }

}


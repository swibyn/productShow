//
//  StringExtension.swift
//  ProductShow
//
//  Created by s on 15/10/13.
//  Copyright (c) 2015年 gaozgao. All rights reserved.
//

import Foundation

func md5String(str:String) -> String{
    var cStr = (str as NSString).UTF8String
    var buffer = UnsafeMutablePointer<UInt8>.alloc(16)
    CC_MD5(cStr,(CC_LONG)(strlen(cStr)), buffer)
    var md5String = NSMutableString()
    for var i = 0; i < 16; ++i{
        md5String.appendFormat("%X2", buffer)
    }
    
    free(buffer)
    return md5String as String
}

//extension String {
//    var md51 : String{
//        let data = self.dataUsingEncoding(NSASCIIStringEncoding)?.length
//        var md5 = UnsafeMutablePointer<UInt8>.alloc(16)
//        CC_MD5(data?.bytes, (CC_LONG)(data?.length), md5)
//        var hash = NSMutableString()
////        for i in 0..< 16 {
////            hash.appendFormat("%02x", md5[i])
////        }
//        free(md5)
//        return hash as String
        
//        let strLen = CC_LONG(self.lengthOfBytesUsingEncoding(NSUTF8StringEncoding))
//        let digestLen = Int(CC_MD5_DIGEST_LENGTH)
//        let result = UnsafeMutablePointer<UInt8>.alloc(digestLen);
        
//        CC_MD5(str!, strLen, result);
//        
//        var hash = NSMutableString();
//        for i in 0 ..< digestLen {
//            hash.appendFormat("x", result[i]);
//        }
//        result.destroy();
//        
//        return String(format: hash as String)
//        return ""
//    }

 
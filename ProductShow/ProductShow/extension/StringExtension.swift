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
    
    var md5: String{
        return (self as NSString).md5()
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


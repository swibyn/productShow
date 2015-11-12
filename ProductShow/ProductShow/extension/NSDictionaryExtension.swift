//
//  NSDictionaryExtension.swift
//  ProductShow
//
//  Created by s on 15/11/12.
//  Copyright © 2015年 zhiwx. All rights reserved.
//

import Foundation

extension NSDictionary{
    func toString(keyValueSeparator: String, elementSeparator: String)->String{
      
        let paraStr = NSMutableString()
        
        self.enumerateKeysAndObjectsUsingBlock({ (key, obj, stop) -> Void in
            if paraStr.length == 0{
                paraStr.appendString("\(key)\(keyValueSeparator)\(obj)")
            }else{
                paraStr.appendString("\(elementSeparator)\(key)\(keyValueSeparator)\(obj)")
            }
        })
        return paraStr as String
    }
}
//
//  NSDictionaryExtension.swift
//  ProductShow
//
//  Created by s on 15/11/12.
//  Copyright © 2015年 zhiwx. All rights reserved.
//

import Foundation

extension NSDictionary{
    func toString(_ keyValueSeparator: String, elementSeparator: String)->String{
      
        let paraStr = NSMutableString()
        
        self.enumerateKeysAndObjects({ (key, obj, stop) -> Void in
            if paraStr.length == 0{
                paraStr.append("\(key)\(keyValueSeparator)\(obj)")
            }else{
                paraStr.append("\(elementSeparator)\(key)\(keyValueSeparator)\(obj)")
            }
        })
        return paraStr as String
    }
}

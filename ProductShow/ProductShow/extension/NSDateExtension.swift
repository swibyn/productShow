//
//  NSDateExtension.swift
//  ProductShow
//
//  Created by s on 15/11/4.
//  Copyright © 2015年 zhiwx. All rights reserved.
//

import Foundation

extension NSDate{
    func toString(dateFormat: String)->String{
        let formatter = NSDateFormatter()
        formatter.dateFormat = dateFormat
        return formatter.stringFromDate(self)
    }
    
    func toString()->String{
        return self.toString("yyyy-MM-dd HH:mm:ss")
    }
    
}
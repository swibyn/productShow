//
//  NSDateExtension.swift
//  ProductShow
//
//  Created by s on 15/11/4.
//  Copyright © 2015年 zhiwx. All rights reserved.
//

import Foundation

extension Date{
    func toString(_ dateFormat: String)->String{
        let formatter = DateFormatter()
        formatter.dateFormat = dateFormat
        return formatter.string(from: self)
    }
    
    func toString()->String{
        return self.toString("yyyy-MM-dd HH:mm:ss")
    }
    
}

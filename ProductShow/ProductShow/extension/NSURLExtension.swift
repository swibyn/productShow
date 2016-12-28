//
//  NSURLExtension.swift
//  ProductShow
//
//  Created by s on 15/12/2.
//  Copyright © 2015年 zhiwx. All rights reserved.
//

import Foundation

extension URL{
    var localFile: String{
        let path = self.path 
        return "\(NSTemporaryDirectory())\(path)"
    }
}

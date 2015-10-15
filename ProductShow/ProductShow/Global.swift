//
//  Global.swift
//  ProductShow
//
//  Created by s on 15/9/9.
//  Copyright (c) 2015年 gaozgao. All rights reserved.
//

import Foundation

//let kPostData = "PostData"
//let kReturnData = "ReturnData"

let kProductsInCartChanged = "kProductsInCartChanged"

class Global: NSObject {
    
    static var userInfo: NSMutableDictionary? //用户信息
    
    static var cart = Cart()  //购物车

}

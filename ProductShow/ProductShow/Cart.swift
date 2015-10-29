//
//  Cart.swift
//  ProductShow
//
//  Created by s on 15/10/15.
//  Copyright © 2015年 gaozgao. All rights reserved.
//

import Foundation

/*保存格式,proId作为key,并增加amount字段*/
/* 
[
    "1":[
        "amount":1,
        "proId":1,
        "proName":"产品名称",
        "...":"..."
    ],
    "2":[
        "amount":1,
        "proId":2,
        "proName":"产品名称",
        "...":"..."
    ]
]
*/




class Cart: NSObject {
    
    let products = NSMutableDictionary()
    
    
    private static var _defaultCart = Cart()
    class func defaultCart()->Cart {
        return _defaultCart
    }
    
    //MARK:增加产品
    func addProduct(dic: NSDictionary){
        let key = "\(dic.objectForKey(jfproId) as! Int)"
        let productOpt = products.objectForKey(key) as? NSMutableDictionary
        var amount = 1
        if let product = productOpt{
            amount = (product.objectForKey("amount") as! Int) + 1
        }
        
        let mutableDic = NSMutableDictionary(dictionary: dic)
        mutableDic.setObject(amount, forKey: "amount")
        products.setObject(mutableDic, forKey: key)
    }
    
    //MARK:删除产品
    
    func removeProduct(dic: NSDictionary){
        let key = "\(dic.objectForKey(jfproId) as! Int)"
        products.removeObjectForKey(key)
    }

    //MARK:删除所有产品
    func removeProducts(){
        products.removeAllObjects()
    }
    
    //MARK:产品数量
    var productCount: Int{
        var count = 0
        products.enumerateKeysAndObjectsUsingBlock { (key, value, stop) -> Void in
            count += value as! Int
        }
        return count
    }
    
    
    //MARK:产品id集
    func getProductIds(division: String)->String{
        let ids = NSMutableString()
        products.enumerateKeysAndObjectsUsingBlock { (key, value, stop) -> Void in
            if ids.length == 0{
                ids.appendString(key as! String)
            }else{
                ids.appendString("\(division)\(key as! String)")
            }
        }
        return ids as String
    }
    
    var title: String{
        return "Cart(\(products.count))"
    }
    
}

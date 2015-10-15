//
//  Cart.swift
//  ProductShow
//
//  Created by s on 15/10/15.
//  Copyright © 2015年 gaozgao. All rights reserved.
//

import Foundation

class Cart: NSObject {
    
    let products = NSMutableDictionary()
    
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

    
    //MARK:产品数量
    var productCount: Int{
        var count = 0
        products.enumerateKeysAndObjectsUsingBlock { (key, value, stop) -> Void in
            count += value as! Int
        }
        return count
    }
    
    var productIdCount: Int{
        return products.count
    }
    
    //MARK:产品id系列
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
    
}

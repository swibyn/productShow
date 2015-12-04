//
//  Product.swift
//  ProductShow
//
//  Created by s on 15/10/19.
//  Copyright © 2015年 gaozgao. All rights reserved.
//

import Foundation

class Product: NSObject{
    private var _productDic: NSMutableDictionary?
    
    init(productDic: NSMutableDictionary) {
//        _productDic = NSMutableDictionary(dictionary:  productDic)
        _productDic = productDic
    }
    
    override init(){
        
    }
    
    var productDic: NSMutableDictionary?{
        get{
            return _productDic
        }
        set{
            _productDic = newValue
        }
    }
    
    var proId: Int?{
        return _productDic?.objectForKey(jfproId) as? Int
    }
    
    var proName: String?{
        return _productDic?.objectForKey(jfproName) as? String
    }
    
    var catId: Int?{
        return _productDic?.objectForKey(jfcatId) as? Int
    }
    
    var proSize: String?{
        return _productDic?.objectForKey(jfproSize) as? String
    }
    
    var remark: String?{
        return _productDic?.objectForKey(jfremark) as? String
    }
    
    var imgUrl: String?{
        return _productDic?.objectForKey(jfimgUrl) as? String
    }
    
    var thumbUrl: String?{
        return _productDic?.objectForKey(jfthumbUrl) as? String
    }
    
    var orderIndex: Int?{
        return _productDic?.objectForKey(jforderIndex) as? Int
    }
    
    var isHot: Int?{
        return _productDic?.objectForKey(jfisHot) as? Int
    }
    
    var promemo: String?{
        return _productDic?.objectForKey(jfpromemo) as? String
    }
    
    var proVer: String?{
        return _productDic?.objectForKey(jfproVer) as? String
    }
    
    var additionInfo: String?{
        get{
            return _productDic?.objectForKey("additionInfo") as? String
        }
        set{
            _productDic?.setValue(newValue, forKey: "additionInfo")
            
        }
        
    }
    
    //加入购物车时，多次加入则增加这个值
    var amount: Int{
        get{
            var _amount = _productDic?.objectForKey("amount") as? Int
            if _amount == nil{
                _amount = 1
            }
            return _amount!
            
        }
        set{
            _productDic?.setObject(newValue, forKey: "amount")
        }
    }
}

class Products: ReturnDic {
    
    
    private var products: NSArray?{
        return data_dt
    }
    
    var productsCount: Int{
        return products?.count ?? 0
    }
    
    func productAtIndex(index: Int)->Product?{
        let productDicOpt = products?.objectAtIndex(index) as? NSMutableDictionary
        if let productDic = productDicOpt{
            return Product(productDic: productDic)
        }else{
            return nil
        }
        
    }
}

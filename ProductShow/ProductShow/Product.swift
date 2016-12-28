//
//  Product.swift
//  ProductShow
//
//  Created by s on 15/10/19.
//  Copyright © 2015年 gaozgao. All rights reserved.
//

import Foundation

class Product: NSObject{
    fileprivate var _productDic: NSMutableDictionary?
    
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
        return _productDic?.object(forKey: jfproId) as? Int
    }
    
    var proName: String?{
        return _productDic?.object(forKey: jfproName) as? String
    }
    
    var catId: Int?{
        return _productDic?.object(forKey: jfcatId) as? Int
    }
    
    var proSize: String?{
        return _productDic?.object(forKey: jfproSize) as? String
    }
    
    var remark: String?{
        return _productDic?.object(forKey: jfremark) as? String
    }
    
    var imgUrl: String?{
        return _productDic?.object(forKey: jfimgUrl) as? String
    }
    
    var thumbUrl: String?{
        return _productDic?.object(forKey: jfthumbUrl) as? String
    }
    
    var orderIndex: Int?{
        return _productDic?.object(forKey: jforderIndex) as? Int
    }
    
    var isHot: Int?{
        return _productDic?.object(forKey: jfisHot) as? Int
    }
    
    var promemo: String?{
        return _productDic?.object(forKey: jfpromemo) as? String
    }
    
    var proVer: String?{
        return _productDic?.object(forKey: jfproVer) as? String
    }
    
    var additionInfo: String?{
        get{
            return _productDic?.object(forKey: "additionInfo") as? String
        }
        set{
            if newValue == nil{
                _productDic?.removeObject(forKey: "additionInfo")
            }else{
                _productDic?.setObject(newValue!, forKey: "additionInfo" as NSCopying)
            }
        }
    }
    
    //加入购物车时，多次加入则增加这个值
    var number: Int{
        get{
            var _number = _productDic?.object(forKey: "number") as? Int
            if _number == nil{
                _number = 1
            }
            return _number!
            
        }
        set{
            _productDic?.setObject(newValue, forKey: "number" as NSCopying)
        }
    }
}

class Products: ReturnDic {
    
    
    fileprivate var products: NSArray?{
        return data_dt
    }
    
    var productsCount: Int{
        return products?.count ?? 0
    }
    
    func productAtIndex(_ index: Int)->Product?{
        let productDicOpt = products?.object(at: index) as? NSMutableDictionary
        if let productDic = productDicOpt{
            return Product(productDic: productDic)
        }else{
            return nil
        }
        
    }
}

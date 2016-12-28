//
//  Category.swift
//  ProductShow
//
//  Created by s on 15/10/27.
//  Copyright © 2015年 zhiwx. All rights reserved.
//

import Foundation

class Category: NSObject{
    fileprivate var _categoryDic: NSDictionary?
    
    init(categoryDic: NSDictionary) {
        _categoryDic = categoryDic
    }
    
    override init(){
        
    }
    
    var categoryDic: NSDictionary?{
        get{
            return _categoryDic
        }
        set{
            _categoryDic = newValue
        }
    }
    
    var catId: Int?{
        return _categoryDic?.object(forKey: jfcatId) as? Int
    }
    
    var catName: String?{
        return _categoryDic?.object(forKey: jfcatName) as? String
    }
    
    var memo: String?{
        return _categoryDic?.object(forKey: jfmemo) as? String
    }
    
    var catNo: String?{
        return _categoryDic?.object(forKey: jfcatNo) as? String
    }
    
}

class Categories: ReturnDic {
    
    fileprivate var categories: NSArray?{
        
        return data_dt
    }
    
    var categoriesCount: Int{
        return categories?.count ?? 0
    }
    
    func categoryAtIndex(_ index: Int)->Category?{
        let categoryDicOpt = categories?.object(at: index) as? NSDictionary
        if let categoryDic = categoryDicOpt{
            return Category(categoryDic: categoryDic)
        }else{
            return nil
        }
    }
}

















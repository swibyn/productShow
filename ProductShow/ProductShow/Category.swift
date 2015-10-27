//
//  Category.swift
//  ProductShow
//
//  Created by s on 15/10/27.
//  Copyright © 2015年 zhiwx. All rights reserved.
//

import Foundation

class Category: NSObject{
    private var _categoryDic: NSDictionary?
    
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
        return _categoryDic?.objectForKey(jfcatId) as? Int
    }
    
    var catName: String?{
        return _categoryDic?.objectForKey(jfcatName) as? String
    }
    
    var memo: String?{
        return _categoryDic?.objectForKey(jfmemo) as? String
    }
    
    var catNo: String?{
        return _categoryDic?.objectForKey(jfcatNo) as? String
    }
    
}

class Categories: ReturnDic {
    
    private var categories: NSArray?{
        
        return data_dt
    }
    
    var categoriesCount: Int{
        return categories?.count ?? 0
    }
    
    func categoryAtIndex(index: Int)->Category?{
        let categoryDicOpt = categories?.objectAtIndex(index) as? NSDictionary
        if let categoryDic = categoryDicOpt{
            return Category(categoryDic: categoryDic)
        }else{
            return nil
        }
    }
}

















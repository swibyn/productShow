//
//  ReturnDic.swift
//  ProductShow
//
//  Created by s on 15/10/22.
//  Copyright © 2015年 gaozgao. All rights reserved.
//

import Foundation

class ReturnDic: NSObject{
    
    var _returnDic: NSDictionary?
    
    init(returnDic: NSDictionary?) {
        _returnDic = returnDic
    }
    
    override init(){
        
    }
    
    var returnDic: NSDictionary?{
        get{
            return _returnDic
        }
        set{
            _returnDic = newValue
        }
    }
    
    var status: Int?{
        return _returnDic?.objectForKey(jfstatus) as? Int
    }
    
    var message: String?{
        return _returnDic?.objectForKey(jfmessage) as? String
    }
    
    var data_dt: NSArray?{
        let data = _returnDic?.objectForKey(jfdata) as? NSDictionary
        let dt = data?.objectForKey(jfdt) as? NSArray
        return dt
    }
    
}

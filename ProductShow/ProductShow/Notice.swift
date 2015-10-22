//
//  Notice.swift
//  ProductShow
//
//  Created by s on 15/10/22.
//  Copyright © 2015年 gaozgao. All rights reserved.
//

import Foundation

class Notice: NSObject{
    private var _noticeDic: NSDictionary?
    
    init(noticeDic: NSDictionary) {
        _noticeDic = noticeDic
    }
    
    override init(){
        
    }
    
    var noticeDic: NSDictionary?{
        get{
            return _noticeDic
        }
        set{
            _noticeDic = newValue
        }
    }
    
    var noticeId: Int?{
        return _noticeDic?.objectForKey(jfnoticeId) as? Int
    }
    
    var title: String?{
        return _noticeDic?.objectForKey(jftitle) as? String
    }
    
    var contents: String?{
        return _noticeDic?.objectForKey(jfcontents) as? String
    }
    
    var releaseDate: String?{
        return _noticeDic?.objectForKey(jfreleaseDate) as? String
    }
    
    var isUser: Int?{
        return _noticeDic?.objectForKey(jfisUse) as? Int
    }
    
}

class Notices: ReturnDic {
    
    private var notices: NSArray?{
       
//        let data = _returnDic?.objectForKey(jfdata) as? NSDictionary
//        let dt = data?.objectForKey(jfdt) as? NSArray
        return data_dt
    }
    
    var noticesCount: Int{
        return notices?.count ?? 0
    }
    
    func noticeAtIndex(index: Int)->Notice?{
        let noticeDicOpt = notices?.objectAtIndex(index) as? NSDictionary
        if let noticeDic = noticeDicOpt{
            return Notice(noticeDic: noticeDic)
        }else{
            return nil
        }
        
    }
}







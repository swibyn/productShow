//
//  Notice.swift
//  ProductShow
//
//  Created by s on 15/10/22.
//  Copyright © 2015年 gaozgao. All rights reserved.
//

import Foundation

class Notice: NSObject{
    fileprivate var _noticeDic: NSDictionary?
    
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
        return _noticeDic?.object(forKey: jfnoticeId) as? Int
    }
    
    var title: String?{
        return _noticeDic?.object(forKey: jftitle) as? String
    }
    
    var contents: String?{
        return _noticeDic?.object(forKey: jfcontents) as? String
    }
    
    var releaseDate: String?{
        return _noticeDic?.object(forKey: jfreleaseDate) as? String
    }
    
    var isUser: Int?{
        return _noticeDic?.object(forKey: jfisUse) as? Int
    }
    
}

class Notices: ReturnDic {
    
    fileprivate var notices: NSArray?{
       
//        let data = _returnDic?.objectForKey(jfdata) as? NSDictionary
//        let dt = data?.objectForKey(jfdt) as? NSArray
        return data_dt
    }
    
    var noticesCount: Int{
        return notices?.count ?? 0
    }
    
    func noticeAtIndex(_ index: Int)->Notice?{
        let noticeDicOpt = notices?.object(at: index) as? NSDictionary
        if let noticeDic = noticeDicOpt{
            return Notice(noticeDic: noticeDic)
        }else{
            return nil
        }
        
    }
}







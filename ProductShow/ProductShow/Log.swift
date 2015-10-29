//
//  Log.swift
//  ProductShow
//
//  Created by s on 15/10/28.
//  Copyright © 2015年 zhiwx. All rights reserved.
//

import Foundation

class Log: NSObject{
    private var _logDic: NSDictionary?
    
    init(logDic: NSDictionary) {
        _logDic = logDic
    }
    
    override init(){
        
    }
    
    var logDic: NSDictionary?{
        get{
            return _logDic
        }
        set{
            _logDic = newValue
        }
    }
    
    var logId: Int?{
        return _logDic?.objectForKey(jfcatId) as? Int
    }
    
    var uid: Int?{
        return _logDic?.objectForKey(jfuid) as? Int
    }
    
    var uName: String?{
        return _logDic?.objectForKey(jfuName) as? String
    }
    
    var logContent: String?{
        return _logDic?.objectForKey(jflogContent) as? String
    }
    
    var logDesc: String?{
        return _logDic?.objectForKey(jflogDesc) as? String
    }
    
    var logWeek: Int?{
        return _logDic?.objectForKey(jflogWeek) as? Int
    }
    
    var logDate: String?{
        return _logDic?.objectForKey(jflogDate) as? String
    }
    
    var custId: Int?{
        return _logDic?.objectForKey(jfcustId) as? Int
    }
    
    var custName: String?{
        return _logDic?.objectForKey(jfcustName) as? String
    }
    
}

class Logs: ReturnDic {
    
    private var logs: NSArray?{
        
        return data_dt
    }
    
    var logsCount: Int{
        return logs?.count ?? 0
    }
    
    func logAtIndex(index: Int)->Log?{
        let logDicOpt = logs?.objectAtIndex(index) as? NSDictionary
        if let logDic = logDicOpt{
            return Log(logDic: logDic)
        }else{
            return nil
        }
    }
}
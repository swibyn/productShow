//
//  Log.swift
//  ProductShow
//
//  Created by s on 15/10/28.
//  Copyright © 2015年 zhiwx. All rights reserved.
//

import Foundation

class Log: NSObject{
    fileprivate var _logDic: NSDictionary?
    
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
        return _logDic?.object(forKey: jflogId) as? Int
    }
    
    var uid: Int?{
        return _logDic?.object(forKey: jfuid) as? Int
    }
    
    var uName: String?{
        return _logDic?.object(forKey: jfuName) as? String
    }
    
    var logContent: String?{
        return _logDic?.object(forKey: jflogContent) as? String
    }
    
    var logDesc: String?{
        return _logDic?.object(forKey: jflogDesc) as? String
    }
    
    var logWeek: Int?{
        return _logDic?.object(forKey: jflogWeek) as? Int
    }
    
    var logDate: String?{
        return _logDic?.object(forKey: jflogDate) as? String
    }
    
    var custId: Int?{
        return _logDic?.object(forKey: jfcustId) as? Int
    }
    
    var custName: String?{
        return _logDic?.object(forKey: jfcustName) as? String
    }
    
}

class Logs: ReturnDic {
    
    fileprivate var logs: NSMutableArray?{
        
        return data_dt as? NSMutableArray
    }
    
    var logsCount: Int{
        return logs?.count ?? 0
    }
    
    func logAtIndex(_ index: Int)->Log?{
        let logDicOpt = logs?.object(at: index) as? NSDictionary
        if let logDic = logDicOpt{
            return Log(logDic: logDic)
        }else{
            return nil
        }
    }
    
    func removeLogAtIndex(_ index: Int){
        logs?.removeObject(at: index)
    }

}













//
//  AllUrl.swift
//  ProductShow
//
//  Created by s on 15/11/3.
//  Copyright © 2015年 zhiwx. All rights reserved.
//

import Foundation

class CRMUrl: NSObject{
    
    
    
    var urlDic: NSMutableDictionary?
    
    var url: String?{
        return urlDic?.objectForKey(jfurl) as? String
    }
    
    var fileType: String?{
        return urlDic?.objectForKey(jffileType) as? String
    }
    
    var Synced: Bool{
        get{
            let _Synced = urlDic?.objectForKey("Synced") as? Bool
            return _Synced ?? false
        }
        set{
            urlDic?.setObject(newValue, forKey: "Synced")
        }
    }
    
    var SyncDescription: String{
        if Synced{
            return "Succeed:\(url ?? "")"
        }else{
            return "Failure:\(url ?? "")"
        }
    }
}

class AllCRMUrl: NSObject {
    
    var urlArray: NSMutableArray?
    
    var urlCount: Int{
        return urlArray?.count ?? 0
    }
    
//    var syncedFailCount: Int{
//        var result = 0
//        for index in 0..<urlCount{
//            if urlAtIndex(index)?.Synced == false{
//                result++
//            }
//        }
//        return result
//    }
    
    func urlArrayWithSynced(synced: Bool)->NSArray{
        
        let _urlArray = NSMutableArray()
        for index in 0..<urlCount{
            let url = urlAtIndex(index)
            if url?.Synced == synced{
                _urlArray.addObject(url!)
            }
        }
        return _urlArray
    }
    
    func urlAtIndex(index: Int)->CRMUrl?{
        let urlDicOpt = urlArray?.objectAtIndex(index) as? NSMutableDictionary
        if let urlDic = urlDicOpt{
            let crmUrl = CRMUrl()
            crmUrl.urlDic = urlDic
            return crmUrl
        }else{
            return nil
        }
    }
}









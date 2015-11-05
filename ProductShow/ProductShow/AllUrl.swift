//
//  AllUrl.swift
//  ProductShow
//
//  Created by s on 15/11/3.
//  Copyright © 2015年 zhiwx. All rights reserved.
//

import Foundation

class CRMUrl: NSObject{
    var urlDic: NSDictionary?
    
    var url: String?{
        return urlDic?.objectForKey(jfurl) as? String
    }
    
    var fileType: String?{
        return urlDic?.objectForKey(jffileType) as? String
    }
}

class AllCRMUrl: NSObject {
    
    var urlArray: NSArray?
    
    var urlCount: Int{
        return urlArray?.count ?? 0
    }
    
    func urlAtIndex(index: Int)->CRMUrl?{
        let urlDicOpt = urlArray?.objectAtIndex(index) as? NSDictionary
        if let urlDic = urlDicOpt{
            let crmUrl = CRMUrl()
            crmUrl.urlDic = urlDic
            return crmUrl
        }else{
            return nil
        }
    }
}
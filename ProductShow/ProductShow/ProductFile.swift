//
//  ProductFiles.swift
//  ProductShow
//
//  Created by s on 15/10/19.
//  Copyright © 2015年 gaozgao. All rights reserved.
//

import Foundation

class ProductFile: NSObject{
    private var _proFileDic: NSDictionary?
    
    init(proFileDic: NSDictionary) {
        _proFileDic = proFileDic
    }
    
    override init(){
        
    }
    
    var fileDic: NSDictionary?{
        get{
            return _proFileDic
        }
        set{
            _proFileDic = newValue
        }
    }
    
    var fileId: Int?{
        return _proFileDic?.objectForKey(jffileId) as? Int
    }
    
    var proId: Int?{
        return _proFileDic?.objectForKey(jfproId) as? Int
    }
    
    var fileType: Int?{
        return _proFileDic?.objectForKey(jffileType) as? Int
    }
    
    var filePath: String?{
        return _proFileDic?.objectForKey(jffilePath) as? String
    }
    
}

class ProductFiles: NSObject {
    
    private var _proFilesDic: NSDictionary?
    
    init(proFilesDic: NSDictionary) {
        _proFilesDic = proFilesDic
    }
    
    override init(){
        
    }

    var filesDic: NSDictionary?{
        get{
            return _proFilesDic
        }
        set{
            _proFilesDic = newValue
        }
    }
    
    var status: Int{
        return (_proFilesDic?.objectForKey(jfstatus) as? Int) ?? 0
    }
    
    private var files: NSArray?{
        //用户信息
        let data = _proFilesDic?.objectForKey(jfdata) as? NSDictionary
        let dt = data?.objectForKey(jfdt) as? NSArray
        return dt
    }
    
    var filesCount: Int{
        return files?.count ?? 0
    }
    
    func productFileAtIndex(index: Int)->ProductFile?{
        let fileDicOpt = files?.objectAtIndex(index) as? NSDictionary
        if let fileDic = fileDicOpt{
            return ProductFile(proFileDic: fileDic)
        }else{
            return nil
        }
        
    }
}











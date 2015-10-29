//
//  WebApi.swift
//  ProductShow
//
//  Created by s on 15/9/9.
//  Copyright (c) 2015年 gaozgao. All rights reserved.
//

import UIKit
//import WebApi.JsonField

let bOffLine = false

enum RequestType: UInt8{
    case ReadOnly = 1
    case Request = 2
    case ReadAndRequest = 3
    case ReadOrRequest = 4
}

class WebApi: NSObject {
    static let baseUrlStr = "http://btl.zhiwx.com/crmapi/"
    static let httpPost = "POST"
    static let httpGet = "GET"
    
    //MARK: 基础方法
    class func fullUrlStr(subUrlStr: String) -> String{
        return baseUrlStr + subUrlStr
    }
    
    class func isHttpSucceed(response: NSURLResponse?, data: NSData?, error: NSError?) -> Bool{
        let bOK = (error == nil) && (data?.length > 0) && (response == nil || (response as? NSHTTPURLResponse)!.statusCode == 200)
        return bOK
    }
    
    class func URLRequestWith(var subUrlStr: String, httpMethod: String, jsonObj: NSDictionary?)->NSURLRequest{
        
        let eqNo = UIDevice.currentDevice().advertisingIdentifier.UUIDString
        let paraDic = NSMutableDictionary()
        if let json = jsonObj{
            paraDic.setDictionary(json as [NSObject : AnyObject])
        }
        paraDic.setObject(eqNo, forKey: jfeqNo)

        if httpMethod == httpGet{
            let para = NSMutableString()
            
            paraDic.enumerateKeysAndObjectsUsingBlock({ (key, obj, stop) -> Void in
                if para.length == 0{
                    para.appendString("\(key)=\(obj)")
                }else{
                    para.appendString("&\(key)=\(obj)")
                }
            })
            if para.length > 0{
                subUrlStr = "\(subUrlStr)?\(para)"
            }
            
            var fullUrlStr = self.fullUrlStr(subUrlStr)
            fullUrlStr = fullUrlStr.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())!
            
            let urlRequest = NSMutableURLRequest(URL: NSURL(string: fullUrlStr)!, cachePolicy: NSURLRequestCachePolicy.ReloadIgnoringLocalCacheData, timeoutInterval: 5.0)
            urlRequest.HTTPMethod = httpGet
            return urlRequest
            
        }else{
            let fullUrlStr = self.fullUrlStr(subUrlStr)
            let urlRequest = NSMutableURLRequest(URL: NSURL(string: fullUrlStr)!, cachePolicy: NSURLRequestCachePolicy.ReloadIgnoringLocalCacheData, timeoutInterval: 5.0)
            urlRequest.HTTPMethod = httpPost
            
            let paraData = try! NSJSONSerialization.dataWithJSONObject(paraDic, options: NSJSONWritingOptions())
            urlRequest.HTTPBody = paraData
            
            
            return urlRequest
        }
    }
    
    class func AsynchronousRequest(subUrlStr: String, httpMethod:String, jsonObj: NSDictionary?, completedHandler:((NSURLResponse?,NSData?,NSError?)->Void)?){
        
//        //prepare parameters
//        var para: NSMutableString
//        let mutableJsonObj = NSMutableDictionary()
//        if let mJsonObj = jsonObj{
//            mutableJsonObj.setDictionary(mJsonObj as [NSObject : AnyObject])
//        }
//        let eqNo = UIDevice.currentDevice().identifierForVendor!.UUIDString
//        mutableJsonObj.setValue(eqNo, forKey: "eqNo")
////        if let mJsonObj: AnyObject = jsonObj{
//            if httpMethod == httpGet{
//                para = NSMutableString(string: "")
//                mutableJsonObj.enumerateKeysAndObjectsUsingBlock({ (key, obj, stop) -> Void in
//                    if para.length == 0{
//                        para.appendString("\(key)=\(obj)")
//                    }else{
//                        para.appendString("&\(key)=\(obj)")
//                    }
//                })
//                subUrlStr = "\(subUrlStr)?\(para)"
//            }
//        
//        var url = fullUrlStr(subUrlStr)
//        
//        url = url.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())!
//        
//        let urlRequest = NSMutableURLRequest(URL: NSURL(string: url)!, cachePolicy: NSURLRequestCachePolicy.ReloadIgnoringLocalCacheData, timeoutInterval: 5.0)
//        urlRequest.HTTPMethod = httpMethod
//        if httpMethod == httpPost{
//            if let mJson = jsonObj{
//                let jsonData: NSData?
//                jsonData = try? NSJSONSerialization.dataWithJSONObject(mJson, options: NSJSONWritingOptions())
//                urlRequest.HTTPBody = jsonData
//            }
//        }
        
        
        let urlRequest = self.URLRequestWith(subUrlStr, httpMethod: httpMethod, jsonObj: jsonObj)
//        debugPrint("发送：\(urlRequest)")
        let queue = NSOperationQueue()
        NSURLConnection.sendAsynchronousRequest(urlRequest, queue: queue) { (response, data, connectionError) -> Void in
            if data != nil{
//                let json = try? NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.AllowFragments)
            
//                debugPrint("收到数据：\(json!)")
            }
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    completedHandler?(response,data,connectionError)
                })

        }
    }
    
    class func readAndRequest(requestType: RequestType, saveKey: String, subURL: String, httpMethod:String, jsonObj: NSDictionary?, completedHandle:((NSURLResponse?,NSData?,NSError?)->Void)?) {
        
        switch requestType{
            
        case RequestType.ReadOnly:
            
            let localData = NSUserDefaults.standardUserDefaults().objectForKey(saveKey) as? NSData
            if let mLocalData = localData{
//                debugPrint("本地读到数据：\(saveKey) =\(mLocalData)")
                completedHandle?(nil,mLocalData,nil)
            }else{
//                debugPrint("本地未读到数据：\(saveKey)")
            }
            
        case RequestType.Request:
            
            self.AsynchronousRequest(subURL, httpMethod: httpMethod, jsonObj: jsonObj, completedHandler: completedHandle)
            
        case RequestType.ReadAndRequest:
            
            var bhandle = false
            let localData = NSUserDefaults.standardUserDefaults().objectForKey(saveKey) as? NSData
            if let mLocalData = localData{
                //                debugPrintln("本地读到数据：\(saveKey) = \(mLocalData)")

                
//                let json = try? NSJSONSerialization.JSONObjectWithData(mLocalData, options: NSJSONReadingOptions.AllowFragments)
               
//                debugPrint("本地读到数据：\(saveKey) =\(json!)")
                
                bhandle = true
                completedHandle?(nil,mLocalData,nil)
            }
            AsynchronousRequest(subURL, httpMethod: httpMethod, jsonObj: jsonObj, completedHandler:{
                (response, data, error) -> Void in
                if self.isHttpSucceed(response, data: data, error: error){
                    NSUserDefaults.standardUserDefaults().setObject(data, forKey: saveKey)
                }
                if !bhandle{
                    completedHandle?(response,data,error)
                }
            })
            
        case RequestType.ReadOrRequest:
            
            let localData = NSUserDefaults.standardUserDefaults().objectForKey(saveKey) as? NSData
            if let mLocalData = localData{
//                debugPrint("本地读到数据：\(saveKey) data.length=\(mLocalData.length)")
                completedHandle?(nil,mLocalData,nil)
            }else{
                self.AsynchronousRequest(subURL, httpMethod: httpMethod, jsonObj: jsonObj, completedHandler:{
                    (response, data, error) -> Void in
                    if self.isHttpSucceed(response, data: data, error: error){
                        NSUserDefaults.standardUserDefaults().setObject(data, forKey: saveKey)
                    }
                    completedHandle?(response,data,error)
                    
                    }
                )
            }
        }
    }
    
    class func localFileName(var fileURL: String?)->String? {
        if fileURL?.characters.count > 0{
            fileURL = fileURL!.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())!
            
            let url = NSURL(string: fileURL!)!
            
            //本地对应的文件名称
            let fileSavedName = NSTemporaryDirectory().stringByAppendingString(url.path!)
            return fileSavedName
        }
        return nil
    }
    
    class func GetFile(var fileURL: String?, completedHandler:((NSURLResponse?,NSData?,NSError?)->Void)?){
//        let fileManager = NSFileManager()
        if fileURL == nil{
            debugPrint("----文件URL为nil----")
            completedHandler?(nil,nil,nil)
            return
        }
        if fileURL!.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet()) == ""{
            debugPrint("----文件URL为空----")
            completedHandler?(nil,nil,nil)
            return
        }
 
        fileURL = fileURL!.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())!
        
        let url = NSURL(string: fileURL!)!
        let fileManager = NSFileManager()
        
        //本地对应的文件名称
        let fileSavedName = NSTemporaryDirectory().stringByAppendingString(url.path!)
        
        //如果文件存在，则直接导入
        if fileManager.fileExistsAtPath(fileSavedName){
            let data = NSData(contentsOfFile: fileSavedName)
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                completedHandler?(nil,data,nil)
            })
            return
        }
        
        //不存在则创建目录
        let fileSavedPath = NSString(string: fileSavedName).stringByDeletingLastPathComponent
        
        do {
            try fileManager.createDirectoryAtPath(fileSavedPath, withIntermediateDirectories: true, attributes: nil)
        } catch _ {
        }
        let urlRequest = NSURLRequest(URL: url)
        let queue = NSOperationQueue()
        debugPrint("开始下载文件:\(fileURL)")
        NSURLConnection.sendAsynchronousRequest(urlRequest, queue: queue) { (response, data, error) -> Void in
            
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                if WebApi.isHttpSucceed(response, data: data, error: error){
                    debugPrint("文件下载成功:\(fileURL)")
                    data!.writeToFile(fileSavedName, atomically: true)
                }
                completedHandler?(response,data,error)
            })

        }
    }
    
    
    //MARK: 1. 发送设备编码
    class func SendEquipCode(dic: NSDictionary,completedHandler:((NSURLResponse?,NSData?,NSError?)->Void)?){
        self.readAndRequest(RequestType.Request, saveKey: "SendEquipCode", subURL: "CrmSendEquipCode", httpMethod: self.httpGet, jsonObj: dic, completedHandle: completedHandler)
    }
    
    //MARK: 2. 登录校验
    class func Login(dic: NSDictionary,completedHandler:((NSURLResponse?,NSData?,NSError?)->Void)?){
        if bOffLine {
            let path = NSBundle.mainBundle().pathForResource("userinfo", ofType: "json")
            let userinfoData = NSData(contentsOfFile: path!)
            completedHandler?(nil,userinfoData,nil)
            
        }else{
            self.readAndRequest(RequestType.Request, saveKey: "Login", subURL: "CrmLogin", httpMethod: self.httpGet, jsonObj: dic, completedHandle: completedHandler)
            
        }
    }
    
    //MARK: 3. 获取热门产品：
    class func GetHotPro(dic: NSDictionary?,completedHandler:((NSURLResponse?,NSData?,NSError?)->Void)?){
        self.readAndRequest(RequestType.ReadAndRequest, saveKey: "GetHotPro", subURL: "CrmGetHotPro", httpMethod: self.httpGet, jsonObj: dic, completedHandle: completedHandler)
    }
    
    //MARK: 4. 获取一级产品分类
    class func GetProLeave1(dic: NSDictionary?,completedHandler:((NSURLResponse?,NSData?,NSError?)->Void)?){
        self.readAndRequest(RequestType.ReadAndRequest, saveKey: "GetProLeave1", subURL: "CrmGetProLeave1", httpMethod: self.httpGet, jsonObj: dic, completedHandle: completedHandler)
    }
    
    //MARK: 5. 获取二级产品分类
    class func GetProLeave2(dic: NSDictionary,completedHandler:((NSURLResponse?,NSData?,NSError?)->Void)?){
        
        let catId = dic.objectForKey(jfpId) as! Int
        self.readAndRequest(RequestType.ReadAndRequest, saveKey: "GetProLeave2-\(catId)", subURL: "CrmGetProLeave2", httpMethod: self.httpGet, jsonObj: dic, completedHandle: completedHandler)
    }
    
    //MARK: 6. 产品查询
    class func SelectPro(dic: NSDictionary?,completedHandler:((NSURLResponse?,NSData?,NSError?)->Void)?){
        
        self.readAndRequest(RequestType.Request, saveKey: "", subURL: "CrmSelectPro", httpMethod: self.httpGet, jsonObj: dic, completedHandle: completedHandler)
    }
    
    class func GetProductsByCatId(dic: NSDictionary,completedHandler:((NSURLResponse?,NSData?,NSError?)->Void)?){
        
        let catId = dic.objectForKey(jfcatId) as! Int
        self.readAndRequest(RequestType.ReadAndRequest, saveKey: "GetProductsByCatId-\(catId)", subURL: "CrmSelectPro", httpMethod: self.httpGet, jsonObj: dic, completedHandle: completedHandler)
    }
    
    //MARK: 8. 根据产品ID获取产品的图片地址和视频地址
    
    class func GetProFilesByID(dic: NSDictionary?,completedHandler:((NSURLResponse?,NSData?,NSError?)->Void)?){
        
        let proId = dic?.objectForKey(jfproId) as! Int
        self.readAndRequest(RequestType.ReadAndRequest, saveKey: "GetProFilesByID-\(proId)", subURL: "CrmGetProFilesByID", httpMethod: self.httpGet, jsonObj: dic, completedHandle: completedHandler)
    }
    
    //MARK: 9. 获取客户数据
    class func GetCustomer(dic: NSDictionary,completedHandler:((NSURLResponse?,NSData?,NSError?)->Void)?){
        
        self.readAndRequest(RequestType.ReadAndRequest, saveKey: "GetCustomer", subURL: "CrmGetCustomer", httpMethod: self.httpGet, jsonObj: dic, completedHandle: completedHandler)
    }
    
    //MARK: 10. 获取客户关注产品
    class func GetCustomerCare(dic: NSDictionary,completedHandler:((NSURLResponse?,NSData?,NSError?)->Void)?){
        
        self.readAndRequest(RequestType.ReadAndRequest, saveKey: "GetCustomerCare", subURL: "CrmGetCustomerCare", httpMethod: self.httpGet, jsonObj: dic, completedHandle: completedHandler)
    }


    //MARK: 11. 获取用户数据
    class func GetUserInfo(dic: NSDictionary,completedHandler:((NSURLResponse?,NSData?,NSError?)->Void)?){
        
        self.readAndRequest(RequestType.ReadAndRequest, saveKey: "GetUserInfo", subURL: "CrmGetUserInfo", httpMethod: self.httpGet, jsonObj: dic, completedHandle: completedHandler)
    }
    
    //MARK: 12. 获取系统公告
    class func GetNotice(dic: NSDictionary?,completedHandler:((NSURLResponse?,NSData?,NSError?)->Void)?){
        
        self.readAndRequest(RequestType.ReadAndRequest, saveKey: "GetNotice", subURL: "CrmGetNotice", httpMethod: self.httpGet, jsonObj: dic, completedHandle: completedHandler)
    }
    
    //MARK: 13. 写拜访日志
    class func WriteCustLog(dic: NSDictionary,completedHandler:((NSURLResponse?,NSData?,NSError?)->Void)?){
        
        self.readAndRequest(RequestType.Request, saveKey: "", subURL: "CrmWriteCustLog", httpMethod: self.httpPost, jsonObj: dic, completedHandle: completedHandler)
    }
    
    //MARK: 14. 提交购物车及照片
    class func SendShopData(dic: NSDictionary,completedHandler:((NSURLResponse?,NSData?,NSError?)->Void)?){
        
        self.readAndRequest(RequestType.Request, saveKey: "", subURL: "CrmSendShopData", httpMethod: self.httpPost, jsonObj: dic, completedHandle: completedHandler)
    }

    //MARK: 15. 上传文件接口
    class func UpFile1(imageData: NSData, completedHandler:((NSURLResponse?,NSData?,NSError?)->Void)?){
        
        let eqNo = UIDevice.currentDevice().advertisingIdentifier.UUIDString
        let uid = UserInfo.defaultUserInfo().firstUser?.uid
        let url = ("http://btl.zhiwx.com/api/crmUpFile.ashx?\(jfeqNo)=\(eqNo)&\(jfuid)=\(uid!)")
        UploadFile().uploadFileWithURL(NSURL(string: url)!, data: imageData) { (response, data, error) -> Void in
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                completedHandler?(response,data,error)
            })
        }
    }
    
    //MARK: 16. 获取拜访日志
    class func GetWorkLog(dic: NSDictionary,completedHandler:((NSURLResponse?,NSData?,NSError?)->Void)?){
        
        self.readAndRequest(RequestType.Request, saveKey: "", subURL: "CrmGetWorkLog", httpMethod: self.httpGet, jsonObj: dic, completedHandle: completedHandler)
    }
    
    //MARK: 17. 修改密码
    class func ChangePwd(dic: NSDictionary,completedHandler:((NSURLResponse?,NSData?,NSError?)->Void)?){
        
        self.readAndRequest(RequestType.Request, saveKey: "", subURL: "CrmChangePwd", httpMethod: self.httpPost, jsonObj: dic, completedHandle: completedHandler)
    }

    
}




































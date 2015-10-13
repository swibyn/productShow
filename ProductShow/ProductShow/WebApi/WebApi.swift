//
//  WebApi.swift
//  ProductShow
//
//  Created by s on 15/9/9.
//  Copyright (c) 2015年 gaozgao. All rights reserved.
//

import UIKit
//import WebApi.JsonField

enum RequestType: UInt8{
    case ReadOnly = 1
    case Request = 2
    case ReadAndRequest = 3
    case ReadOrRequest = 4
}

class WebApi: NSObject {
    static let baseURL = "http://btl.zhiwx.com/crmapi/"
    static let httpPost = "POST"
    static let httpGet = "GET"
    
    //MARK: 基础方法
    class func fullURL(subURL: String) -> String{
        return baseURL + subURL
    }
    
    class func isHttpSucceed(response: NSURLResponse!, data: NSData!, error: NSError!) -> Bool{
        let bOK = (error == nil) && (data.length > 0) && (response == nil || (response as? NSHTTPURLResponse)!.statusCode == 200)
        return bOK
    }
    
    
    class func AsynchronousRequest(var subURL: String, httpMethod:String, jsonObj: NSDictionary?, completedHandler:((NSURLResponse?,NSData,NSError?)->Void)?){
        
        //prepare parameters
        var para: NSMutableString
        
        if let mJsonObj: AnyObject = jsonObj{
            if httpMethod == httpGet{
                para = NSMutableString(string: "")
                jsonObj?.enumerateKeysAndObjectsUsingBlock({ (key, obj, stop) -> Void in
                    if para.length == 0{
                        para.appendString("\(key)=\(obj)")
                    }else{
                        para.appendString("&\(key)=\(obj)")
                    }
                })
                subURL = "\(subURL)?\(para)"
            }
        }
        
        //urlRequest init
        var url = fullURL(subURL)
        url = url.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)!
        let urlRequest = NSMutableURLRequest(URL: NSURL(string: url)!, cachePolicy: NSURLRequestCachePolicy.ReloadIgnoringLocalCacheData, timeoutInterval: 5.0)
        urlRequest.HTTPMethod = httpMethod
        if httpMethod == httpPost{
            if let mJson = jsonObj{
                var error: NSErrorPointer = nil
                let jsonData = NSJSONSerialization.dataWithJSONObject(mJson, options: NSJSONWritingOptions.allZeros, error: error)
                urlRequest.HTTPBody = jsonData
            }
        }
        
        //set http header
//        if urlRequest.valueForHTTPHeaderField("Content-Type") == nil{
//            urlRequest.setValue("application/json", forHTTPHeaderField:"Content-Type")
//        }
        
        //set token
//        let errorCode = Global.userInfo?.objectForKey(jfErrorCode) as? String
//        if errorCode == "0"{
//            let dicData = Global.userInfo?.objectForKey(jfData) as? NSDictionary
//            let token = dicData?.objectForKey(jfToken) as? String
//            urlRequest.setValue(token, forHTTPHeaderField: jfToken)
//        }
        
        //Authorization
//        let dicPostData = Global.userInfo?.objectForKey(kPostData) as? NSDictionary
//        let phoneNo = dicPostData?.valueForKey(jfMobile) as? String
//        if phoneNo != nil{
//            let phoneNoData = phoneNo?.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: true)
//            let base64PhoneNo = phoneNoData?.base64EncodedStringWithOptions(NSDataBase64EncodingOptions.Encoding64CharacterLineLength)
//            urlRequest.setValue(base64PhoneNo, forHTTPHeaderField: "Authorization")
//        }
        
        debugPrintln("发送 \(urlRequest)\n HTTPBody=\(urlRequest.HTTPBody)")
        let queue = NSOperationQueue()
        NSURLConnection.sendAsynchronousRequest(urlRequest, queue: queue) { (response, data, connectionError) -> Void in
           // debugPrintln("返回 \(response)\n data.length=\(data.length) \nconnecttionError=\(connectionError)")
        
            var errorPointer: NSErrorPointer = nil
            var json:AnyObject? = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.AllowFragments, error: errorPointer)
            println("返回 json=\(json)")

//            var bHandle = false
//            let httpResponse = response as? NSHTTPURLResponse
//            if (httpResponse?.statusCode == 202){
//                //TOKEN 过期
//                if (!(subURL == "Login")){
//                    //阻塞方式重新登录
//                    let dicPost = Global.userInfo?.objectForKey(kPostData) as? NSDictionary
//                    let mobile = dicPost?.objectForKey(jfMobile) as? String
//                    let password = dicPost?.objectForKey(jfPassword) as? String
//                    
//                    //TODO: 尝试登录 再发送一次请求
//                }
//            }
            //处理响应
//            if (!bHandle){
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    completedHandler?(response,data,connectionError)
                })
//            }
        }
    }
    
    class func readAndRequest(requestType: RequestType, saveKey: String, subURL: String, httpMethod:String, jsonObj: NSDictionary?, completedHandle:((NSURLResponse?,NSData?,NSError?)->Void)?) {
        
        switch requestType{
            
        case RequestType.ReadOnly:
            
            let localData = NSUserDefaults.standardUserDefaults().objectForKey(saveKey) as? NSData
            if let mLocalData = localData{
                debugPrintln("本地读到数据：\(saveKey) =\(mLocalData)")
                completedHandle?(nil,mLocalData,nil)
            }else{
                debugPrintln("本地未读到数据：\(saveKey)")
            }
            
        case RequestType.Request:
            
            self.AsynchronousRequest(subURL, httpMethod: httpMethod, jsonObj: jsonObj, completedHandler: completedHandle)
            
        case RequestType.ReadAndRequest:
            
            var bhandle = false
            let localData = NSUserDefaults.standardUserDefaults().objectForKey(saveKey) as? NSData
            if let mLocalData = localData{
                //                debugPrintln("本地读到数据：\(saveKey) = \(mLocalData)")
                var errorPointer: NSErrorPointer = nil
                var json:AnyObject? = NSJSONSerialization.JSONObjectWithData(mLocalData, options: NSJSONReadingOptions.AllowFragments, error: errorPointer)
                debugPrintln("本地读到数据：\(saveKey) =\(json!)")
                
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
                debugPrintln("本地读到数据：\(saveKey) data.length=\(mLocalData.length)")
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
    
    class func getFile(filePath: String, completedHandler:((NSURLResponse!,NSData!,NSError!)->Void)?){
        let fileManager = NSFileManager()
    }
    
    //MARK: 1. 发送设备编码
    class func SendEquipCode(dic: NSDictionary,completedHandler:((NSURLResponse?,NSData?,NSError?)->Void)?){
        self.readAndRequest(RequestType.ReadOrRequest, saveKey: "SendEquipCode", subURL: "CrmSendEquipCode", httpMethod: self.httpGet, jsonObj: dic, completedHandle: completedHandler)
    }
    
    //MARK: 2. 登录校验
    class func Login(dic: NSDictionary,completedHandler:((NSURLResponse?,NSData?,NSError?)->Void)?){
        self.readAndRequest(RequestType.Request, saveKey: "Login", subURL: "CrmLogin", httpMethod: self.httpGet, jsonObj: dic, completedHandle: completedHandler)
    }
    
    //MARK: 3. 获取热门产品：
    class func GetHotPro(dic: NSDictionary,completedHandler:((NSURLResponse?,NSData?,NSError?)->Void)?){
        self.readAndRequest(RequestType.ReadAndRequest, saveKey: "GetHotPro", subURL: "CrmGetHotPro", httpMethod: self.httpGet, jsonObj: dic, completedHandle: completedHandler)
    }
    
    //MARK: 4. 获取一级产品分类
    class func GetProLeave1(dic: NSDictionary,completedHandler:((NSURLResponse?,NSData?,NSError?)->Void)?){
        self.readAndRequest(RequestType.ReadAndRequest, saveKey: "GetProLeave1", subURL: "CrmGetProLeave1", httpMethod: self.httpGet, jsonObj: dic, completedHandle: completedHandler)
    }
    
    //MARK: 5. 获取二级产品分类
    class func GetProLeave2(dic: NSDictionary,completedHandler:((NSURLResponse?,NSData?,NSError?)->Void)?){
        
        let catId = dic.objectForKey("pId") as! Int //jfpId unresolved why?
        self.readAndRequest(RequestType.ReadAndRequest, saveKey: "GetProLeave2-\(catId)", subURL: "CrmGetProLeave2", httpMethod: self.httpGet, jsonObj: dic, completedHandle: completedHandler)
    }
    
    //MARK: 6. 产品查询
    class func SelectPro(dic: NSDictionary,completedHandler:((NSURLResponse?,NSData?,NSError?)->Void)?){
        
        self.readAndRequest(RequestType.Request, saveKey: "", subURL: "CrmSelectPro", httpMethod: self.httpGet, jsonObj: dic, completedHandle: completedHandler)
    }
    
    class func GetProductsByCatId(dic: NSDictionary,completedHandler:((NSURLResponse?,NSData?,NSError?)->Void)?){
        
        let catId = dic.objectForKey("catId") as! Int
        self.readAndRequest(RequestType.ReadAndRequest, saveKey: "GetProductsByCatId-\(catId)", subURL: "CrmSelectPro", httpMethod: self.httpGet, jsonObj: dic, completedHandle: completedHandler)
    }
    
   
}




































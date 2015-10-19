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
    
    
    class func AsynchronousRequest(var subUrlStr: String, httpMethod:String, jsonObj: NSDictionary?, completedHandler:((NSURLResponse?,NSData?,NSError?)->Void)?){
        
        //prepare parameters
        var para: NSMutableString
        let mutableJsonObj = NSMutableDictionary()
        if let mJsonObj = jsonObj{
            mutableJsonObj.setDictionary(mJsonObj as [NSObject : AnyObject])
        }
        let eqNo = UIDevice.currentDevice().identifierForVendor!.UUIDString
        mutableJsonObj.setValue(eqNo, forKey: "eqNo")
//        if let mJsonObj: AnyObject = jsonObj{
            if httpMethod == httpGet{
                para = NSMutableString(string: "")
                mutableJsonObj.enumerateKeysAndObjectsUsingBlock({ (key, obj, stop) -> Void in
                    if para.length == 0{
                        para.appendString("\(key)=\(obj)")
                    }else{
                        para.appendString("&\(key)=\(obj)")
                    }
                })
                subUrlStr = "\(subUrlStr)?\(para)"
            }
//        }
        
        //urlRequest init
        var url = fullUrlStr(subUrlStr)
//        url = url.stringByReplacingOccurrencesOfString(" ", withString: "")
        
        url = url.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())!// url.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)!
        debugPrint("\(url)")
        let urlRequest = NSMutableURLRequest(URL: NSURL(string: url)!, cachePolicy: NSURLRequestCachePolicy.ReloadIgnoringLocalCacheData, timeoutInterval: 5.0)
        urlRequest.HTTPMethod = httpMethod
        if httpMethod == httpPost{
            if let mJson = jsonObj{
                let jsonData: NSData?
                jsonData = try? NSJSONSerialization.dataWithJSONObject(mJson, options: NSJSONWritingOptions())
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
        
        debugPrint("发送 \(urlRequest)\n HTTPBody=\(urlRequest.HTTPBody)")
        let queue = NSOperationQueue()
        NSURLConnection.sendAsynchronousRequest(urlRequest, queue: queue) { (response, data, connectionError) -> Void in
            
            if connectionError == nil{
                debugPrint("返回 \(response)\n data.length=\(data!.length) \nconnectionError=\(connectionError)")
            }else{
                debugPrint("返回失败 connectionError=\(connectionError)")
            }
        
//            var errorPointer: NSErrorPointer = nil
//            var json:AnyObject? = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.AllowFragments, error: errorPointer)
//            println("返回 json=\(json)")

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
                debugPrint("本地读到数据：\(saveKey) =\(mLocalData)")
                completedHandle?(nil,mLocalData,nil)
            }else{
                debugPrint("本地未读到数据：\(saveKey)")
            }
            
        case RequestType.Request:
            
            self.AsynchronousRequest(subURL, httpMethod: httpMethod, jsonObj: jsonObj, completedHandler: completedHandle)
            
        case RequestType.ReadAndRequest:
            
            var bhandle = false
            let localData = NSUserDefaults.standardUserDefaults().objectForKey(saveKey) as? NSData
            if let mLocalData = localData{
                //                debugPrintln("本地读到数据：\(saveKey) = \(mLocalData)")

                
                let json = try? NSJSONSerialization.JSONObjectWithData(mLocalData, options: NSJSONReadingOptions.AllowFragments)
               
                debugPrint("本地读到数据：\(saveKey) =\(json!)")
                
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
                debugPrint("本地读到数据：\(saveKey) data.length=\(mLocalData.length)")
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
            completedHandler?(nil,data,nil)
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
            if WebApi.isHttpSucceed(response, data: data, error: error){
                debugPrint("文件下载成功:\(fileURL)")
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    data!.writeToFile(fileSavedName, atomically: true)
                })
            }
            completedHandler?(response,data,error)
        }
    }
    
    /*
    //获取文件，保存到本地  已在本地则，handler 可能在当前线程跑，也可能在子线程跑
    +(void)GetFile:(NSString*)urlString completionHandler:(CompletionHandlerBlock) handler
    {
    
    if (urlString == nil) {
    GGLog(@"文件路径为nil");
    handler(nil,nil,nil);
    return;
    }
    if (![urlString isKindOfClass:[NSString class]]){
    GGLog(@"文件路径有错：urlString=%@",urlString);
    handler(nil,nil,nil);
    return;
    }
    NSURL * url = [NSURL URLWithString:urlString];
    NSFileManager * fileManager = [[NSFileManager alloc] init];
    //本地对应的文件名称
    NSString *fileSavedName = [NSTemporaryDirectory() stringByAppendingPathComponent:[url path]];
    //如果图片存在，则直接导入
    if ([fileManager fileExistsAtPath:fileSavedName]) {
    //        GGLog(@"%@ %@",@"从本地导入",fileSavedName);
    NSData * data = [NSData dataWithContentsOfFile:fileSavedName];
    
    handler(nil,data,nil);
    return;
    }
    
    //不存在则创建目录
    NSString *fileSavedPath = [fileSavedName stringByDeletingLastPathComponent];
    NSError * error = nil;
    BOOL bCreate = [fileManager createDirectoryAtPath:fileSavedPath withIntermediateDirectories:YES attributes:nil error:&error];
    if (bCreate) {
    
    //下载文件
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:url];
    NSOperationQueue * queue = [[NSOperationQueue alloc] init];
    
    GGLog(@"开始下载文件：%@",url);
    [NSURLConnection sendAsynchronousRequest:urlRequest queue:queue completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
    dispatch_async(dispatch_get_main_queue(), ^{
    if ([ServerAPIUtils isHttpSucceed:response Data:data Error:connectionError]){
    GGLog(@"下载文件成功：length=%d, %@",data.length, url);
    [data writeToFile:fileSavedName atomically:YES];
    }
    handler(response,data,connectionError);
    
    });
    }];
    
    
    }else{
    GGLog(@"创建目录失败:%@",fileSavedPath);
    handler(nil,nil,error);
    }
    
    }

    */
    
    //MARK: 1. 发送设备编码
    class func SendEquipCode(dic: NSDictionary,completedHandler:((NSURLResponse?,NSData?,NSError?)->Void)?){
        self.readAndRequest(RequestType.Request, saveKey: "SendEquipCode", subURL: "CrmSendEquipCode", httpMethod: self.httpGet, jsonObj: dic, completedHandle: completedHandler)
    }
    
    //MARK: 2. 登录校验
    class func Login(dic: NSDictionary,completedHandler:((NSURLResponse?,NSData?,NSError?)->Void)?){
//        self.readAndRequest(RequestType.Request, saveKey: "Login", subURL: "CrmLogin", httpMethod: self.httpGet, jsonObj: dic, completedHandle: completedHandler)
        
        let path = NSBundle.mainBundle().pathForResource("userinfo", ofType: "json")
        let userinfoData = NSData(contentsOfFile: path!)
        completedHandler?(nil,userinfoData,nil)
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
    
    //MARK: 8. 根据产品ID获取产品的图片地址和视频地址
    
    class func GetProFilesByID(dic: NSDictionary,completedHandler:((NSURLResponse?,NSData?,NSError?)->Void)?){
        
        self.readAndRequest(RequestType.ReadAndRequest, saveKey: "GetProFilesByID", subURL: "CrmGetProFilesByID", httpMethod: self.httpGet, jsonObj: dic, completedHandle: completedHandler)
    }

    
    //MARK: 14. 提交购物车及照片
    class func SendShopData(dic: NSDictionary,completedHandler:((NSURLResponse?,NSData?,NSError?)->Void)?){
        //TODO: 模拟提交订单 to be remove
//        let dic = [jfstatus: 1]
//        let data = try! NSJSONSerialization.dataWithJSONObject(dic, options: NSJSONWritingOptions())
//        completedHandler?(nil,data,nil)
//        return
        
        self.readAndRequest(RequestType.Request, saveKey: "", subURL: "CrmSendShopData", httpMethod: self.httpPost, jsonObj: dic, completedHandle: completedHandler)
    }

   //MARK: 15. 提交图片
    class func UpFile(image: UIImage, completedHandler:((NSURLResponse?,NSData?,NSError?)->Void)?){
        
        //TODO: 模拟提交图片成功 to be remove
//        let formatter = NSDateFormatter()
//        formatter.dateFormat = "yyyyMMddHHmmss"
//        let dic = [jfurl:"http://test.com/IMG_\(formatter.stringFromDate(NSDate())).png"]
//        let data = try! NSJSONSerialization.dataWithJSONObject(dic, options: NSJSONWritingOptions())
//        completedHandler?(nil,data,nil)
//        return
        
        
        let eqNo = (UIDevice.currentDevice().identifierForVendor?.UUIDString)!
        
        let url = ("http://btl.zhiwx.com/api/crmUpFile.ashx?\(jfeqNo)=\(eqNo)&\(jfuid)=\(UserInfo.defaultUserInfo().uid!)")
//        self.fullUrlStr("crmUpFile.ashx?\(jfeqNo)=\(eqNo)&\(jfuid)=\(UserInfo.defaultUserInfo().uid!)")
        
        let urlRequest = NSMutableURLRequest(URL: NSURL(string: url)!,cachePolicy: NSURLRequestCachePolicy.ReloadIgnoringCacheData, timeoutInterval: 5)
        urlRequest.HTTPMethod = self.httpPost
        urlRequest.setValue("Raw", forHTTPHeaderField: "Content-Type")
        urlRequest.HTTPBody = UIImageJPEGRepresentation(image, 1)
        
        let queue = NSOperationQueue()
        NSURLConnection.sendAsynchronousRequest(urlRequest, queue: queue) { (response, data, error) -> Void in
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                completedHandler?(response,data,error)
            })
        }
    }
}




































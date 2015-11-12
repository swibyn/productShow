//
//  WebApi.swift
//  ProductShow
//
//  Created by s on 15/9/9.
//  Copyright (c) 2015年 gaozgao. All rights reserved.
//

import UIKit

class WebApi: NSObject {
    static let baseUrlStr = "http://btl.zhiwx.com/crmapi/"
    static let httpPost = "POST"
    static let httpGet = "GET"
    
    //MARK: 基础方法    
    class func isHttpSucceed(response: NSURLResponse?, data: NSData?, error: NSError?) -> Bool{
        let bOK = (error == nil) && (data?.length > 0) && (response == nil || (response as? NSHTTPURLResponse)!.statusCode == 200)
        return bOK
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
    
    
    //MARK: 同步数据
    class func readOrGetUrl(fullUrlStr:String,completedHandle:((NSURLResponse?,NSData?,NSError?)->Void)?) {
        let fullUrlStrURLAllowed = fullUrlStr.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())!
        let data = localData(fullUrlStrURLAllowed)
        var bHandled = false
        if data != nil{
            bHandled = true
            completedHandle?(nil,data!,nil)
        }
        
        GetUrl(fullUrlStrURLAllowed) { (response, data, error) -> Void in
            if !bHandled{
                completedHandle?(response, data, error)
            }
        }
    }
    
    class func localData(fullUrlStr: String)->NSData?{
       return  NSUserDefaults.standardUserDefaults().valueForKey(fullUrlStr) as? NSData
    }
    
    class func GetUrl(fullUrlStr: String, completedHandler:((NSURLResponse?,NSData?,NSError?)->Void)?){
        debugPrint("GET: \(fullUrlStr)")
        
        let fullUrlStrURLAllowed = fullUrlStr.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())!
        let urlRequest = NSMutableURLRequest(URL: NSURL(string: fullUrlStrURLAllowed)!, cachePolicy: NSURLRequestCachePolicy.ReloadIgnoringLocalCacheData, timeoutInterval: 5.0)
        urlRequest.HTTPMethod = httpGet
        
        let queue = NSOperationQueue()
        NSURLConnection.sendAsynchronousRequest(urlRequest, queue: queue) { (response, data, error) -> Void in
            if self.isHttpSucceed(response, data: data, error: error){
                NSUserDefaults.standardUserDefaults().setValue(data, forKey: fullUrlStr)
            }

            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                completedHandler?(response,data,error)
            })
        }
    }
    
    class func PostToUrl(fullUrlStr: String, jsonObj: NSDictionary?, completedHandler:((NSURLResponse?,NSData?,NSError?)->Void)?){
        
        debugPrint("POST: \(fullUrlStr)", "json=\(jsonObj?.toString("=", elementSeparator: "&"))", separator: "\n")
        //创建请求
        let urlRequest = NSMutableURLRequest(URL: NSURL(string: fullUrlStr)!, cachePolicy: NSURLRequestCachePolicy.ReloadIgnoringLocalCacheData, timeoutInterval: 5.0)
        urlRequest.HTTPMethod = httpPost
        
        //增加设备编号
        let paraDic = NSMutableDictionary()
        if let json = jsonObj{
            paraDic.setDictionary(json as [NSObject : AnyObject])
        }
        paraDic.setObject(eqNo(), forKey: jfeqNo)
        
        //设置body
        let paraData = try! NSJSONSerialization.dataWithJSONObject(paraDic, options: NSJSONWritingOptions())
        urlRequest.HTTPBody = paraData
        
        //发送请求
        let queue = NSOperationQueue()
        NSURLConnection.sendAsynchronousRequest(urlRequest, queue: queue) { (response, data, connectionError) -> Void in
            
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                completedHandler?(response,data,connectionError)
            })
        }
    }
    
    
    class func eqNo()->String {
        return UIDevice.currentDevice().advertisingIdentifier.UUIDString
    }
    
    class func uid()->Int {
        let uid = UserInfo.defaultUserInfo().firstUser?.uid
        return uid!
    }
    
    //MARK: 1. 发送设备编码
    class func SendEquipCode(dic: NSDictionary?,completedHandler:((NSURLResponse?,NSData?,NSError?)->Void)?){
        let eqName = UIDevice.currentDevice().name
        readOrGetUrl(baseUrlStr.stringByAppendingString("CrmSendEquipCode?eqNo=\(eqNo())&eqName=\(eqName)"), completedHandle: completedHandler)
    }
    
    //MARK: 2. 登录校验
    class func Login(dic: NSDictionary,completedHandler:((NSURLResponse?,NSData?,NSError?)->Void)?){
        let paraStr = dic.toString("=", elementSeparator: "&")
        GetUrl(baseUrlStr.stringByAppendingString("CrmLogin?eqNo=\(eqNo())&\(paraStr)"), completedHandler: completedHandler)
    }
    
    //MARK: 3. 获取热门产品：
    class func GetHotPro(dic: NSDictionary?,completedHandler:((NSURLResponse?,NSData?,NSError?)->Void)?){
        self.readOrGetUrl(baseUrlStr.stringByAppendingString("CrmGetHotPro?eqNo=\(eqNo())"), completedHandle: completedHandler)
    }
    
    //MARK: 4. 获取一级产品分类
    class func GetProLeave1(dic: NSDictionary?,completedHandler:((NSURLResponse?,NSData?,NSError?)->Void)?){
        self.readOrGetUrl(baseUrlStr.stringByAppendingString("CrmGetProLeave1?eqNo=\(eqNo())"), completedHandle: completedHandler)
    }
    
    //MARK: 5. 获取二级产品分类
    class func GetProLeave2(dic: NSDictionary,completedHandler:((NSURLResponse?,NSData?,NSError?)->Void)?){
        let paraStr = dic.toString("=", elementSeparator: "&")
        self.readOrGetUrl(baseUrlStr.stringByAppendingString("CrmGetProLeave2?eqNo=\(eqNo())&\(paraStr)"), completedHandle: completedHandler)
    }
    
    //MARK: 6. 产品查询
    class func SelectPro(dic: NSDictionary?,completedHandler:((NSURLResponse?,NSData?,NSError?)->Void)?){
        let paraStr = dic?.toString("=", elementSeparator: "&")
        self.readOrGetUrl(baseUrlStr.stringByAppendingString("CrmSelectPro?eqNo=\(eqNo())&\(paraStr!)"), completedHandle: completedHandler)
    }
    
    class func GetProductsByCatId(dic: NSDictionary,completedHandler:((NSURLResponse?,NSData?,NSError?)->Void)?){
        let paraStr = dic.toString("=", elementSeparator: "&")
        self.readOrGetUrl(baseUrlStr.stringByAppendingString("CrmSelectPro?eqNo=\(eqNo())&\(paraStr)"), completedHandle: completedHandler)
    }
    
    //http://btl.zhiwx.com/crmapi/CrmSelectProByValue?eqNo=S0001&query=xqm
    class func SelectProByValue(dic: NSDictionary?,completedHandler:((NSURLResponse?,NSData?,NSError?)->Void)?){
        let paraStr =  dic?.toString("=", elementSeparator: "&")
        self.readOrGetUrl(baseUrlStr.stringByAppendingString("CrmSelectProByValue?eqNo=\(eqNo())&\(paraStr!)"), completedHandle: completedHandler)
    }

    
    //MARK: 8. 根据产品ID获取产品的图片地址和视频地址
    class func GetProFilesByID(dic: NSDictionary?,completedHandler:((NSURLResponse?,NSData?,NSError?)->Void)?){
        let paraStr =  dic?.toString("=", elementSeparator: "&")
        self.readOrGetUrl(baseUrlStr.stringByAppendingString("CrmGetProFilesByID?eqNo=\(eqNo())&\(paraStr!)"), completedHandle: completedHandler)
    }
    
    //MARK: 9. 获取客户数据
    class func GetCustomer(dic: NSDictionary,completedHandler:((NSURLResponse?,NSData?,NSError?)->Void)?){
        self.readOrGetUrl(baseUrlStr.stringByAppendingString("CrmGetCustomer?eqNo=\(eqNo())&saleId=\(uid())"), completedHandle: completedHandler)
    }
    
    //MARK: 10. 获取客户关注产品
    class func GetCustomerCare(dic: NSDictionary,completedHandler:((NSURLResponse?,NSData?,NSError?)->Void)?){
        let paraStr =  dic.toString("=", elementSeparator: "&")

        self.readOrGetUrl(baseUrlStr.stringByAppendingString("CrmGetCustomerCare?eqNo=\(eqNo())&\(paraStr)"), completedHandle: completedHandler)
    }

    //MARK: 11. 获取用户数据
    class func GetUserInfo(dic: NSDictionary,completedHandler:((NSURLResponse?,NSData?,NSError?)->Void)?){
        self.readOrGetUrl(baseUrlStr.stringByAppendingString("CrmGetUserInfo?eqNo=\(eqNo())&uid=\(uid())"), completedHandle: completedHandler)
    }
    
    //MARK: 12. 获取系统公告
    class func GetNotice(dic: NSDictionary?,completedHandler:((NSURLResponse?,NSData?,NSError?)->Void)?){
        self.readOrGetUrl(baseUrlStr.stringByAppendingString("CrmGetNotice?eqNo=\(eqNo())"), completedHandle: completedHandler)
    }
    
    //MARK: 13. 写拜访日志
    class func WriteCustLog(dic: NSDictionary,completedHandler:((NSURLResponse?,NSData?,NSError?)->Void)?){
        PostToUrl("\(baseUrlStr)CrmWriteCustLog", jsonObj: dic, completedHandler: completedHandler)
    }
    
    //MARK: 14. 提交购物车及照片
    class func SendShopData(dic: NSDictionary,completedHandler:((NSURLResponse?,NSData?,NSError?)->Void)?){        PostToUrl("\(baseUrlStr)CrmSendShopData", jsonObj: dic, completedHandler: completedHandler)
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
    class func GetWorkLog(canReadLocal: Bool, dic: NSDictionary,completedHandler:((NSURLResponse?,NSData?,NSError?)->Void)?){
        let dicStr = dic.toString("=", elementSeparator: "&")
        let fullUrlStr = baseUrlStr.stringByAppendingString("CrmGetWorkLog?eqNo=\(eqNo())&\(dicStr)")
        if canReadLocal{
            self.readOrGetUrl(fullUrlStr, completedHandle: completedHandler)
        }else{
            self.GetUrl(fullUrlStr, completedHandler: completedHandler)
            
        }
    }
    
    //MARK: 17. 修改密码
    class func ChangePwd(dic: NSDictionary,completedHandler:((NSURLResponse?,NSData?,NSError?)->Void)?){
        PostToUrl("\(baseUrlStr)CrmChangePwd", jsonObj: dic, completedHandler: completedHandler)
    }
    
    //MARK: 获取所有图片和视频
    class func GetAllProFiles(completedHandler:((NSURLResponse?,NSData?,NSError?)->Void)?){
        let fullUrlStr = baseUrlStr.stringByAppendingString("GetAllProFiles?eqNo=\(eqNo())")
        self.GetUrl(fullUrlStr, completedHandler: completedHandler)
    }

    //MARK: 获取所有api
    class func GetAllUrl(completedHandler:((NSURLResponse?,NSData?,NSError?)->Void)?){
        let fullUrlStr = baseUrlStr.stringByAppendingString("CrmGetAllUrl?eqNo=\(eqNo())&uid=\(uid())")
        self.GetUrl(fullUrlStr, completedHandler: completedHandler)
    }
    
    
}




































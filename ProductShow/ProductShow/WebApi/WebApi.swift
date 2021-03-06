//
//  WebApi.swift
//  ProductShow
//
//  Created by s on 15/9/9.
//  Copyright (c) 2015年 gaozgao. All rights reserved.
//

import UIKit
// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l < r
  case (nil, _?):
    return true
  default:
    return false
  }
}

// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func > <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l > r
  default:
    return rhs < lhs
  }
}


/*

*/

class WebApi: NSObject {
    static let baseUrlStr = "http://btl.zhiwx.com/crmapi/"
    static let httpPost = "POST"
    static let httpGet = "GET"
    
    //MARK: 基础方法    
    class func isHttpSucceed(_ response: URLResponse?, data: Data?, error: Error?) -> Bool{
        let bOK = (error == nil) && (data?.count > 0) && (response == nil || (response as? HTTPURLResponse)!.statusCode == 200)
        return bOK
    }
    
    class func fileExistsForRemote(_ remotefile: String?)->Bool{
        let remotefileURL = remotefile?.URL
        let localfileOpt = remotefileURL?.localFile
        if let localfile = localfileOpt{
            return FileManager().fileExists(atPath: localfile)
        }
        return false
    }
    
    class func GetFile(_ remotefile: String?, completedHandler:((URLResponse?,Data?,NSError?)->Void)?){
        
        let remotefileURL = remotefile?.URL
        let localfileOpt = remotefileURL?.localFile
        if localfileOpt == nil{
            let error = NSError(domain: NSURLErrorDomain, code: NSURLErrorBadURL, userInfo: [NSLocalizedDescriptionKey:"unsupported URL"])
            completedHandler?(nil,nil,error)
            return
        }
        
        let localfile = localfileOpt!
        let fileManager = FileManager()
        
        //如果文件存在，则直接导入
        if fileManager.fileExists(atPath: localfile){
            let data = try? Data(contentsOf: URL(fileURLWithPath: localfile))
            DispatchQueue.main.async(execute: { () -> Void in
                completedHandler?(nil,data,nil)
            })
            return
        }
        
        //不存在则创建目录
        let fileSavedPath = NSString(string: localfile).deletingLastPathComponent
        
        try! fileManager.createDirectory(atPath: fileSavedPath, withIntermediateDirectories: true, attributes: nil)
       
        let urlRequest = URLRequest(url: remotefileURL! as URL)
        let queue = OperationQueue()
        debugPrint("开始下载文件:\(remotefileURL!.absoluteString)")
        NSURLConnection.sendAsynchronousRequest(urlRequest, queue: queue) { (response, data, error) -> Void in
            
            DispatchQueue.main.async(execute: { () -> Void in
                if WebApi.isHttpSucceed(response, data: data, error: error as NSError?){
                    debugPrint("文件下载成功:\(remotefileURL!.absoluteString)")
                    try? data!.write(to: URL(fileURLWithPath: localfile), options: [.atomic])
                }else{
                    debugPrint("文件下载失败:\(remotefileURL!.absoluteString)")
                }
                completedHandler?(response,data,error as NSError?)
            })
            
        }
    }
    
    
    //MARK: 读取并请求
    class func readOrGetUrl(_ fullUrlStr:String?,completedHandle:((URLResponse?,Data?,NSError?)->Void)?) {
        let data = localData(fullUrlStr)
        var bHandled = false
        if data != nil{
            bHandled = true
            completedHandle?(nil,data!,nil)
        }
        
        GetUrl(fullUrlStr) { (response, data, error) -> Void in
            if !bHandled{
                completedHandle?(response, data, error)
            }
        }
    }
    
    class func localData(_ fullUrlStr: String?)->Data?{
       let savekey = fullUrlStr?.URL?.absoluteString
        if savekey != nil{
            return  UserDefaults.standard.object(forKey: savekey!) as? Data
        }
        return nil
    }
    
    class func GetUrl(_ fullUrlStr: String?, completedHandler:((URLResponse?,Data?,NSError?)->Void)?){
        let url = fullUrlStr?.URL
        if url == nil{
            let error = NSError(domain: NSURLErrorDomain, code: NSURLErrorBadURL, userInfo: [NSLocalizedDescriptionKey:"unsupported URL"])
            completedHandler?(nil,nil,error)
        }
        debugPrint("GET: \(url!.absoluteString)")
        
        let urlRequest = NSMutableURLRequest(url: url! as URL, cachePolicy: NSURLRequest.CachePolicy.reloadIgnoringLocalCacheData, timeoutInterval: 5.0)
        urlRequest.httpMethod = httpGet
        
        let queue = OperationQueue()
        NSURLConnection.sendAsynchronousRequest(urlRequest as URLRequest, queue: queue) { (response, data, error) -> Void in
            if self.isHttpSucceed(response, data: data, error: error as NSError?){
                UserDefaults.standard.set(data, forKey: url!.absoluteString)
            }

            DispatchQueue.main.async(execute: { () -> Void in
                completedHandler?(response,data,error as NSError?)
            })
        }
    }
    
    class func PostToUrl(_ fullUrlStr: String, jsonObj: NSDictionary?, completedHandler:((URLResponse?,Data?,NSError?)->Void)?){
        
        debugPrint("POST: \(fullUrlStr)", "json=\(jsonObj?.toString("=", elementSeparator: "&"))", separator: "\n")
        //创建请求
        let urlRequest = NSMutableURLRequest(url: URL(string: fullUrlStr)!, cachePolicy: NSURLRequest.CachePolicy.reloadIgnoringLocalCacheData, timeoutInterval: 5.0)
        urlRequest.httpMethod = httpPost
        
        //增加设备编号
        let paraDic = NSMutableDictionary()
        if let json = jsonObj{
            paraDic.setDictionary(json as! [AnyHashable: Any])
        }
        paraDic.setObject(eqNo(), forKey: jfeqNo as NSCopying)
        
        //设置body
        let paraData = try! JSONSerialization.data(withJSONObject: paraDic, options: JSONSerialization.WritingOptions())
        urlRequest.httpBody = paraData
        
        //发送请求
        let queue = OperationQueue()
        NSURLConnection.sendAsynchronousRequest(urlRequest as URLRequest, queue: queue) { (response, data, connectionError) -> Void in
            
            DispatchQueue.main.async(execute: { () -> Void in
                completedHandler?(response,data,connectionError as NSError?)
            })
        }
    }
    
    
    class func eqNo()->String {
        return UIDevice.current.advertisingIdentifier.uuidString
    }
    
    class func uid()->Int {
        let uid = UserInfo.defaultUserInfo().firstUser?.uid
        return uid!
    }
    
    //MARK: 1. 发送设备编码
    class func SendEquipCode(_ dic: NSDictionary?,completedHandler:((URLResponse?,Data?,NSError?)->Void)?){
        let eqName = UIDevice.current.name
        readOrGetUrl("\(baseUrlStr)CrmSendEquipCode?eqNo=\(eqNo())&eqName=\(eqName)", completedHandle: completedHandler)
    }
    
    //MARK: 2. 登录校验
    class func Login(_ dic: NSDictionary,completedHandler:((URLResponse?,Data?,NSError?)->Void)?){
        let paraStr = dic.toString("=", elementSeparator: "&")
        GetUrl("\(baseUrlStr)CrmLogin?eqNo=\(eqNo())&\(paraStr)", completedHandler: completedHandler)
    }
    
    //MARK: 3. 获取热门产品：
    class func GetHotPro(_ dic: NSDictionary?,completedHandler:((URLResponse?,Data?,NSError?)->Void)?){
        readOrGetUrl("\(baseUrlStr)CrmGetHotPro?eqNo=\(eqNo())", completedHandle: completedHandler)
    }
    
    //MARK: 4. 获取一级产品分类
    class func GetProLeave1(_ dic: NSDictionary?,completedHandler:((URLResponse?,Data?,NSError?)->Void)?){
        readOrGetUrl("\(baseUrlStr)CrmGetProLeave1?eqNo=\(eqNo())", completedHandle: completedHandler)
    }
    
    //MARK: 5. 获取二级产品分类
    class func GetProLeave2(_ dic: NSDictionary,completedHandler:((URLResponse?,Data?,NSError?)->Void)?){
        let paraStr = dic.toString("=", elementSeparator: "&")
        readOrGetUrl("\(baseUrlStr)CrmGetProLeave2?eqNo=\(eqNo())&\(paraStr)", completedHandle: completedHandler)
    }
    
    //MARK: 6. 产品查询
    class func SelectPro(_ dic: NSDictionary?,completedHandler:((URLResponse?,Data?,NSError?)->Void)?){
        let paraStr = dic?.toString("=", elementSeparator: "&")
        readOrGetUrl("\(baseUrlStr)CrmSelectPro?eqNo=\(eqNo())&\(paraStr!)", completedHandle: completedHandler)
    }
    
    class func GetProductsByCatId(_ dic: NSDictionary,completedHandler:((URLResponse?,Data?,NSError?)->Void)?){
        let paraStr = dic.toString("=", elementSeparator: "&")
        readOrGetUrl("\(baseUrlStr)CrmSelectPro?eqNo=\(eqNo())&\(paraStr)", completedHandle: completedHandler)
    }
    
    //http://btl.zhiwx.com/crmapi/CrmSelectProByValue?eqNo=S0001&query=xqm
    class func SelectProByValue(_ dic: NSDictionary?,completedHandler:((URLResponse?,Data?,NSError?)->Void)?){
        let paraStr =  dic?.toString("=", elementSeparator: "&")
        GetUrl("\(baseUrlStr)CrmSelectProByValue?eqNo=\(eqNo())&\(paraStr!)", completedHandler: completedHandler)
    }

    
    //MARK: 8. 根据产品ID获取产品的图片地址和视频地址
    class func GetProFilesByID(_ dic: NSDictionary?,completedHandler:((URLResponse?,Data?,NSError?)->Void)?){
        let paraStr =  dic?.toString("=", elementSeparator: "&")
        readOrGetUrl("\(baseUrlStr)CrmGetProFilesByID?eqNo=\(eqNo())&\(paraStr!)", completedHandle: completedHandler)
    }
    
    //MARK: 9. 获取客户数据
    class func GetCustomer(_ dic: NSDictionary,completedHandler:((URLResponse?,Data?,NSError?)->Void)?){
        readOrGetUrl("\(baseUrlStr)CrmGetCustomer?eqNo=\(eqNo())&saleId=\(uid())", completedHandle: completedHandler)
    }
    
    //MARK: 10. 获取客户关注产品
    class func GetCustomerCare(_ dic: NSDictionary,completedHandler:((URLResponse?,Data?,NSError?)->Void)?){
        let paraStr =  dic.toString("=", elementSeparator: "&")

        readOrGetUrl("\(baseUrlStr)CrmGetCustomerCare?eqNo=\(eqNo())&\(paraStr)", completedHandle: completedHandler)
    }

    //MARK: 11. 获取用户数据
    class func GetUserInfo(_ dic: NSDictionary,completedHandler:((URLResponse?,Data?,NSError?)->Void)?){
        readOrGetUrl("\(baseUrlStr)CrmGetUserInfo?eqNo=\(eqNo())&uid=\(uid())", completedHandle: completedHandler)
    }
    
    //MARK: 12. 获取系统公告
    class func GetNotice(_ dic: NSDictionary?,completedHandler:((URLResponse?,Data?,NSError?)->Void)?){
        readOrGetUrl("\(baseUrlStr)CrmGetNotice?eqNo=\(eqNo())", completedHandle: completedHandler)
    }
    
    //MARK: 13. 写拜访日志
    class func WriteCustLog(_ dic: NSDictionary,completedHandler:((URLResponse?,Data?,NSError?)->Void)?){
        PostToUrl("\(baseUrlStr)CrmWriteCustLog", jsonObj: dic, completedHandler: completedHandler)
    }
    
    //MARK: 14. 提交购物车及照片
    class func SendShopData(_ dic: NSDictionary,completedHandler:((URLResponse?,Data?,NSError?)->Void)?){
        PostToUrl("\(baseUrlStr)CrmSendShopData", jsonObj: dic, completedHandler: completedHandler)
    }

    //MARK: 15. 上传文件接口
    class func UpFile(_ localPath: String?, completedHandler:((URLResponse?,Data?,Error?)->Void)?){
        
        let eqNo = UIDevice.current.advertisingIdentifier.uuidString
        let uid = UserInfo.defaultUserInfo().firstUser?.uid
        let url = ("http://btl.zhiwx.com/api/crmUpFile.ashx?\(jfeqNo)=\(eqNo)&\(jfuid)=\(uid!)")
        let imageData = PhotoUtil.getPhotoData(localPath)// NSData(contentsOfFile: localPath)
        if imageData?.count > 0{
            debugPrint("开始上传文件:\(localPath)")
            UploadFile().uploadFileWithURL(URL(string: url)!, data: imageData!) { (response, data, error) -> Void in
                let urlresponse = response as? HTTPURLResponse
                if urlresponse?.statusCode == 200{
                    debugPrint("文件上传成功:\(localPath)")
                }else{
                    debugPrint("文件上传失败:\(localPath)")
                }
                DispatchQueue.main.async(execute: { () -> Void in
                    completedHandler?(response,data,error)
                })
            }
        }else{
            debugPrint("没有找到要上传的文件:\(localPath)")
        }

    }
//    class func UpFile1(imageData: NSData, completedHandler:((NSURLResponse?,NSData?,NSError?)->Void)?){
//        
//        let eqNo = UIDevice.currentDevice().advertisingIdentifier.UUIDString
//        let uid = UserInfo.defaultUserInfo().firstUser?.uid
//        let url = ("http://btl.zhiwx.com/api/crmUpFile.ashx?\(jfeqNo)=\(eqNo)&\(jfuid)=\(uid!)")
//        UploadFile().uploadFileWithURL(NSURL(string: url)!, data: imageData) { (response, data, error) -> Void in
//            dispatch_async(dispatch_get_main_queue(), { () -> Void in
//                completedHandler?(response,data,error)
//            })
//        }
//    }
    
    //MARK: 16. 获取拜访日志
    class func GetWorkLog(_ canReadLocal: Bool, dic: NSDictionary,completedHandler:((URLResponse?,Data?,NSError?)->Void)?){
        let dicStr = dic.toString("=", elementSeparator: "&")
        let fullUrlStr = "\(baseUrlStr)CrmGetWorkLog?eqNo=\(eqNo())&\(dicStr)"
        if canReadLocal{
            readOrGetUrl(fullUrlStr, completedHandle: completedHandler)
        }else{
            GetUrl(fullUrlStr, completedHandler: completedHandler)
        }
    }
    
    //MARK: 17. 修改密码
    class func ChangePwd(_ dic: NSDictionary,completedHandler:((URLResponse?,Data?,NSError?)->Void)?){
        PostToUrl("\(baseUrlStr)CrmChangePwd", jsonObj: dic, completedHandler: completedHandler)
    }
    
    //MARK: 18.获取所有图片和视频
    class func GetAllProFiles(_ completedHandler:((URLResponse?,Data?,NSError?)->Void)?){
        GetUrl("\(baseUrlStr)GetAllProFiles?eqNo=\(eqNo())", completedHandler: completedHandler)
    }

    //MARK: 获取所有api
    class func GetAllUrl(_ completedHandler:((URLResponse?,Data?,NSError?)->Void)?){
        let fullUrlStr = "\(baseUrlStr)CrmGetAllUrl?eqNo=\(eqNo())&uid=\(uid())"
        GetUrl(fullUrlStr, completedHandler: completedHandler)
    }
      
}




































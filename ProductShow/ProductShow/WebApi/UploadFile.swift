//
//  UploadFile.swift
//  ProductShow
//
//  Created by s on 15/12/9.
//  Copyright © 2015年 zhiwx. All rights reserved.
//

import Foundation

//MARK: UploadFile
class UploadFile {
    // 拼接字符串
    let boundaryStr = "--"  // 分隔字符串
    let randomIDStr = "----------thinkyouitcast---------"  // 本次上传标示字符串
    let uploadID = "uploadFile"  // 上传(php)脚本中，接收文件字段
    
    fileprivate func topStringWithMimeType(_ mimeType: String, uploadFile: String)->String{
        let strM = NSMutableString()
        strM.append("\(boundaryStr)\(randomIDStr)\n")
        strM.append("Content-Disposition: form-data; name=\"\(uploadID)\"; filename=\"\(uploadFile)\"\n")
        strM.append("Content-Type: \(mimeType)\n\n")
        return strM as String
    }
    
    fileprivate func bottomString()->String{
        let strM = NSMutableString()
        strM.append("\(boundaryStr)\(randomIDStr)\n")
        strM.append("Content-Disposition: form-data; name=\"submit\"\n\n")
        strM.append("Submit\n")
        strM.append("\(boundaryStr)\(randomIDStr)--\n")
        return strM as String
    }
    
    //MARK: 上传文件
    func uploadFileWithURL(_ url: URL, data: Data, completionHandler handler:@escaping ((_ response: URLResponse?, _ data: Data?, _ connetionError: Error?) -> Void)){
        // 1> 数据体
        let topStr: NSString = self.topStringWithMimeType("image/png", uploadFile: "头像1.png") as NSString
        let bottomStr: NSString = self.bottomString() as NSString
        
        var dataM = Data()
        dataM.append(topStr.data(using: String.Encoding.utf8.rawValue)!)
        dataM.append(data)
        dataM.append(bottomStr.data(using: String.Encoding.utf8.rawValue)!)
        
        // 1.Request
//        let request = NSMutableURLRequest(url: url, cachePolicy: NSURLRequest.CachePolicy.useProtocolCachePolicy, timeoutInterval: 2.0)
        var request = URLRequest(url: url, cachePolicy: NSURLRequest.CachePolicy.useProtocolCachePolicy, timeoutInterval: 2.0)
        
        
        // dataM出了作用域就会被释放,因此不用copy
        request.httpBody = dataM as Data
        
        // 2> 设置Request的头属性
        request.httpMethod = "POST"
        
        // 3> 设置Content-Length
        let strLength = "\(data.count)"
        request.setValue(strLength, forHTTPHeaderField: "Content-Length")
        
        // 4> 设置Content-Type
        let strContentType = "multipart/form-data; boundary=\(randomIDStr)"
        request.setValue(strContentType, forHTTPHeaderField: "Content-Type")
        
        // 3> 连接服务器发送请求
        let task = URLSession.shared.dataTask(with: request, completionHandler: { (data, response, error) -> Void in
 
            handler(response, data, error)
        }) 
        
        task.resume()
        
        //@available(iOS, introduced=5.0, deprecated=9.0, message="Use [NSURLSession dataTaskWithRequest:completionHandler:] (see NSURLSession.h")
        //        NSURLConnection.sendAsynchronousRequest(<#T##request: NSURLRequest##NSURLRequest#>, queue: <#T##NSOperationQueue#>, completionHandler: <#T##(NSURLResponse?, NSData?, NSError?) -> Void#>)
    }
}

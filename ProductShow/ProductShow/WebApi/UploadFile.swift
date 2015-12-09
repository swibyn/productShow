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
    
    private func topStringWithMimeType(mimeType: String, uploadFile: String)->String{
        let strM = NSMutableString()
        strM.appendString("\(boundaryStr)\(randomIDStr)\n")
        strM.appendString("Content-Disposition: form-data; name=\"\(uploadID)\"; filename=\"\(uploadFile)\"\n")
        strM.appendString("Content-Type: \(mimeType)\n\n")
        return strM as String
    }
    
    private func bottomString()->String{
        let strM = NSMutableString()
        strM.appendString("\(boundaryStr)\(randomIDStr)\n")
        strM.appendString("Content-Disposition: form-data; name=\"submit\"\n\n")
        strM.appendString("Submit\n")
        strM.appendString("\(boundaryStr)\(randomIDStr)--\n")
        return strM as String
    }
    
    //MARK: 上传文件
    func uploadFileWithURL(url: NSURL, data: NSData, completionHandler handler:((response: NSURLResponse?, data: NSData?, connetionError: NSError?) -> Void)){
        // 1> 数据体
        let topStr: NSString = self.topStringWithMimeType("image/png", uploadFile: "头像1.png")
        let bottomStr: NSString = self.bottomString()
        
        let dataM = NSMutableData()
        dataM.appendData(topStr.dataUsingEncoding(NSUTF8StringEncoding)!)
        dataM.appendData(data)
        dataM.appendData(bottomStr.dataUsingEncoding(NSUTF8StringEncoding)!)
        
        // 1.Request
        let request = NSMutableURLRequest(URL: url, cachePolicy: NSURLRequestCachePolicy.UseProtocolCachePolicy, timeoutInterval: 2.0)
        
        // dataM出了作用域就会被释放,因此不用copy
        request.HTTPBody = dataM
        
        // 2> 设置Request的头属性
        request.HTTPMethod = "POST"
        
        // 3> 设置Content-Length
        let strLength = "\(data.length)"
        request.setValue(strLength, forHTTPHeaderField: "Content-Length")
        
        // 4> 设置Content-Type
        let strContentType = "multipart/form-data; boundary=\(randomIDStr)"
        request.setValue(strContentType, forHTTPHeaderField: "Content-Type")
        
        // 3> 连接服务器发送请求
        let task = NSURLSession.sharedSession().dataTaskWithRequest(request) { (data, response, error) -> Void in

            handler(response: response, data: data, connetionError: error)
        }
        
        task.resume()
        
        //@available(iOS, introduced=5.0, deprecated=9.0, message="Use [NSURLSession dataTaskWithRequest:completionHandler:] (see NSURLSession.h")
        //        NSURLConnection.sendAsynchronousRequest(<#T##request: NSURLRequest##NSURLRequest#>, queue: <#T##NSOperationQueue#>, completionHandler: <#T##(NSURLResponse?, NSData?, NSError?) -> Void#>)
    }
}
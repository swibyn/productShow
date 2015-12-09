//
//  ProductFiles.swift
//  ProductShow
//
//  Created by s on 15/10/19.
//  Copyright © 2015年 gaozgao. All rights reserved.
//

import Foundation
/*
返回的json数据包：
    {
    "status": 1,
    "message": "",
    "data": {
    "dt": [
    {
    "fileId": 54,
    "proId": 23,
    "fileType": 1,
    "filePath": "http://btl.zhiwx.com/data/1/images/201510/14442933768829621.png",
    "thumbPath": " http://btl.zhiwx.com//data/1/images_thumb/201510/14442933768829621.png "
    },
    {
    "fileId": 55,
    "proId": 23,
    "fileType": 2,
    "filePath": "http://www.xx.com/A.mpeg",
    "filePath": ""
    },
    {
    "fileId": 56,
    "proId": 23,
    "fileType": 2,
    "filePath": "ftp://202.101.11.11/B.mpeg",
    "filePath": ""
    }
    ]
    },
    "data1": null,
    "data2": null,
    "lenght": 0,
    "islastpage": 1,
    "tag": ""
}
参数说明：
参数	说明
state	状态：执行成功时返回1，执行失败时返回0
msg	消息提示，执行成功时返回空字符串，执行失败时返回错误信息
fileId	文件ID
proId	产品ID
fileType	文件类型，1=图片地址，2=视频地址
filePath	文件url，注意：图片地址在应用时需手动补充前缀
thumbPath	缩略图地址，当类型为视频地址时该栏位为空
其他参数	无用
*/

let ProductFileTypeImage = 1
let ProductFileTypeVideo = 2

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
    
    var thumbPath: String?{
        return _proFileDic?.objectForKey(jfthumbPath) as? String
    }
    
}

class ProductFiles: ReturnDic {
    
    private var files: NSArray?{
        return data_dt
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

    var imageFileArray: Array<ProductFile>{
        var imageFileArray = [ProductFile]()
        for index in 0..<filesCount {
            let productFile = productFileAtIndex(index)
            if productFile != nil && productFile!.fileType == ProductFileTypeImage{
                imageFileArray.append(productFile!)
            }
        }
        
        return imageFileArray
        
    }
    

}











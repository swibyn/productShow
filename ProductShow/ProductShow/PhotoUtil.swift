//
//  PhotoUtil.swift
//  ProductShow
//
//  Created by s on 15/10/17.
//  Copyright © 2015年 gaozgao. All rights reserved.
//

import UIKit

class PhotoUtil: NSObject {
    
    class func savePhoto(image: UIImage, var forName name: String?)->String?{
        if name == nil{
            let formatter = NSDateFormatter()
            formatter.dateFormat = "yyyyMMdd_HHmmss"
            name = "IMG_\(formatter.stringFromDate(NSDate())).png"
        }
        
        let imgData = UIImageJPEGRepresentation(image,1)
        let bsave = imgData?.writeToFile(NSTemporaryDirectory().stringByAppendingString(name!), atomically: true)
        return (bsave ?? false) ? name : nil
    }
    
    class func getPhoto(fileName: String)->UIImage?{
        let filepath = NSTemporaryDirectory().stringByAppendingString(fileName)
        let imgDataOpt = NSData(contentsOfFile: filepath)
        if let imgData = imgDataOpt{
            let image = UIImage(data: imgData)
            return image
        }
        return nil
    }
    
    class func deletePhoto(fileName: String){
        let filePath = NSTemporaryDirectory().stringByAppendingString(fileName)
        try! NSFileManager.defaultManager().removeItemAtPath(filePath)
    }
    
    class func deletePhotosInOrder(order: Order){
        order.imagePaths?.enumerateObjectsUsingBlock({ (imagePathDic, index, stop) -> Void in
            let localPath = imagePathDic.objectForKey(OrderSaveKey.localpath) as? String
            deletePhoto(localPath!)
            
        })
    }

}

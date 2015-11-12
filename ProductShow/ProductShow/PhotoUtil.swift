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
            let time = NSDate().toString("yyyyMMdd_HHmmss")
            name = "IMG_\(time).png"
        }
        
//        let size = image
        let imgData = UIImageJPEGRepresentation(image,1/4)
        let bsave = imgData?.writeToFile(NSTemporaryDirectory().stringByAppendingString(name!), atomically: true)
        return (bsave ?? false) ? name : nil
    }
    
    class func getPhotoData(fileName: String)->NSData?{
        let filepath = NSTemporaryDirectory().stringByAppendingString(fileName)
        return NSData(contentsOfFile: filepath)
    }
    
    class func deletePhoto(fileName: String){
        let filePath = NSTemporaryDirectory().stringByAppendingString(fileName)
        try? NSFileManager.defaultManager().removeItemAtPath(filePath)
    }
    
    class func deletePhotosInOrder(order: Order){
        order.imagePaths?.enumerateObjectsUsingBlock({ (imagePathDic, index, stop) -> Void in
            let localPath = imagePathDic.objectForKey(OrderSaveKey.localpath) as? String
            deletePhoto(localPath!)
            
        })
    }
    
    class func getMB(image: UIImage)->CGFloat{
        let data = UIImageJPEGRepresentation(image, 1)
        let nMB = CGFloat(data!.length)/(1024*1024)
        return nMB
    }
    
    class func ImageJPEGRepresentation(image: UIImage, lessThenN: CGFloat)-> UIImage {
        let nMB = self.getMB(image)
        let newData = UIImageJPEGRepresentation(image, lessThenN/nMB)
        let newImage = UIImage(data: newData!)
        return newImage!
    }

}

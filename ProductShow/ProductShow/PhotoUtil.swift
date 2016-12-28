//
//  PhotoUtil.swift
//  ProductShow
//
//  Created by s on 15/10/17.
//  Copyright © 2015年 gaozgao. All rights reserved.
//

import UIKit

class PhotoUtil: NSObject {
    static let compressionQuality: CGFloat = 0.5
    
    class func savePhoto(_ image: UIImage, forName name: String?)->String?{
        var name = name
        if name == nil{
            let time = Date().toString("yyyyMMdd_HHmmss")
            name = "IMG_\(time).png"
        }
        
        let imgData = UIImageJPEGRepresentation(image, compressionQuality)
        let savedPath = "\(NSTemporaryDirectory())\(name!)"
         let bsave = (try? imgData?.write(to: URL(fileURLWithPath: savedPath), options: [.atomic])) != nil
        return (bsave ?? false) ? savedPath : nil
    }
    
    class func getPhotoData(_ fileName: String?)->Data?{
//        let filepath = NSTemporaryDirectory().stringByAppendingString(fileName)
        if fileName != nil{
            return (try? Data(contentsOf: URL(fileURLWithPath: fileName!)))
        }
        return nil
    }
    
    //删除订单图片
    class func removeImagesInOrder(_ order: Order?){
        if order == nil { return }
        let imagePathCount = order?.imagePaths?.count
        if imagePathCount != nil && imagePathCount! > 0{
            for index in 0..<imagePathCount!{
                let imagePath = order?.imagePathAtIndex(index)
                let localPath = imagePath?.localpath
                if localPath == nil {continue}
                let _ = try? FileManager.default.removeItem(atPath: localPath!)
            }
        }
    }

    
//    class func getMB(image: UIImage)->CGFloat{
//        let data = UIImageJPEGRepresentation(image, 1)
//        let nMB = CGFloat(data!.length)/(1024*1024)
//        return nMB
//    }

}

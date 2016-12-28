//
//  UIImagesCollectionViewContrller.swift
//  ProductShow
//
//  Created by s on 15/10/19.
//  Copyright © 2015年 gaozgao. All rights reserved.
//

import UIKit
import MediaPlayer
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


class UIImagesCollectionViewContrller: UICollectionViewController {
    
    var product: Product!
    
    var productFiles = ProductFiles()
    var player: MPMoviePlayerViewController?
    
    override func viewDidLoad() {
        self.GetProFiles()
    }
    
    //MARK: function
    func GetProFiles(){
        if (product != nil){
            WebApi.GetProFilesByID([jfproId: product.proId!]) { (response, data, error) -> Void in
                if WebApi.isHttpSucceed(response, data: data, error: error){
                    
                    let json = (try! JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers)) as! NSDictionary
                    
                    self.productFiles.returnDic = json
                    self.collectionView?.reloadData()
                }
            }
        }
    }
    
    //MARK: 获取视频的缩略图
    
    func setThumb(_ fileName: String, imageView: UIImageView){
        
        let asset = AVURLAsset(url: URL(fileURLWithPath: fileName))
        let generateImg = AVAssetImageGenerator(asset: asset)
        let time = CMTimeMake(1, 65)
        let refImg = try? generateImg.copyCGImage(at: time, actualTime: nil)
        if let img = refImg{
            imageView.image = UIImage(cgImage: img)
        }else{
            imageView.image = nil
        }
    }
    
    //MARK: - UICollectionViewDataSource
    override func numberOfSections(in collectionView: UICollectionView) -> Int{
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int{
        return productFiles.filesCount
        
    }
    
    // The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
   
    override  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell{
        let productFile = productFiles.productFileAtIndex(indexPath.row)!
        let cellid = productFile.fileType == ProductFileTypeImage ? "cellImage" : "cellVideo"
        
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellid, for: indexPath)
        cell.tag = indexPath.row
        let imageView = cell.viewWithTag(100) as! UIImageView
        imageView.image = UIImage(named: "商品默认图片96X96")
        WebApi.GetFile(productFile.filePath) { (response, data, error) -> Void in
            if WebApi.isHttpSucceed(response, data: data, error: error){
                if productFile.fileType! == ProductFileTypeImage{
                    if data?.count > 0{
                        imageView.image = UIImage(data: data!)
                    }
                }else{
                    let localfile = productFile.filePath?.URL?.localFile
                    if localfile != nil{
                        self.setThumb(localfile!, imageView: imageView)
                    }
                }
            }
        }
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath){
        let productFile = productFiles.productFileAtIndex(indexPath.row)
        if productFile?.fileType == ProductFileTypeImage{
            let imageCollectionVC2 = UIImagesCollectionViewContrller2.newInstance()
            imageCollectionVC2.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
            imageCollectionVC2.modalPresentationStyle = UIModalPresentationStyle.fullScreen
            imageCollectionVC2.productFiles = productFiles
            imageCollectionVC2.initcellIndex = indexPath.row
            self.present(imageCollectionVC2, animated: false, completion: nil)
        }else{
            //先下载后播放
            let filePath =  productFile?.filePath?.URL?.localFile // WebApi.localFileName(productFile?.filePath)
            if filePath == nil{
                let alertView = UIAlertView(title: nil, message: "Error URL:\(productFile!.filePath!)", delegate: nil, cancelButtonTitle: "OK")
                alertView.show()
                return
            }
            if FileManager.default.fileExists(atPath: filePath!){
                let player = MPMoviePlayerViewController(contentURL: URL(fileURLWithPath: filePath!))
                self.presentMoviePlayerViewControllerAnimated(player)
                
            }else{
                let alertView = UIAlertView(title: "File downloading", message: productFile?.filePath, delegate: nil, cancelButtonTitle: "OK")
                alertView.show()
            }
            //直接远程播放
//            let player = MPMoviePlayerViewController(contentURL: NSURL(string: (productFile?.filePath)!))
//            self.presentMoviePlayerViewControllerAnimated(player)
        }
    }
    
    //MARK: - UICollectionViewDelegateFlowLayout
    //定义每个UICollectionView 的大小
    
    func collectionView(_ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAtIndexPath indexPath: IndexPath) -> CGSize{
            let width = ((self.collectionView?.bounds.size.width)! - 120)/4
            
            return  CGSize(width: width,height: width)
            
    }

}














//
//  UIImagesCollectionViewContrller.swift
//  ProductShow
//
//  Created by s on 15/10/19.
//  Copyright © 2015年 gaozgao. All rights reserved.
//

import UIKit
import MediaPlayer

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
                    
                    let json = (try! NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.AllowFragments)) as! NSDictionary
                    debugPrint("\(self) \(__FUNCTION__) json=\(json)")
                    
                    self.productFiles.returnDic = json
                    self.collectionView?.reloadData()
                }
            }
        }
    }
    
    //MARK: 获取视频的缩略图
    
    func setThumb(fileName: String, imageView: UIImageView){
        
        let asset = AVURLAsset(URL: NSURL(fileURLWithPath: fileName))
        let generateImg = AVAssetImageGenerator(asset: asset)
        let time = CMTimeMake(1, 65)
        let refImg = try? generateImg.copyCGImageAtTime(time, actualTime: nil)
        if let img = refImg{
            imageView.image = UIImage(CGImage: img)
        }else{
            imageView.image = nil
        }
    }
    
    //MARK: - UICollectionViewDataSource
    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int{
        return 1
    }
    
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int{
        return productFiles.filesCount
        
    }
    
    // The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
   
    override  func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell{
        let productFile = productFiles.productFileAtIndex(indexPath.row)!
        let cellid = productFile.fileType == ProductFileTypeImage ? "cellImage" : "cellVideo"
        
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(cellid, forIndexPath: indexPath)
        cell.tag = indexPath.row
        let imageView = cell.viewWithTag(100) as! UIImageView
        imageView.image = UIImage(named: "商品默认图片96X96")
        WebApi.GetFile(productFile.filePath) { (response, data, error) -> Void in
            if WebApi.isHttpSucceed(response, data: data, error: error){
                if productFile.fileType! == ProductFileTypeImage{
                    if data?.length > 0{
                        imageView.image = UIImage(data: data!)
                    }
                }else{
//                    imageView.image = UIImage(named: "video")
                    self.setThumb(WebApi.localFileName(productFile.filePath)!, imageView: imageView)
                }
                
            }
//            else{
//                let alertView = UIAlertView(title: "Hint", message: "File download failed\n\(productFile.filePath!)", delegate: nil, cancelButtonTitle: "OK")
//                alertView.show()
//            }
        }
        return cell
    }
    
    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath){
        let productFile = productFiles.productFileAtIndex(indexPath.row)
        if productFile?.fileType == ProductFileTypeImage{
            let imageCollectionVC2 = UIImagesCollectionViewContrller2.newInstance()
            imageCollectionVC2.modalTransitionStyle = UIModalTransitionStyle.CrossDissolve
            imageCollectionVC2.modalPresentationStyle = UIModalPresentationStyle.FullScreen
            imageCollectionVC2.productFiles = productFiles
            imageCollectionVC2.initcellIndex = indexPath.row
//            self.navigationController?.pushViewController(imageCollectionVC2, animated: false)
            self.presentViewController(imageCollectionVC2, animated: false, completion: nil)
        }else{
            //先下载后播放
            let filePath = WebApi.localFileName(productFile?.filePath)
            if NSFileManager.defaultManager().fileExistsAtPath(filePath!){
                let player = MPMoviePlayerViewController(contentURL: NSURL(fileURLWithPath: filePath!))
                self.presentMoviePlayerViewControllerAnimated(player)
                
            }else{
                let alertView = UIAlertView(title: "Hint", message: "File downloading, please wait for a moment", delegate: nil, cancelButtonTitle: "OK")
                alertView.show()
            }
            //直接远程播放
//            let player = MPMoviePlayerViewController(contentURL: NSURL(string: (productFile?.filePath)!))
//            self.presentMoviePlayerViewControllerAnimated(player)
        }
    }
    
    //MARK: - UICollectionViewDelegateFlowLayout
    //定义每个UICollectionView 的大小
    
    func collectionView(collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize{
            let width = ((self.collectionView?.bounds.size.width)! - 120)/4
            
            return  CGSize(width: width,height: width)
            
    }

}














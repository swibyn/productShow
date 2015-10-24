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
    
//    var productDic: NSDictionary?
    var product: Product!
    
    var productFiles = ProductFiles()
    var player: MPMoviePlayerViewController?
    
    override func viewDidLoad() {
       
        WebApi.GetProFilesByID([jfproId: product.proId!]) { (response, data, error) -> Void in
            
            if WebApi.isHttpSucceed(response, data: data, error: error){
                
                let json = (try! NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.AllowFragments)) as! NSDictionary
                debugPrint("\(self) \(__FUNCTION__) json=\(json)")
                
                self.productFiles.returnDic = json
                self.collectionView?.reloadData()
            }else{
                
                debugPrint("\(self) \(__FUNCTION__) error=\(error)")
            }
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
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("cell", forIndexPath: indexPath)
        cell.tag = indexPath.row
        let imageView = cell.viewWithTag(100) as! UIImageView
        imageView.image = UIImage(named: "商品默认图片96X96")
        let productFile = productFiles.productFileAtIndex(indexPath.row)!
        WebApi.GetFile(productFile.filePath) { (response, data, error) -> Void in
            if WebApi.isHttpSucceed(response, data: data, error: error){
                if productFile.fileType! == ProductFileTypeImage{
                    if data?.length > 0{
                        imageView.image = UIImage(data: data!)
                    }
                }else{
                    imageView.image = UIImage(named: "video")
                }
                
            }else{
                let alertView = UIAlertView(title: "Hint", message: "File download failed\n\(productFile.filePath)", delegate: nil, cancelButtonTitle: "OK")
                alertView.show()
            }
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
//            let size = self.collectionView?.bounds.size
            return  CGSize(width: 200,height: 200)
            
    }
    // MARK: 视频播放
//    func playVideo(fileName: String){
//        let player = MPMoviePlayerViewController(contentURL: NSURL(string: fileName))
//        self.presentMoviePlayerViewControllerAnimated(player)
//        
//    }

    // MARK: - Navigation
//    override func shouldPerformSegueWithIdentifier(identifier: String, sender: AnyObject?) -> Bool {
//        return false
//        let rowSelected = (sender as! UIView).tag
//        let productFile = productFiles.productFileAtIndex(rowSelected)
//        
//        let fileType = productFile?.fileType
//        if fileType == 1{
//            return true
//        }else{
//            self.playVideo((productFile?.filePath)!)
//            
////            let fileName = "http://sm.domob.cn/ugc/151397.mp4"
////            self.playVideo(fileName)
//            return false
//        }
//    }
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
//    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
//        // Get the new view controller using segue.destinationViewController.
//        // Pass the selected object to the new view controller.
//        let rowSelected = (sender as! UIView).tag
//        let destVc = segue.destinationViewController
//        destVc.setValue(productFiles, forKey: "productFiles")
//        destVc.setValue(rowSelected, forKey: "initcellIndex")
//        
//    }

}














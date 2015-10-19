//
//  UIImagesCollectionViewContrller.swift
//  ProductShow
//
//  Created by s on 15/10/19.
//  Copyright © 2015年 gaozgao. All rights reserved.
//

import UIKit

class UIImagesCollectionViewContrller: UICollectionViewController {
    
//    var productDic: NSDictionary?
    var product: Product!
    var productFiles = ProductFiles()
    
    override func viewDidLoad() {
       
        WebApi.GetProFilesByID([jfproId: product.proId!]) { (response, data, error) -> Void in
            
            if WebApi.isHttpSucceed(response, data: data, error: error){
                
                let json = (try! NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.AllowFragments)) as! NSDictionary
                debugPrint("\(self) \(__FUNCTION__) json=\(json)")
                
                self.productFiles.filesDic = json
                self.collectionView?.reloadData()
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
        WebApi.GetFile(productFiles.productFileAtIndex(indexPath.row)!.filePath) { (response, data, error) -> Void in
            
            if data?.length > 0{
                imageView.image = UIImage(data: data!)
            }
        }
        return cell
    }
    
    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
        
    }
    
    //MARK: - UICollectionViewDelegateFlowLayout
    //定义每个UICollectionView 的大小
    
    func collectionView(collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize{
//            let size = self.collectionView?.bounds.size
            return  CGSize(width: 200,height: 200)
            
    }
    
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        let rowSelected = (sender as! UIView).tag
        let destVc = segue.destinationViewController
        destVc.setValue(productFiles, forKey: "productFiles")
        destVc.setValue(rowSelected, forKey: "initcellIndex")
        
    }

}














//
//  UIImagesCollectionViewContrller.swift
//  ProductShow
//
//  Created by s on 15/10/19.
//  Copyright © 2015年 gaozgao. All rights reserved.
//

import UIKit

class UIImagesCollectionViewContrller2: UICollectionViewController {
    
//    var productDic: NSDictionary?
//    var product: Product!
    var productFiles: ProductFiles!// = ProductFiles()
    var initcellIndex = 0
    
    override func viewWillAppear(animated: Bool) {
        
        debugPrint("\(self) \(__FUNCTION__)")
//        self.collectionView?.selectItemAtIndexPath(NSIndexPath(forRow: initcellIndex, inSection: 0), animated: true, scrollPosition: UICollectionViewScrollPosition.Top)
        let indexPath = NSIndexPath(forRow: initcellIndex, inSection: 0)
        self.collectionView?.scrollToItemAtIndexPath(indexPath, atScrollPosition: UICollectionViewScrollPosition.CenteredHorizontally, animated: false)
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
        let imageView = cell.viewWithTag(100) as! UIImageView
        WebApi.GetFile(productFiles.productFileAtIndex(indexPath.row)!.filePath) { (response, data, error) -> Void in
            
            if data?.length > 0{
                imageView.image = UIImage(data: data!)
            }
        }
        return cell
    }
    
    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        self.navigationController?.popViewControllerAnimated(true)
        self.dismissViewControllerAnimated(true, completion: nil)
        
    }
    
    //MARK: - UICollectionViewDelegateFlowLayout
    //定义每个UICollectionView 的大小
    
    func collectionView(collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize{
            let size = self.collectionView?.bounds.size
            return size!
            
    }
    
    
    
    

    

}

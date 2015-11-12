//
//  UIImagesCollectionViewContrller.swift
//  ProductShow
//
//  Created by s on 15/10/19.
//  Copyright © 2015年 gaozgao. All rights reserved.
//

import UIKit

class UIImagesCollectionViewContrller2: UICollectionViewController {
    
    
    var product: Product?
    var productFiles: ProductFiles?
    var initcellIndex = 0
    
    //MARK: 初始化一个实例
    static func newInstance()->UIImagesCollectionViewContrller2{
        
        let aInstance = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("UIImagesCollectionViewContrller2") as! UIImagesCollectionViewContrller2
        return aInstance
    }

    //MARK: view life
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        GetProFilesIfNeed()
        let indexPath = NSIndexPath(forRow: initcellIndex, inSection: 0)
        self.collectionView?.scrollToItemAtIndexPath(indexPath, atScrollPosition: UICollectionViewScrollPosition.CenteredHorizontally, animated: false)
    }
    
    //MARK: function
    func GetProFilesIfNeed(){
        if (productFiles == nil)&&(product != nil){
            let proId = product?.proId
            WebApi.GetProFilesByID([jfproId: proId!]) { (response, data, error) -> Void in
                
                if WebApi.isHttpSucceed(response, data: data, error: error){
                    
                    let json = (try! NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableContainers)) as! NSDictionary
                    
                    self.productFiles = ProductFiles(returnDic: json)
                    self.collectionView?.reloadData()
                }
            }
        }
    }
    func ImageViewTapActive(sender: AnyObject) {
        debugPrint("\(__FUNCTION__)")
        self.dismissViewControllerAnimated(true, completion: nil)
    }

    
    //MARK: - UICollectionViewDataSource
    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int{
        return 1
    }
    
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int{
        return productFiles?.filesCount ?? 0
        
    }
    
    // The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
   
    override  func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell{
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("cell", forIndexPath: indexPath)
        let imageView = cell.viewWithTag(100) as! UIImageView
   
        imageView.image = UIImage(named: "430X430产品详细默认图")
        imageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: Selector("ImageViewTapActive:")))
        let productFile = productFiles?.productFileAtIndex(indexPath.row)!
        WebApi.GetFile(productFile?.filePath) { (response, data, error) -> Void in
            if productFile!.fileType! == ProductFileTypeImage{
                if data?.length > 0{
                    imageView.image = UIImage(data: data!)
                    
                }
            }else{
                imageView.image = UIImage(named: "video")
            }
        }

        return cell
    }
    
    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        self.navigationController?.popViewControllerAnimated(true)
        self.dismissViewControllerAnimated(false, completion: nil)
        
    }
    
    //MARK: - UICollectionViewDelegateFlowLayout
    //定义每个UICollectionView 的大小
    
    func collectionView(collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize{
            let size = self.collectionView?.bounds.size
//            debugPrint("size=\(size)")
            let productFile = productFiles?.productFileAtIndex(indexPath.row)!
            if productFile!.fileType == ProductFileTypeImage{
                return size!
            }else{
                return CGSize(width: 0, height: 0)
            }
    }
    
    
    override func viewForZoomingInScrollView(scrollView: UIScrollView) -> UIView? {
        
        let imageview = scrollView.viewWithTag(100) as! UIImageView
        return imageview
    }
}













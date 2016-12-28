//
//  UIImagesCollectionViewContrller.swift
//  ProductShow
//
//  Created by s on 15/10/19.
//  Copyright © 2015年 gaozgao. All rights reserved.
//

import UIKit
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


class UIImagesCollectionViewContrller2: UICollectionViewController {
    
    
//    var product: Product?
    var productFiles: ProductFiles?
    var initcellIndex = 0
    
    //MARK: 初始化一个实例
    static func newInstance()->UIImagesCollectionViewContrller2{
        
        let aInstance = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "UIImagesCollectionViewContrller2") as! UIImagesCollectionViewContrller2
        return aInstance
    }

    //MARK: view life
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
//        GetProFilesIfNeed()
        let indexPath = IndexPath(row: initcellIndex, section: 0)
        self.collectionView?.scrollToItem(at: indexPath, at: UICollectionViewScrollPosition.centeredHorizontally, animated: false)
    }
    
    //MARK: function
//    func GetProFilesIfNeed(){
//        if (productFiles == nil)&&(product != nil){
//            let proId = product?.proId
//            WebApi.GetProFilesByID([jfproId: proId!]) { (response, data, error) -> Void in
//                
//                if WebApi.isHttpSucceed(response, data: data, error: error){
//                    
//                    let json = (try! NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableContainers)) as! NSDictionary
//                    
//                    self.productFiles = ProductFiles(returnDic: json)
//                    self.collectionView?.reloadData()
//                }
//            }
//        }
//    }
    func ImageViewTapActive(_ sender: AnyObject) {
        debugPrint("\(#function)")
        self.dismiss(animated: true, completion: nil)
    }

    
    //MARK: - UICollectionViewDataSource
    override func numberOfSections(in collectionView: UICollectionView) -> Int{
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int{
        return productFiles?.filesCount ?? 0
        
    }
    
    // The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
   
    override  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell{
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
        let imageView = cell.viewWithTag(100) as! UIImageView
   
        imageView.image = UIImage(named: "430X430产品详细默认图")
        imageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(UIImagesCollectionViewContrller2.ImageViewTapActive(_:))))
        let productFile = productFiles?.productFileAtIndex(indexPath.row)!
        WebApi.GetFile(productFile?.filePath) { (response, data, error) -> Void in
            if productFile!.fileType! == ProductFileTypeImage{
                if data?.count > 0{
                    imageView.image = UIImage(data: data!)
                    
                }
            }else{
                imageView.image = UIImage(named: "video")
            }
        }

        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.navigationController?.popViewController(animated: true)
        self.dismiss(animated: false, completion: nil)
        
    }
    
    //MARK: - UICollectionViewDelegateFlowLayout
    //定义每个UICollectionView 的大小
    
    func collectionView(_ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAtIndexPath indexPath: IndexPath) -> CGSize{
            let size = self.collectionView?.bounds.size
//            debugPrint("size=\(size)")
            let productFile = productFiles?.productFileAtIndex(indexPath.row)!
            if productFile!.fileType == ProductFileTypeImage{
                return size!
            }else{
                return CGSize(width: 0, height: 0)
            }
    }
    
    
    override func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        
        let imageview = scrollView.viewWithTag(100) as! UIImageView
        return imageview
    }
}













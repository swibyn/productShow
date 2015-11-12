//
//  ProductViewController.swift
//  ProductShow
//
//  Created by s on 15/10/28.
//  Copyright © 2015年 zhiwx. All rights reserved.
//

import UIKit

class ProductViewController: UIViewController {
    
    var product : Product?
    
    //MARK: 初始化一个实例
    static func newInstance()->ProductViewController{
        return UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("ProductViewController") as! ProductViewController
        
    }

    //MARK: @IB
    @IBOutlet var productNameLabel: UILabel!
    @IBOutlet var productImageView: UIImageView!
    @IBOutlet var productSizeLabel: UILabel!
    @IBOutlet var productRemarkTextView: UITextView!
    
    @IBAction func addToCartButtonAction(sender: AnyObject) {
        Cart.defaultCart().addProduct(product!.productDic!)
        NSNotificationCenter.defaultCenter().postNotificationName(kProductsInCartChanged, object: self)
        let alertView = UIAlertView(title: "Hint", message: "Add to cart successfully", delegate: nil, cancelButtonTitle: "OK")
        alertView.show()
    }
    
    //MARK: view life
    override func viewDidLoad() {
        
        self.title = "Product Detail"
        
        self.showProductInfo()
        self.imageViewAddTapGesture()
        self.productRemarkTextView.font = UIFont.systemFontOfSize(20)
    }
    
    //MARK: function
    func showProductInfo(){
        self.productNameLabel.text = "  \(product!.proName!)"
        self.productSizeLabel.text = product?.proSize
        self.productRemarkTextView.text = product?.remark
        let imagefile = self.product?.imgUrl
        WebApi.GetFile(imagefile) { (response, data, error) -> Void in
            if WebApi.isHttpSucceed(response, data: data, error: error){
                self.productImageView.image = UIImage(data: data!)
            }
        }
    }
    
    func imageViewAddTapGesture(){
        self.productImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: Selector("imageViewTapAction")))
        
    }
    
    func imageViewTapAction(){
        let proId = product?.proId
        WebApi.GetProFilesByID([jfproId: proId!]) { (response, data, error) -> Void in
            
            if WebApi.isHttpSucceed(response, data: data, error: error){
                
                let json = (try! NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableContainers)) as! NSDictionary
                let productFiles = ProductFiles(returnDic: json)
                if productFiles.filesCount > 0{
                    
                    let imageCollectionVC2 = UIImagesCollectionViewContrller2.newInstance()
                    imageCollectionVC2.modalTransitionStyle = UIModalTransitionStyle.CrossDissolve
                    imageCollectionVC2.modalPresentationStyle = UIModalPresentationStyle.FullScreen
                    imageCollectionVC2.productFiles = productFiles
                    self.presentViewController(imageCollectionVC2, animated: false, completion: nil)
                }else{
                    let alerView = UIAlertView(title: nil, message: productFiles.message, delegate: nil, cancelButtonTitle: "OK")
                    alerView.show()
                    
                }
                
            }else{
            }
        }
    }
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        //
        let destVc = segue.destinationViewController
        destVc.setValue(product, forKey: "product")
        
    }
    
}

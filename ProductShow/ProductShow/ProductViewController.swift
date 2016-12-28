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
        return UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ProductViewController") as! ProductViewController
        
    }

    //MARK: @IB
    @IBOutlet var productNameLabel: UILabel!
    @IBOutlet var productImageView: UIImageView!
    @IBOutlet var productSizeLabel: UILabel!
    @IBOutlet var productRemarkTextView: UITextView!
    
    @IBAction func addToCartButtonAction(_ sender: AnyObject) {
        Cart.defaultCart().addProduct(product)
        NotificationCenter.default.post(name: Notification.Name(rawValue: kProductsInCartChanged), object: self)
        let alertView = UIAlertView(title: "", message: "Add to cart successfully", delegate: nil, cancelButtonTitle: "OK")
        alertView.show()
    }
    
    //MARK: view life
    override func viewDidLoad() {
        
        self.title = "Product Detail"
        
        self.showProductInfo()
        self.imageViewAddTapGesture()
        self.productRemarkTextView.font = UIFont.systemFont(ofSize: 20)
        self.productRemarkTextViewAddTapGesture()
        
        
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
    
    //产品图片增加点击事件
    func imageViewAddTapGesture(){
        self.productImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(ProductViewController.imageViewTapAction)))
        
    }
    
    func imageViewTapAction(){
        let proId = product?.proId
        WebApi.GetProFilesByID([jfproId: proId!,jffileType:1]) { (response, data, error) -> Void in
            
            if WebApi.isHttpSucceed(response, data: data, error: error){
                
                let json = (try! JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers)) as! NSDictionary
                let productFiles = ProductFiles(returnDic: json)
                if productFiles.imageFileArray.count > 0 {
//                if productFiles.filesCount > 0{
                    
                    let imageCollectionVC2 = UIImagesCollectionViewContrller2.newInstance()
                    imageCollectionVC2.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
                    imageCollectionVC2.modalPresentationStyle = UIModalPresentationStyle.fullScreen
                    imageCollectionVC2.productFiles = productFiles
                    self.present(imageCollectionVC2, animated: false, completion: nil)
                }else{
                    let alerView = UIAlertView(title: nil, message: productFiles.message, delegate: nil, cancelButtonTitle: "OK")
                    alerView.show()
                    
                }
                
            }else{
                let alertView = UIAlertView(title: nil, message: "No image file", delegate: nil, cancelButtonTitle: "OK")
                alertView.show()
            }
        }
    }
    
    //简介增加点击事件
    func productRemarkTextViewAddTapGesture(){
        self.productRemarkTextView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(ProductViewController.productRemarkTextViewTapAction(_:))))
    }
    
    func productRemarkTextViewTapAction(_ sender: AnyObject?){
        self.performSegue(withIdentifier: "ProductDetailVC_Detail", sender: sender)
        
    }
    
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        //
        let destVc = segue.destination
        destVc.setValue(product, forKey: "product")
        
    }
    
}

//
//  Cart.swift
//  ProductShow
//
//  Created by s on 15/10/15.
//  Copyright © 2015年 gaozgao. All rights reserved.
//

import Foundation

/*保存格式,字典保存,产品保存在products数组内,并增加amount字段*/
/* 
[
    "products":[
    [
        "amount":1,
        "proId":1,
        "proName":"产品名称",
        "...":"..."
    ],
    [
        "amount":1,
        "proId":2,
        "proName":"产品名称",
        "...":"..."
    ]
]
]
*/




class Cart: NSObject {
    
    fileprivate var cartDic = NSMutableDictionary()
    
    fileprivate static var _defaultCart = Cart()
    class func defaultCart()->Cart {
        return _defaultCart
    }
    
    override init() {
       
        let productsDataOpt = UserDefaults.standard.object(forKey: "Cart") as? Data
        var jsonOpt : AnyObject? = nil
        if let productsData = productsDataOpt{
            jsonOpt = try! JSONSerialization.jsonObject(with: productsData, options: JSONSerialization.ReadingOptions.mutableContainers) as AnyObject?
        }
        
        if let json = jsonOpt{
            cartDic = json as! NSMutableDictionary
        }
    }
    
    func flush(){
        let productsData = try? JSONSerialization.data(withJSONObject: cartDic, options: JSONSerialization.WritingOptions())
        UserDefaults.standard.set(productsData, forKey: "Cart")
    }
    
    //产品列表
    var products: NSMutableArray{
        var _products = cartDic.object(forKey: "products") as? NSMutableArray
        if _products == nil{
            _products = NSMutableArray()
            cartDic.setObject(_products!, forKey: "products" as NSCopying)
        }
        return _products!
    }

    func generateOrder()->Order{
        let order = Order(products: NSArray(array: products))
        return order
    }
    
    //MARK:增加产品
    func addProduct(_ product: Product?){
        let proId = product?.proId
        if proId == nil{return}
        let _product = productByProId(proId!)
        if _product != nil{
            _product?.number += 1
        }else{
            products.add(NSMutableDictionary(dictionary: product!.productDic!))
        }
        flush()
        return
    }
    
    func addProductDic(_ dic: NSDictionary?){
        if dic == nil{return}
        let product = Product(productDic: NSMutableDictionary(dictionary: dic!))
        addProduct(product)
    }
    
    //MARK:删除产品
    func removeProduct(_ product: Product?){
        for (index,obj) in products.enumerated(){
            let productDic = obj as! NSMutableDictionary
            let _product = Product(productDic: productDic)
            if _product.proId == product?.proId{
                products.removeObject(at: index)
                flush()
                break
            }
        }
    }
    
    func removeProductDic(_ dic: NSDictionary?){
        if dic == nil {return}
        removeProduct(Product(productDic: NSMutableDictionary(dictionary: dic!)))
    }
    
    func removeProductByIndex(_ index: Int){
        products.removeObject(at: index)
        flush()
    }

    //MARK:删除所有产品
    func removeProducts(){
        products.removeAllObjects()
        flush()
    }
    
    //MARK:产品数量
    var productsCount: Int{
        return products.count
    }
    
    //索引产品
    func productAtIndex(_ index: Int)->Product?{
        let dic = products.object(at: index) as? NSMutableDictionary
        if dic != nil{
            return Product(productDic: dic!)
        }
        return nil
    }
    
    func productByProId(_ proId: Int)->Product?{
        for index in 0..<productsCount{
            let _product = productAtIndex(index)
            if proId == _product!.proId!{
                return _product
            }
        }
        return nil
    }
    
    //显示标题
    var title: String{
        return "Cart(\(products.count))"
    }
    
    
}

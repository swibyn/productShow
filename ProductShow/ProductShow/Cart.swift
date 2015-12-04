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
    
    private var cartDic = NSMutableDictionary()
    
    private static var _defaultCart = Cart()
    class func defaultCart()->Cart {
        return _defaultCart
    }
    
    override init() {
       
        let productsDataOpt = NSUserDefaults.standardUserDefaults().objectForKey("Cart") as? NSData
        var jsonOpt : AnyObject? = nil
        if let productsData = productsDataOpt{
            jsonOpt = try? NSJSONSerialization.JSONObjectWithData(productsData, options: NSJSONReadingOptions.MutableContainers)
        }
        
        if let json = jsonOpt{
            cartDic = json as! NSMutableDictionary
        }
    }
    
    func flush(){
        let productsData = try? NSJSONSerialization.dataWithJSONObject(cartDic, options: NSJSONWritingOptions())
        NSUserDefaults.standardUserDefaults().setObject(productsData, forKey: "Cart")
    }
    
    //产品列表
    var products: NSMutableArray{
        var _products = cartDic.objectForKey("products") as? NSMutableArray
        if _products == nil{
            _products = NSMutableArray()
            cartDic.setObject(_products!, forKey: "products")
        }
        return _products!
    }

    func generateOrder()->Order{
        let order = Order(products: NSArray(array: products))
        return order
    }
    
    //MARK:增加产品
    func addProduct(product: Product?){
        let proId = product?.proId
        if proId == nil{return}
        let _product = productByProId(proId!)
        if _product != nil{
            _product?.amount++
        }else{
            products.addObject(NSMutableDictionary(dictionary: product!.productDic!))
        }
        flush()
        return
    }
    
    func addProductDic(dic: NSDictionary?){
        if dic == nil{return}
        let product = Product(productDic: NSMutableDictionary(dictionary: dic!))
        addProduct(product)
    }
    
    //MARK:删除产品
    func removeProduct(product: Product?){
        for (index,obj) in products.enumerate(){
            let productDic = obj as! NSMutableDictionary
            let _product = Product(productDic: productDic)
            if _product.proId == product?.proId{
                products.removeObjectAtIndex(index)
                flush()
                break
            }
        }
    }
    
    func removeProductDic(dic: NSDictionary?){
        if dic == nil {return}
        removeProduct(Product(productDic: NSMutableDictionary(dictionary: dic!)))
    }
    
    func removeProductByIndex(index: Int){
        products.removeObjectAtIndex(index)
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
    func productAtIndex(index: Int)->Product?{
        let dic = products.objectAtIndex(index) as? NSMutableDictionary
        if dic != nil{
            return Product(productDic: dic!)
        }
        return nil
    }
    
    func productByProId(proId: Int)->Product?{
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

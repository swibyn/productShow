//
//  OrdersUtil.swift
//  ProductShow
//
//  Created by s on 15/10/16.
//  Copyright © 2015年 gaozgao. All rights reserved.
//

import UIKit

/*保存格式*/
/*
[  //orders
    {  //order
        orderId: "2015-10-16 15:14:00"
        orderTime:"2015-10-16 15:14:00",
        orderName:"用户输入一个辅助记忆的名称",
        imagePaths:[
        {
            localpath:"localpath",
            remotepath:"remotepath"
        },
        {}
        ]
        products:[{},{},{}]
    },
    {
    }
]

*/


class OrderSaveKey {
    static let orderArray = "orderArray"
    static let orderId = "orderId"
    static let orderTime = "orderTime"
    static let orderName = "orderName"
    static let imagePaths = "imagePaths"
    static let localpath = "localpath"
    static let remotepath = "remotepath"
    static let products = "products"
}

class Order: NSObject {
    
    let orderDic : NSMutableDictionary
    
    init(dic: NSMutableDictionary) {
        self.orderDic = dic
        super.init()
    }
    
    override init(){
        let time = NSDate().toString("yyyy-MM-dd HH:mm:ss")
        self.orderDic = NSMutableDictionary(dictionary:
            [OrderSaveKey.orderId: time,
            OrderSaveKey.orderTime: time,
            OrderSaveKey.orderName: "",
            OrderSaveKey.imagePaths: NSMutableArray(),
            OrderSaveKey.products: NSMutableArray()])
        super.init()
    }
    
    func addImagePath(localPath: String)->NSMutableDictionary{
        let imagePaths = orderDic.objectForKey(OrderSaveKey.imagePaths) as! NSMutableArray
        let result = NSMutableDictionary(dictionary: [OrderSaveKey.localpath : localPath])
        imagePaths.addObject(result)
        Orders.defaultOrders().flush()
        return result
    }
    
    var imagePaths: NSArray?{
        return orderDic.objectForKey(OrderSaveKey.imagePaths) as? NSArray
    }
    
    var imgPathsForSubmit: NSArray{
        let _imgPaths = NSMutableArray()
        imagePaths?.enumerateObjectsUsingBlock({ (imagePathObj, Index, stop) -> Void in
            let imagePathDic = imagePathObj as? NSDictionary
            let imgPath = imagePathDic?.objectForKey(OrderSaveKey.remotepath)
            _imgPaths.addObject([jfimgPath: imgPath!])
        })
        return _imgPaths
        
    }
    
    /*
    没有远程路径的就是需要提交的，所以提交完要给返回的对象设置远程路径值
    */
    func firstImageToBeUpload()->NSMutableDictionary?{
        var returnDic: NSMutableDictionary? = nil
        imagePaths?.enumerateObjectsUsingBlock { (imagePathDic, index, stop) -> Void in
            if imagePathDic.objectForKey(OrderSaveKey.remotepath) == nil{
                returnDic = imagePathDic as? NSMutableDictionary
            }
        }
        return returnDic
    }
    
    //设置remotePath
    class func setRemotePath(remoteUrl: String, toDic dic: NSMutableDictionary){
        dic.setObject(remoteUrl, forKey: OrderSaveKey.remotepath)
        Orders.defaultOrders().flush()
    }
    
    //远程路径集
//    func remotePathsDivideBy(divide: String)->String{
//        let remotePaths = NSMutableString()
//        imagePaths?.enumerateObjectsUsingBlock { (imagePathDic, index, stop) -> Void in
//            if remotePaths.length > 0{
//                remotePaths.appendString("|")
//            }
//            let remotepath = (imagePathDic as? NSDictionary)?.objectForKey(OrderSaveKey.remotepath) as! String
//            remotePaths.appendString(remotepath)
//        }
//        return remotePaths as String
//    }
    
    var products: NSArray{
        get{
            return orderDic.objectForKey(OrderSaveKey.products) as! NSArray
        }
        set{
            orderDic.setObject(newValue, forKey: OrderSaveKey.products)
            Orders.defaultOrders().flush()
        }
    }
    
    var productsForSubmit: NSArray{
        let _productsForSubmit = NSMutableArray()
        products.enumerateObjectsUsingBlock { (productObj, index, stop) -> Void in
            let productDic = productObj as? NSMutableDictionary
            let product = Product(productDic: productDic!)
            let proId = product.proId
            let remark = product.additionInfo ?? ""
            let dic = [jfproId: proId!, jfremark: remark]
            _productsForSubmit.addObject(dic)
        }
        return _productsForSubmit
    }
    
    func productAtIndex(index: Int) -> Product?{
        let productDicOpt = products.objectAtIndex(index) as? NSMutableDictionary
        if let productDic = productDicOpt{
            return Product(productDic: productDic)
        }
        return nil
    }
    
//    var proIds: String{
//        let _proIds =  NSMutableString()
//        self.products.enumerateObjectsUsingBlock { (productDic, index, stop) -> Void in
//            if _proIds.length > 0{
//                _proIds.appendString("|")
//            }
//            _proIds.appendString("\(productDic.objectForKey(jfproId) as! Int)")
//        }
//        return _proIds as String
//    }
//    var proIdAndAdditions: String{
//        let _proIdAndAdditions =  NSMutableString()
//        self.products.enumerateObjectsUsingBlock { (productDic, index, stop) -> Void in
//            if _proIdAndAdditions.length > 0{
//                _proIdAndAdditions.appendString("|")
//            }
//            let product = Product(productDic: productDic as! NSMutableDictionary)
//            let proId = product.proId
//            let additionInfo = product.additionInfo ?? ""
//            let additionInfoEncode = additionInfo.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())
//            _proIdAndAdditions.appendString("\(proId!)#\(additionInfoEncode!)")
//        }
//        return _proIdAndAdditions as String
//    }
    
    
    
    var orderId: String?{
        return orderDic.objectForKey(OrderSaveKey.orderId) as? String
    }
    
    var orderTime: String?{
        return orderDic.objectForKey(OrderSaveKey.orderTime) as? String
    }
    
    var orderName: String{
        get{
            let _orderName = orderDic.objectForKey(OrderSaveKey.orderName)
            if _orderName?.length>0{
                return _orderName as! String
            }else if products.count == 1{
                return "(1 product)"
            }else{
                return "(\(products.count) products)"
            }
        }
        set{
            orderDic.setObject(newValue, forKey: OrderSaveKey.orderName)
            Orders.defaultOrders().flush()
        }
    }
    
    func addImage(imgfile:String){
        let imagePaths = orderDic.objectForKey(jfimgPaths) as! NSMutableArray
        imagePaths.addObject([OrderSaveKey.localpath : imgfile])
        imagePaths.addObject([OrderSaveKey.remotepath: imgfile])
    }
    
    
}

class Orders: NSObject {
    
    var _orders = NSMutableArray()
    
    override init() {
        //订单列表
        let oldOrdersDataOpt = NSUserDefaults.standardUserDefaults().objectForKey(OrderSaveKey.orderArray) as? NSData
        var jsonOpt : AnyObject? = nil
        if let oldOrdersData = oldOrdersDataOpt{
            jsonOpt = try? NSJSONSerialization.JSONObjectWithData(oldOrdersData, options: NSJSONReadingOptions.MutableContainers)
        }
        
        if let json = jsonOpt{
            _orders = json as! NSMutableArray
        }
    }
    
    private static var _defaultOrders = Orders()
    class func defaultOrders()->Orders {
        return _defaultOrders
    }
    
    func flush(){
        let newOrdersData = try! NSJSONSerialization.dataWithJSONObject(_orders, options: NSJSONWritingOptions())
        NSUserDefaults.standardUserDefaults().setObject(newOrdersData, forKey: OrderSaveKey.orderArray)
    }
    
    func addOrder(order: Order){
        let orderDic = NSMutableDictionary(dictionary: order.orderDic)
        _orders.addObject(orderDic)
        flush()
       
    }
    
    func removeOrder(order: Order){
        
        let orderId = order.orderDic.objectForKey(OrderSaveKey.orderId) as? String
        _orders.enumerateObjectsUsingBlock { (productDic, index, stop) -> Void in
            let orderId2 = (productDic as? NSDictionary)?.objectForKey(OrderSaveKey.orderId) as? String
            if orderId == orderId2{
//                stop = YES //TODO: stop 如何置true
                self._orders.removeObjectAtIndex(index)
            }
        }
        flush()
    }
    
    func orderAtIndex(index:Int)->Order?{
        let dicOpt = _orders.objectAtIndex(index) as? NSMutableDictionary
        if let dic = dicOpt{
            return Order(dic: dic)
        }
        return nil
    }
    
    func removeObjectAtIndex(index:Int){
        _orders.removeObjectAtIndex(index)
        flush()
    }

    var orderCount: Int{
        return _orders.count
    }
    

}

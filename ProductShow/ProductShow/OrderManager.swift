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


let kOrdersChanged = "kOrdersChanged"

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
        let formatter = NSDateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let time = formatter.stringFromDate(NSDate())
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
        OrderManager.defaultManager().flush()
        return result
    }
    
    var imagePaths: NSArray?{
        return orderDic.objectForKey(OrderSaveKey.imagePaths) as? NSArray
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
    }
    
    //远程路径集
    func remotePathsDivideBy(divide: String)->String{
        let remotePaths = NSMutableString()
        imagePaths?.enumerateObjectsUsingBlock { (imagePathDic, index, stop) -> Void in
            if remotePaths.length > 0{
                remotePaths.appendString("|")
            }
            let remotepath = (imagePathDic as? NSDictionary)?.objectForKey(OrderSaveKey.remotepath) as! String
            remotePaths.appendString(remotepath)
        }
        return remotePaths as String
    }
    
    var products: NSArray{
        get{
            return orderDic.objectForKey(OrderSaveKey.products) as! NSArray
        }
        set{
            orderDic.setObject(newValue, forKey: OrderSaveKey.products)
            OrderManager.defaultManager().flush()
        }
    }
    
    var proIds: String{
        let _proIds =  NSMutableString()
        self.products.enumerateObjectsUsingBlock { (productDic, index, stop) -> Void in
            if _proIds.length > 0{
                _proIds.appendString("|")
            }
            _proIds.appendString("\(productDic.objectForKey(jfproId) as! Int)")
        }
        return _proIds as String
    }
    
    var orderName: String{
        get{
            let _orderName = orderDic.objectForKey(OrderSaveKey.orderName)
            if _orderName?.length>0{
                return _orderName as! String
            }else{
//                return "(\(products.count)个产品) (\(imagePaths?.count ?? 0)张图片)"
                return "(\(products.count)个产品)"
            }
        }
        set{
            orderDic.setObject(newValue, forKey: OrderSaveKey.orderName)
            OrderManager.defaultManager().flush()
        }
    }
    
    func addImage(imgfile:String){
        let imagePaths = orderDic.objectForKey(jfimgPaths) as! NSMutableArray
        imagePaths.addObject([OrderSaveKey.localpath : imgfile])
    }
    
}

class OrderManager: NSObject {
    
    var orders = NSMutableArray()
    
    override init() {
        //订单列表
        let oldOrdersDataOpt = NSUserDefaults.standardUserDefaults().objectForKey(OrderSaveKey.orderArray) as? NSData
        var jsonOpt : AnyObject? = nil
        if let oldOrdersData = oldOrdersDataOpt{
            jsonOpt = try? NSJSONSerialization.JSONObjectWithData(oldOrdersData, options: NSJSONReadingOptions.MutableContainers)
        }
        
        if let json = jsonOpt{
            orders = json as! NSMutableArray
        }
    }
    
    private static var _defaultManager = OrderManager()
    class func defaultManager()->OrderManager {
        return _defaultManager
    }
    
    internal func flush(){
        let newOrdersData = try! NSJSONSerialization.dataWithJSONObject(orders, options: NSJSONWritingOptions())
        NSUserDefaults.standardUserDefaults().setObject(newOrdersData, forKey: OrderSaveKey.orderArray)
    }
    
    func addOrder(order: Order){
        
        orders.addObject(order.orderDic)
        flush()
       
    }
    
    func removeOrder(order: Order){
        
        let orderId = order.orderDic.objectForKey(OrderSaveKey.orderId) as? String
        orders.enumerateObjectsUsingBlock { (productDic, index, stop) -> Void in
            let orderId2 = (productDic as? NSDictionary)?.objectForKey(OrderSaveKey.orderId) as? String
            if orderId == orderId2{
//                stop = YES //TODO: stop 如何置true
                self.orders.removeObjectAtIndex(index)
            }
        }
        flush()
    }
    
    func removeObjectAtIndex(index:Int){
        orders.removeObjectAtIndex(index)
        flush()
    }
//    class func addLocalImage
//    func addImage(imgfile:String, toOrderDic orderDic: NSMutableDictionary)->Bool{
//        let orderId = orderDic.objectForKey(OrderSaveKey.orderId) as! String
//        orders.enumerateObjectsUsingBlock { (productDic, index, var stop) -> Void in
//            let orderId2 = (productDic as! NSDictionary).objectForKey(OrderSaveKey.orderId) as! String
//            if orderId == orderId2{
//                //                stop = YES //TODO: stop 如何置true
//                let mutableDic = productDic as! NSMutableDictionary
//                let imagePaths = mutableDic.objectForKey(jfimgPaths) as! NSMutableArray
//                imagePaths.addObject([OrderSaveKey.localpath : imgfile])
//                //                save()
//            }
//        }
//        self.saveChangs()
//        return true
//        
//    }
    
//    class func getOrders()-> NSMutableArray?{
//        let dataOpt = NSUserDefaults.standardUserDefaults().objectForKey(OrderSaveKey.orderArray) as? NSData
//        if let data = dataOpt{
//            let json = try! NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers) as! NSMutableArray
//            return json
//        }
//        return nil
//    }
    

}

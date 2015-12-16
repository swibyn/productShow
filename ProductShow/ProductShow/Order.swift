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
        placed: true

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
    static let placed = "placed"
    static let orderTime = "orderTime"
    static let orderName = "orderName"
    static let imagePaths = "imagePaths"
    static let localpath = "localpath"
    static let remotepath = "remotepath"
    static let products = "products"
}

class ImagePath: NSObject{
    var pathDic: NSMutableDictionary!
    
    init(var pathDic: NSMutableDictionary?){
        super.init()

        if pathDic == nil{
            pathDic = NSMutableDictionary()
        }
        self.pathDic = pathDic
    }
    
    var localpath: String?{
        get{
            return pathDic.objectForKey(OrderSaveKey.localpath) as? String
        }
        set{
            pathDic.setObject(newValue ?? "", forKey: OrderSaveKey.localpath)
        }
    }
    
    var remotepath: String?{
        get{
            return pathDic.objectForKey(OrderSaveKey.remotepath) as? String
        }
        set{
            pathDic.setObject(newValue ?? "", forKey: OrderSaveKey.remotepath)
        }
    }
    
}

class Order: NSObject {
    
    var orderDic: NSMutableDictionary!
    
    override init(){
        super.init()

        let time = NSDate().toString("yyyy-MM-dd HH:mm:ss")
        self.orderDic = NSMutableDictionary(dictionary:
            [OrderSaveKey.orderId: time,
            OrderSaveKey.orderTime: time,
            OrderSaveKey.orderName: "",
            OrderSaveKey.imagePaths: NSMutableArray(),
            OrderSaveKey.products: NSMutableArray()]
        )
    }
    
    init(orderDic: NSMutableDictionary) {
        super.init()
        self.orderDic = orderDic
    }
    
    convenience init(products: NSArray) {
        self.init()
        self.products = products
    }
    
    //MARK:Image 相关
    func addImageByPath(localPath: String)->ImagePath{
        let newImagePath = ImagePath(pathDic: nil)
        newImagePath.localpath = localPath
        imagePaths?.addObject(newImagePath.pathDic)
        Orders.defaultOrders().flush()
        return newImagePath
    }
    
    
    var imagePaths: NSMutableArray?{
        return orderDic.objectForKey(OrderSaveKey.imagePaths) as? NSMutableArray
    }
    
    func imagePathAtIndex(index: Int)->ImagePath?{
        let imagePathDic = imagePaths?.objectAtIndex(index) as? NSMutableDictionary
        let imagePath = ImagePath(pathDic: imagePathDic)
        return imagePath
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
    
    //MARK:product相关
    var products: NSArray{
        get{
            return orderDic.objectForKey(OrderSaveKey.products) as! NSArray
        }
        set{
            orderDic.setObject(newValue, forKey: OrderSaveKey.products)
            Orders.defaultOrders().flush()
        }
    }
    
    //提交时的json对象
    var productsForSubmit: NSArray{
        let _productsForSubmit = NSMutableArray()
        
        for (_, productObj) in products.enumerate(){
        
//        products.enumerateObjectsUsingBlock { (productObj, index, stop) -> Void in
            let productDic = productObj as? NSMutableDictionary
            let product = Product(productDic: productDic!)
            let proId = product.proId
            let remark = product.additionInfo ?? ""
            let number = "\(product.number)"
            let dic = [jfproId: proId!, jfremark: remark, jfnumber: number]
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
    
    //MARK:属性
    var orderId: String?{
        return orderDic.objectForKey(OrderSaveKey.orderId) as? String
    }
    
    var placed: Bool{
        get{
            let _placed = orderDic.objectForKey(OrderSaveKey.placed) as? Bool
            return _placed ?? false
        }
        set{
            orderDic.setObject(newValue, forKey: OrderSaveKey.placed)
            Orders.defaultOrders().flush()
        }
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
    
    var nameWithPlacedState: String{
        if placed{
            return orderName + "(Already placed)"
        }else{
            return orderName
        }
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
        let newOrdersData = try? NSJSONSerialization.dataWithJSONObject(_orders, options: NSJSONWritingOptions())
        NSUserDefaults.standardUserDefaults().setObject(newOrdersData, forKey: OrderSaveKey.orderArray)
    }
    
    func addOrder(order: Order){
        let orderDic = NSMutableDictionary(dictionary: order.orderDic)
        _orders.addObject(orderDic)
        flush()
       
    }
    
    //删除订单
    func removeOrder(order: Order){
        
        for (_, orderDic) in _orders.enumerate(){
            let tmpOrder = Order(orderDic: orderDic as! NSMutableDictionary)
            if tmpOrder.orderId == order.orderId{
                _orders.removeObject(orderDic)
                break
            }
        }
        
        PhotoUtil.removeImagesInOrder(order)
        flush()
    }
    
    func removeOrderAtIndex(index:Int){
        let order = orderAtIndex(index)
        if order != nil{
            removeOrder(order!)
        }
    }
    
    func orderAtIndex(index:Int)->Order?{
        let dicOpt = _orders.objectAtIndex(index) as? NSMutableDictionary
        if let dic = dicOpt{
            return Order(orderDic: dic)
        }
        return nil
    }
    

    var orderCount: Int{
        return _orders.count
    }
    

}

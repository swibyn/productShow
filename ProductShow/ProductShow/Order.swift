//
//  OrdersUtil.swift
//  ProductShow
//
//  Created by s on 15/10/16.
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
    
    init(pathDic: NSMutableDictionary?){
        var pathDic = pathDic
        super.init()

        if pathDic == nil{
            pathDic = NSMutableDictionary()
        }
        self.pathDic = pathDic
    }
    
    var localpath: String?{
        get{
            return pathDic.object(forKey: OrderSaveKey.localpath) as? String
        }
        set{
            pathDic.setObject(newValue ?? "", forKey: OrderSaveKey.localpath as NSCopying)
        }
    }
    
    var remotepath: String?{
        get{
            return pathDic.object(forKey: OrderSaveKey.remotepath) as? String
        }
        set{
            pathDic.setObject(newValue ?? "", forKey: OrderSaveKey.remotepath as NSCopying)
        }
    }
    
}

class Order: NSObject {
    
    var orderDic: NSMutableDictionary!
    
    override init(){
        super.init()

        let time = Date().toString("yyyy-MM-dd HH:mm:ss")
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
    func addImageByPath(_ localPath: String)->ImagePath{
        let newImagePath = ImagePath(pathDic: nil)
        newImagePath.localpath = localPath
        imagePaths?.add(newImagePath.pathDic)
        Orders.defaultOrders().flush()
        return newImagePath
    }
    
    
    var imagePaths: NSMutableArray?{
        return orderDic.object(forKey: OrderSaveKey.imagePaths) as? NSMutableArray
    }
    
    func imagePathAtIndex(_ index: Int)->ImagePath?{
        let imagePathDic = imagePaths?.object(at: index) as? NSMutableDictionary
        let imagePath = ImagePath(pathDic: imagePathDic)
        return imagePath
    }
    
    var imgPathsForSubmit: NSArray{
        let _imgPaths = NSMutableArray()
        
        imagePaths?.enumerateObjects({ (imagePathObj, Index, stop) -> Void in
            let imagePathDic = imagePathObj as? NSDictionary
            let imgPath = imagePathDic?.object(forKey: OrderSaveKey.remotepath)
            _imgPaths.add([jfimgPath: imgPath!])
        })
        return _imgPaths
        
    }
    
    /*
    没有远程路径的就是需要提交的，所以提交完要给返回的对象设置远程路径值
    */
    func firstImageToBeUpload()->NSMutableDictionary?{
        var returnDic: NSMutableDictionary? = nil
        
        for (index,obj) in (imagePaths?.enumerated())!{
            let imagePathDic = obj as! NSMutableDictionary
            if imagePathDic.object(forKey: OrderSaveKey.remotepath) == nil {
                returnDic = imagePathDic 
                break
            }
        }
        return returnDic
//        imagePaths?.enumerateObjects { (imagePathDic, index, stop) -> Void in
//            if imagePathDic.object(forKey: OrderSaveKey.remotepath) == nil{
//                returnDic = imagePathDic as? NSMutableDictionary
//            }
//        }
//        return returnDic
    }
    
    //设置remotePath
    class func setRemotePath(_ remoteUrl: String, toDic dic: NSMutableDictionary){
        dic.setObject(remoteUrl, forKey: OrderSaveKey.remotepath as NSCopying)
        Orders.defaultOrders().flush()
    }
    
    //MARK:product相关
    var products: NSArray{
        get{
            return orderDic.object(forKey: OrderSaveKey.products) as! NSArray
        }
        set{
            orderDic.setObject(newValue, forKey: OrderSaveKey.products as NSCopying)
            Orders.defaultOrders().flush()
        }
    }
    
    //提交时的json对象
    var productsForSubmit: NSArray{
        let _productsForSubmit = NSMutableArray()
        
        for (_, productObj) in products.enumerated(){
        
//        products.enumerateObjectsUsingBlock { (productObj, index, stop) -> Void in
            let productDic = productObj as? NSMutableDictionary
            let product = Product(productDic: productDic!)
            let proId = product.proId
            let remark = product.additionInfo ?? ""
            let number = "\(product.number)"
            let dic = [jfproId: proId!, jfremark: remark, jfnumber: number] as [String : Any]
            _productsForSubmit.add(dic)
        }
        return _productsForSubmit
    }
    
    func productAtIndex(_ index: Int) -> Product?{
        let productDicOpt = products.object(at: index) as? NSMutableDictionary
        if let productDic = productDicOpt{
            return Product(productDic: productDic)
        }
        return nil
    }
    
    //MARK:属性
    var orderId: String?{
        return orderDic.object(forKey: OrderSaveKey.orderId) as? String
    }
    
    var placed: Bool{
        get{
            let _placed = orderDic.object(forKey: OrderSaveKey.placed) as? Bool
            return _placed ?? false
        }
        set{
            orderDic.setObject(newValue, forKey: OrderSaveKey.placed as NSCopying)
            Orders.defaultOrders().flush()
        }
    }
    
    var orderTime: String?{
        return orderDic.object(forKey: OrderSaveKey.orderTime) as? String
    }
    
    var orderName: String{
        get{
            let _orderName = orderDic.object(forKey: OrderSaveKey.orderName)
            if (_orderName as AnyObject).length>0{
                return _orderName as! String
            }else if products.count == 1{
                return "(1 product)"
            }else{
                return "(\(products.count) products)"
            }
        }
        set{
            orderDic.setObject(newValue, forKey: OrderSaveKey.orderName as NSCopying)
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
        let oldOrdersDataOpt = UserDefaults.standard.object(forKey: OrderSaveKey.orderArray) as? Data
        var jsonOpt : AnyObject? = nil
        if let oldOrdersData = oldOrdersDataOpt{
            jsonOpt = try! JSONSerialization.jsonObject(with: oldOrdersData, options: JSONSerialization.ReadingOptions.mutableContainers) as AnyObject?
        }
        
        if let json = jsonOpt{
            _orders = json as! NSMutableArray
        }
    }
    
    fileprivate static var _defaultOrders = Orders()
    class func defaultOrders()->Orders {
        return _defaultOrders
    }
    
    func flush(){
        let newOrdersData = try? JSONSerialization.data(withJSONObject: _orders, options: JSONSerialization.WritingOptions())
        UserDefaults.standard.set(newOrdersData, forKey: OrderSaveKey.orderArray)
    }
    
    func addOrder(_ order: Order){
        let orderDic = NSMutableDictionary(dictionary: order.orderDic)
        _orders.add(orderDic)
        flush()
       
    }
    
    //删除订单
    func removeOrder(_ order: Order){
        
        for (_, orderDic) in _orders.enumerated(){
            let tmpOrder = Order(orderDic: orderDic as! NSMutableDictionary)
            if tmpOrder.orderId == order.orderId{
                _orders.remove(orderDic)
                break
            }
        }
        
        PhotoUtil.removeImagesInOrder(order)
        flush()
    }
    
    func removeOrderAtIndex(_ index:Int){
        let order = orderAtIndex(index)
        if order != nil{
            removeOrder(order!)
        }
    }
    
    func orderAtIndex(_ index:Int)->Order?{
        let dicOpt = _orders.object(at: index) as? NSMutableDictionary
        if let dic = dicOpt{
            return Order(orderDic: dic)
        }
        return nil
    }
    

    var orderCount: Int{
        return _orders.count
    }
    

}

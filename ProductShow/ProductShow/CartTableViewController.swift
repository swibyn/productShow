//
//  CartTableViewController.swift
//  ProductShow
//
//  Created by s on 15/10/15.
//  Copyright © 2015年 gaozgao. All rights reserved.
//

import UIKit
import MobileCoreServices 

class CartTableViewController: UITableViewController/*,UIProductTableViewCellDelegate */{
    
    
    let cart = Cart.defaultCart()// Global.cart.products.objectsForKeys(Global.cart.products.allKeys, notFoundMarker: "a")
    
    //MARK: life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let nib = UINib(nibName: "ProductTableViewCell", bundle: nil)
        tableView.registerNib(nib, forCellReuseIdentifier: "productCell")
        self.addNotificationObserver()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    deinit{
        self.removeNotificationObserver()
    }
    
    
    //MARK: 消息通知
    func addNotificationObserver(){
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("handleProductsInCartChanged"), name: kProductsInCartChanged, object: nil)
    }
    
    func removeNotificationObserver(){
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    
    func handleProductsInCartChanged(){
//        dataArray = Global.cart.products.objectsForKeys(Global.cart.products.allKeys, notFoundMarker: "a")
        self.tableView.reloadData()
    }
    
    

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return cart.products.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("productCell", forIndexPath: indexPath) as! UIProductTableViewCell
        
        // Configure the cell...
        let dic = cart.products.allValues[indexPath.row] as! NSDictionary
//        ConfigureCell(cell, buttonTitle: "Delete", productDic: dic, delegate: self)
        ConfigureCell(cell, buttonTitle: "", productDic: dic, delegate: nil)
        
        return cell
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return CGFloat(UIProductTableViewCell.rowHeight)
    }

    
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    

    
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            let key = cart.products.allKeys[indexPath.row]
            cart.products.removeObjectForKey(key)
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    //MARK: UIProductTableViewCellDelegate
//    func productTableViewCellButtonDidClick(cell: UIProductTableViewCell) {
//        Global.cart.removeProduct(cell.productDic)
//        NSNotificationCenter.defaultCenter().postNotificationName(kProductsInCartChanged, object: self)
//    }
    
    // MARK: - Navigation
    
    override  func shouldPerformSegueWithIdentifier(identifier: String, sender: AnyObject?) -> Bool{
        if identifier == "CartToMyOrders"{
            if cart.products.count > 0{
                //订单信息
                let order = Order()
                order.products = cart.products.allValues
                
                
//                let orderDic = NSMutableDictionary()
//                let formatter = NSDateFormatter()
//                formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
//                orderDic.setObject(formatter.stringFromDate(NSDate()) as NSString, forKey: OrderSaveKey.orderTime)
////                orderDic.setObject(NSString(string: "未命名"), forKey: OrderSaveKey.orderName)
//                orderDic.setObject(NSMutableArray(), forKey: OrderSaveKey.imagePaths)
//                orderDic.setObject(dataArray, forKey: OrderSaveKey.products)
                
                OrderManager.defaultManager().addOrder(order)
                
            }else{
                return false
                //没东西
            }
        }
        return true
    }
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    
}



































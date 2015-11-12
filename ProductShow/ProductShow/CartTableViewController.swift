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
    
    
    let cart = Cart.defaultCart()
    
    //MARK: view life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Cart"
        
        let nib = UINib(nibName: "ProductTableViewCell", bundle: nil)
        tableView.registerNib(nib, forCellReuseIdentifier: "productCell")
        
        self.addProductsInCartChangedNotificationObserver()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    deinit{
        self.removeProductsInCartChangedNotificationObserver()
    }
    
    
    //MARK: 消息通知    
    override func handleProductsInCartChangedNotification(paramNotification: NSNotification) {
        super.handleProductsInCartChangedNotification(paramNotification)
        let postObj = paramNotification.object
        if !self.isEqual(postObj){
            self.tableView.reloadData()
        }
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
        let dic = cart.products.allValues[indexPath.row] as! NSMutableDictionary
        
        ConfigureCell(cell, canAddToCart:false, product: Product(productDic: dic), delegate: nil)
        
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
            self.postProductsInCartChangedNotification()
//            self.performSelector(Selector("postProductsInCartChangedNotification"), withObject: nil, afterDelay: 0.5)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let cell = tableView.cellForRowAtIndexPath(indexPath) as? UIProductTableViewCell
        let detailVC = cell?.productViewController()
        self.navigationController?.pushViewController(detailVC!, animated: true)
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
    
    // MARK: - Navigation
    override  func shouldPerformSegueWithIdentifier(identifier: String, sender: AnyObject?) -> Bool{
        if identifier == "CartToMyOrders"{
            if cart.products.count > 0{
                //订单信息
                let order = Order()
                order.products = cart.products.allValues
                
                Orders.defaultOrders().addOrder(order)
                cart.removeProducts()
                
                postProductsInCartChangedNotification()
                postOrdersChangedNotification()
                
                self.tableView.reloadData()
                
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



































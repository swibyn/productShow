//
//  CartTableViewController.swift
//  ProductShow
//
//  Created by s on 15/10/15.
//  Copyright © 2015年 gaozgao. All rights reserved.
//

import UIKit
import MobileCoreServices 

class CartTableViewController: UITableViewController,UIProductAndRemarkTableViewCellDelegate,UITextViewControllerDelegate{
    
    let tvCell = UIProductAndRemarkTableViewCell.self
    
    let cart = Cart.defaultCart()
    
    //MARK: view life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Cart"
        
//        let nib = UINib(nibName: "ProductTableViewCell", bundle: nil)
//        tableView.registerNib(nib, forCellReuseIdentifier: "productCell")
        
        let nib = UINib(nibName: tvCell.nibName, bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: tvCell.cellid)
        
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
    override func handleProductsInCartChangedNotification(_ paramNotification: Notification) {
        super.handleProductsInCartChangedNotification(paramNotification)
        let postObj = paramNotification.object
        if !self.isEqual(postObj){
            self.tableView.reloadData()
        }
    }
    

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return cart.productsCount
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: tvCell.cellid, for: indexPath) as! UIProductAndRemarkTableViewCell
        
        // Configure the cell...
//        let dic = cart.products.allValues[indexPath.row] as! NSMutableDictionary
        let product = cart.productAtIndex(indexPath.row)
        
//        ConfigureCell(cell, canAddToCart:false, product: Product(productDic: dic), delegate: nil)
        if product != nil{
            ConfigureCell(cell, showRightButton: true, product: product!, delegate: self)
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(UIProductTableViewCell.rowHeight)
    }

    
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    

    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
//            let key = cart.products.allKeys[indexPath.row]
//            cart.products.removeObjectForKey(key)
            cart.removeProductByIndex(indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            self.postProductsInCartChangedNotification()
//            self.performSelector(Selector("postProductsInCartChangedNotification"), withObject: nil, afterDelay: 0.5)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as? UIProductAndRemarkTableViewCell
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
    override  func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool{
        if identifier == "CartToMyOrders"{
            if cart.productsCount > 0{
                //订单信息
                let order = cart.generateOrder()
                
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
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    
    //MARK: UIProductAndRemarkTableViewCellDelegate
    var remarkCell: UIProductAndRemarkTableViewCell?
    func productAndRemarkTableViewCellMemoButtonAction(_ cell: UIProductAndRemarkTableViewCell) {
        remarkCell = cell// self.tableView.indexPathForCell(cell)
        //添加备注
        let product = cell.product
        let textViewVC = UITextViewController.newInstance()
        textViewVC.delegate = self
        let additionInfo = product?.additionInfo
        let text = additionInfo ?? ""
        textViewVC.initTextViewText = text
        textViewVC.title = (product?.proName)!
        
        self.navigationController?.pushViewController(textViewVC, animated: true)
    }
    
    func productAndRemarkTableViewCellQuantityDidChanged(_ cell: UIProductAndRemarkTableViewCell) {
        
    }
    
    
    //MARK: UITextViewControllerDelegate
    func textViewControllerDone(_ textViewVC: UITextViewController) {
//        let row = remarkCellIndexPath?.row
        let product = remarkCell?.product// order.productAtIndex(row!)
        product?.additionInfo = textViewVC.textView.text
//        Orders.defaultOrders().flush()
        cart.flush()
        self.navigationController?.popViewController(animated: true)
//        self.tableView.reloadData()
        
    }
}



































//
//  HotProductsTableViewController.swift
//  test
//
//  Created by s on 15/8/21.
//  Copyright (c) 2015年 sunward. All rights reserved.
//

import UIKit


class ProductsTableViewController: UITableViewController,UIProductTableViewCellDelegate {
    
    //MARK: 初始化一个实例
    static func newInstance()->ProductsTableViewController{
        
        let aInstance = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ProductsTableViewController") as! ProductsTableViewController
        return aInstance
    }

    
//    var category2 : Category?//通过类目信息获取列表
//    var customer: Customer? //通过客户信息获取列表
    
    var products: Products?//()

    @IBOutlet var cartBarButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if self.title == nil{
            self.title = "Products"
        }
        
        let nib = UINib(nibName: "ProductTableViewCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "productCell")
        
        self.addProductsInCartChangedNotificationObserver()
        self.cartBarButton.title = Cart.defaultCart().title
    
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if products?.status != 1{
            let msgString = self.products?.message
            let alertView = UIAlertView(title: nil, message: msgString, delegate: nil, cancelButtonTitle: "OK")
            alertView.show()
        }
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
        self.cartBarButton.title = Cart.defaultCart().title
    }
    
    
    //MARK: - Table view delegate
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectCell = tableView.cellForRow(at: indexPath) as? UIProductTableViewCell
        let detailVc = selectCell?.productViewController()
       // detailVc?.product = selectCell?.product
        self.navigationController?.pushViewController(detailVc!, animated: true)
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        return products?.productsCount ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "productCell", for: indexPath) as! UIProductTableViewCell
        
        // Configure the cell...
        let product = products?.productAtIndex(indexPath.row)
        if product != nil{
            ConfigureCell(cell, canAddToCart:true, product: product!, delegate: self)
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(UIProductTableViewCell.rowHeight)
    }

    
    //MARK: UIProductTableViewCellDelegate
    func productTableViewCellButtonDidClick(_ cell: UIProductTableViewCell) {
        Cart.defaultCart().addProduct(cell.product)
        NotificationCenter.default.post(name: Notification.Name(rawValue: kProductsInCartChanged), object: self)
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

}

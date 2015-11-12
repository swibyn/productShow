//
//  HotProductsTableViewController.swift
//  test
//
//  Created by s on 15/8/21.
//  Copyright (c) 2015年 sunward. All rights reserved.
//

import UIKit

class ProductsTableViewController: UITableViewController,UIProductTableViewCellDelegate {
    
    var category2 : Category?
    var products = Products()

    @IBOutlet var cartBarButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = category2?.catName
        
        let nib = UINib(nibName: "ProductTableViewCell", bundle: nil)
        tableView.registerNib(nib, forCellReuseIdentifier: "productCell")
        
        self.addProductsInCartChangedNotificationObserver()
        self.cartBarButton.title = Cart.defaultCart().title
        
        self.GetProducts()
        
    }
    


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    deinit{
        self.removeProductsInCartChangedNotificationObserver()
    }
    
    //MARK: 获取数据
    func GetProducts(){
        
        let catId = category2?.catId
        WebApi.GetProductsByCatId([jfcatId : catId!], completedHandler: { (response, data, error) -> Void in
            
            if WebApi.isHttpSucceed(response, data: data, error: error){
                
                let json = (try! NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableContainers)) as! NSDictionary
                //                debugPrint("\(self) \(__FUNCTION__) json=\(json)")
                self.products.returnDic = json
                self.tableView.reloadData()
                
                if (self.products.status == 1){
                    //获取成功
//                    self.tableView.reloadData()
                }else{
                    let msgString = self.products.message
                    let alertView = UIAlertView(title: nil, message: msgString, delegate: nil, cancelButtonTitle: "OK")
                    alertView.show()
                }
            }
        })

    }
    
    //MARK: 消息通知
    
    override func handleProductsInCartChanged(paramNotification: NSNotification) {
        self.cartBarButton.title = Cart.defaultCart().title
    }
    
    
    //MARK: - Table view delegate
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
//        debugPrint("\(self) \(__FUNCTION__)  indexPath=\(indexPath)")
        
        let selectCell = tableView.cellForRowAtIndexPath(indexPath) as? UIProductTableViewCell
        let detailVc = selectCell?.productViewController()
        detailVc?.product = selectCell?.product // products.productAtIndex(indexPath.row)// selectCell?.productDic
        self.navigationController?.pushViewController(detailVc!, animated: true)
    }
    
    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        return products.productsCount// dataArray?.count ?? 0
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("productCell", forIndexPath: indexPath) as! UIProductTableViewCell
        
        // Configure the cell...
        
        ConfigureCell(cell, canAddToCart:true, product: products.productAtIndex(indexPath.row)!, delegate: self)
        
        return cell
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return CGFloat(UIProductTableViewCell.rowHeight)
    }

    
    //MARK: UIProductTableViewCellDelegate
    func productTableViewCellButtonDidClick(cell: UIProductTableViewCell) {
        Cart.defaultCart().addProduct(cell.product.productDic!)
        NSNotificationCenter.defaultCenter().postNotificationName(kProductsInCartChanged, object: self)
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

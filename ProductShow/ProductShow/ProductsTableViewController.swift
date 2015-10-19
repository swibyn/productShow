//
//  HotProductsTableViewController.swift
//  test
//
//  Created by s on 15/8/21.
//  Copyright (c) 2015年 sunward. All rights reserved.
//

import UIKit

class ProductsTableViewController: UITableViewController,UIProductTableViewCellDelegate {
    
    var catId: Int = 0
    var catName: String = "产品列表" //一级名称
//    var dataArray: NSArray?
    var products = Products()

    @IBOutlet var cartBarButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = catName
        
        let nib = UINib(nibName: "ProductTableViewCell", bundle: nil)
        tableView.registerNib(nib, forCellReuseIdentifier: "productCell")
        
        self.addNotificationObserver()
        self.cartBarButton.title = "购物车\(Cart.defaultCart().products.count)"
        
        WebApi.GetProductsByCatId([jfcatId : catId], completedHandler: { (response, data, error) -> Void in
            
            if WebApi.isHttpSucceed(response, data: data, error: error){
                
                let json = (try! NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.AllowFragments)) as! NSDictionary
                debugPrint("\(self) \(__FUNCTION__) json=\(json)")
                self.products.productsDic = json
                
//                let statusInt = json.objectForKey(jfstatus) as! Int
                if (self.products.status == 1){
                    //获取成功
//                    let data = json.objectForKey(jfdata) as! NSDictionary
//                    let dt = data.objectForKey(jfdt) as! NSArray
                    
//                    self.dataArray = dt
                    self.tableView.reloadData()
                }else{
                    let msgString = json.objectForKey(jfmessage) as! String
                    let alertView = UIAlertView(title: "数据获取失败", message: msgString, delegate: nil, cancelButtonTitle: "OK")
                    alertView.show()
                }
                
                
            }

            
        })
        
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
        self.cartBarButton.title = "购物车\(Cart.defaultCart().products.count)"
    }
    
    
    //MARK: - Table view delegate
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        debugPrint("\(self) \(__FUNCTION__)  indexPath=\(indexPath)")
        
        let selectCell = tableView.cellForRowAtIndexPath(indexPath) as? UIProductTableViewCell
        let detailVc = selectCell?.productTableViewController()
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
//        let dic = dataArray?.objectAtIndex(indexPath.row) as! NSDictionary
        
        ConfigureCell(cell, buttonTitle: "Add", product: products.productAtIndex(indexPath.row)!, delegate: self)
        
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

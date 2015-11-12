//
//  HotProductsTableViewController.swift
//  ProductShow
//
//  Created by s on 15/10/13.
//  Copyright (c) 2015年 gaozgao. All rights reserved.
//

import UIKit

class HotProductsTableViewController: UITableViewController,UIProductTableViewCellDelegate {
    
    var products = Products()

    //@IB
    @IBOutlet var cartBarButton: UIBarButtonItem!
    
    //MARK: view life
    override func viewDidLoad() {
        super.viewDidLoad()
        debugPrint("\(self) \(__FUNCTION__)")
        
        self.title = "Hot Products"
        self.addFirstPageButton()
        
        let nib = UINib(nibName: "ProductTableViewCell", bundle: nil)
        tableView.registerNib(nib, forCellReuseIdentifier: "productCell")
        
        self.addProductsInCartChangedNotificationObserver()
        self.addLoginNotificationObserver()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        debugPrint("\(self) \(__FUNCTION__)")
    }
    
    override func viewDidAppear(animated: Bool) { //首页过来，没有触发，现在viewdidload中showfirstpage
        super.viewDidAppear(animated)
        debugPrint("\(self) \(__FUNCTION__)")
    }
    
    deinit{
        self.removeProductsInCartChangedNotificationObserver()
        self.removeLoginNotificationObserver()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: 消息通知
    override func handleLoginSucceed(paramNotification: NSNotification) {
        super.handleLoginSucceed(paramNotification)
        if products.productsCount == 0{
            showFirstPage()
        }
    }
    
    override func handleProductsInCartChanged(paramNotification: NSNotification) {
        super.handleProductsInCartChanged(paramNotification)
        cartBarButton.title = Cart.defaultCart().title
    }
    

    //MARK:显示第一页
    func showFirstPage(){
        if UserInfo.defaultUserInfo().status == 0{
            return
        }
        WebApi.GetHotPro(nil, completedHandler: { (response, data, error) -> Void in
            self.refreshControl?.endRefreshing()

            if WebApi.isHttpSucceed(response, data: data, error: error){
                let json = (try? NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableContainers)) as? NSDictionary
//                debugPrint("\(self) \(__FUNCTION__) json=\(json)")
                self.products.returnDic = json
                self.tableView.reloadData()
                
                if self.products.status == 1{
                    //获取成功
//                    self.tableView.reloadData()
                }else{
                    let msgString = json?.objectForKey(jfmessage) as? String
                    let alertView = UIAlertView(title: nil, message: msgString ?? Pleasecheckthenetworkconnection, delegate: nil, cancelButtonTitle: "OK")
                    alertView.show()
                }
            }
        })
    }
    
    //MARK: Table view delegate
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
//        debugPrint("\(self) \(__FUNCTION__)  indexPath=\(indexPath)")
        let selectCell = tableView.cellForRowAtIndexPath(indexPath) as? UIProductTableViewCell
        let detailVc = selectCell?.productViewController()
//        detailVc?.product = selectCell?.product
        let nav = self.navigationController
        nav?.pushViewController(detailVc!, animated: true)
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
        return products.productsCount
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
    

    //MARK: UIScrollViewDalegate
    override func scrollViewDidEndDragging(scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        debugPrint("\(__FUNCTION__) \(scrollView.contentOffset)")
        if scrollView.contentOffset.y < -200{
            self.showFirstPage()
        }
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
    
    //MARK: UIProductTableViewCellDelegate
    func productTableViewCellButtonDidClick(cell: UIProductTableViewCell) {
        Cart.defaultCart().addProduct(cell.product.productDic!)
        self.postProductsInCartChangedNotification()
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

}

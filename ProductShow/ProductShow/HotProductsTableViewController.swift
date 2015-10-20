//
//  HotProductsTableViewController.swift
//  ProductShow
//
//  Created by s on 15/10/13.
//  Copyright (c) 2015年 gaozgao. All rights reserved.
//

import UIKit

class HotProductsTableViewController: UITableViewController,UIProductTableViewCellDelegate {
    
//    var dataArray: NSArray?
    var products = Products()

    @IBOutlet var cartBarButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Hot Products"
        self.addFirstPageButton()
        
        let nib = UINib(nibName: "ProductTableViewCell", bundle: nil)
        tableView.registerNib(nib, forCellReuseIdentifier: "productCell")
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
//        if Global.userInfo != nil{
            self.showFirstPage()
//        }
        self.addNotificationObserver()
    }
    
    override func viewDidAppear(animated: Bool) { //首页过来，没有触发，现在viewdidload中showfirstpage
        debugPrint("\(self) \(__FUNCTION__)")

//        if dataArray?.count > 0{
        if products.productsCount > 0{
        
        }else{
            self.showFirstPage()
        }
    }
    
    deinit{
        self.removeNotificationObserver()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: 消息通知
    func addNotificationObserver(){
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("handleProductsInCartChanged"), name: kProductsInCartChanged, object: nil)
    }
    
    func removeNotificationObserver(){
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    func handleProductsInCartChanged(){
        self.cartBarButton.title = Cart.defaultCart().title
    }
    

    //MARK:显示第一页
    func showFirstPage(){
        WebApi.GetHotPro(nil, completedHandler: { (response, data, error) -> Void in
            if WebApi.isHttpSucceed(response, data: data, error: error){
                
                let json = (try! NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.AllowFragments)) as! NSDictionary
//                debugPrint("\(self) \(__FUNCTION__) json=\(json)")
                self.products.productsDic = json
                
//                let statusInt = json.objectForKey(jfstatus) as! Int
//                if (statusInt == 1){
                if self.products.status == 1{
                    //获取成功
//                    let data = json.objectForKey(jfdata) as! NSDictionary
//                    let dt = data.objectForKey(jfdt) as! NSArray
//                    
//                    self.dataArray = dt
                    self.tableView.reloadData()
                }else{
                    let msgString = json.objectForKey(jfmessage) as! String
                    let alertView = UIAlertView(title: "Fail", message: msgString, delegate: nil, cancelButtonTitle: "OK")
                    alertView.show()
                }
            }
        })
    }
    
    //MARK: Table view delegate
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        debugPrint("\(self) \(__FUNCTION__)  indexPath=\(indexPath)")
        let selectCell = tableView.cellForRowAtIndexPath(indexPath) as? UIProductTableViewCell
        let detailVc = selectCell?.productTableViewController()
        detailVc?.product = selectCell?.product
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
    

    //MARK: UIScrollViewDalegate
//    override func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
//        
//        debugPrintln("\(__FUNCTION__) \(scrollView.contentOffset)")
//
//    }
    override func scrollViewDidEndDragging(scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        debugPrint("\(__FUNCTION__) \(scrollView.contentOffset)")
        if scrollView.contentOffset.y < -200{
            self.showFirstPage()
        }
    }
    
//    override func scrollViewDidEndScrollingAnimation(scrollView: UIScrollView) {
//        debugPrintln("\(__FUNCTION__)")
//    }
//    override func scrollViewDidEndZooming(scrollView: UIScrollView, withView view: UIView!, atScale scale: CGFloat) {
//        
//        debugPrintln("\(__FUNCTION__)")
//
//    }

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
        NSNotificationCenter.defaultCenter().postNotificationName(kProductsInCartChanged, object: self)
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

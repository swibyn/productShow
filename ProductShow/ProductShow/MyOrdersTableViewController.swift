//
//  MyOrdersTableViewController.swift
//  ProductShow
//
//  Created by s on 15/10/16.
//  Copyright © 2015年 gaozgao. All rights reserved.
//

import UIKit

class MyOrdersTableViewController: UITableViewController,UIAlertViewDelegate {
    
    var dataArray : NSMutableArray?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        dataArray = OrderManager.defaultManager().orders //保持这个引用，不要重新赋值
        
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
        removeNotificationObserver()
    }
    
    //MARK: 消息通知
    func addNotificationObserver(){
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("handleOrdersChanged"), name: kOrdersChanged, object: nil)
    }
    
    func removeNotificationObserver(){
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    func handleOrdersChanged(){
        dataArray = OrderManager.defaultManager().orders
        self.tableView.reloadData()
    }

    //MARK: UIAlertViewDelegate
    func alertView(alertView: UIAlertView, clickedButtonAtIndex buttonIndex: Int){
        let title = alertView.buttonTitleAtIndex(buttonIndex)
        if title == "OK"{
            let indexPath = self.tableView.indexPathForSelectedRow
            let dic = dataArray?.objectAtIndex((indexPath?.row)!) as? NSMutableDictionary
            Order(dic: dic!).orderName = alertView.textFieldAtIndex(0)?.text ?? ""
           
        }
    
    }
    
    func alertViewCancel(alertView: UIAlertView) {
        
    }

    // MARK: Table View Delegate
    override func tableView(tableView: UITableView, accessoryButtonTappedForRowWithIndexPath indexPath: NSIndexPath) {
        let alert = UIAlertView(title: "修改订单名称", message: "message", delegate: self, cancelButtonTitle: "Cancel")
        alert.addButtonWithTitle("OK")
        alert.show()
    }
    
    // MARK: - Table view data source
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return dataArray?.count ?? 0
    }
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath)
        
        // Configure the cell...
        let dic = dataArray?.objectAtIndex(indexPath.row) as! NSMutableDictionary
        cell.textLabel?.text = Order(dic: dic).orderName
        cell.detailTextLabel?.text = dic.objectForKey(OrderSaveKey.orderTime) as? String
        
        
        return cell
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
//            dataArray?.removeObjectAtIndex(indexPath.row)
            OrderManager.defaultManager().removeObjectAtIndex(indexPath.row)

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

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        let selectedIndexPath = self.tableView.indexPathForSelectedRow!
        let destVC: AnyObject = segue.destinationViewController
        let dic = self.dataArray?[selectedIndexPath.row] as! NSMutableDictionary
        
        destVC.setValue(Order(dic: dic), forKey: "order")
    }
    

}
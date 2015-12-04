//
//  MyOrdersTableViewController.swift
//  ProductShow
//
//  Created by s on 15/10/16.
//  Copyright © 2015年 gaozgao. All rights reserved.
//

import UIKit

class MyOrdersTableViewController: UITableViewController,UIAlertViewDelegate, OrderDetailTableViewControllerDelegate,UICommonTableViewCellDelegate {
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let nib = UINib(nibName: "CommonTableViewCell", bundle: nil)
        tableView.registerNib(nib, forCellReuseIdentifier: "CommonTableViewCell")
        
        self.addOrdersChangedNotificationObserver()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    deinit{
        self.removeOrdersChangedNotificationObserver()
    }
    
    //MARK: 消息通知
    override func handleOrdersChangedNotification(paramNotification: NSNotification) {
        super.handleOrdersChangedNotification(paramNotification)
        if !self.isEqual(paramNotification.object){
            self.tableView.reloadData()
        }
    }

    //MARK: - UIAlertViewDelegate
    func alertView(alertView: UIAlertView, clickedButtonAtIndex buttonIndex: Int){
        let title = alertView.buttonTitleAtIndex(buttonIndex)
        if title == "OK"{
            let order = Orders.defaultOrders().orderAtIndex((indexPathForAccessoryButtonTapped?.row)!)
                order?.orderName = alertView.textFieldAtIndex(0)?.text ?? ""
            
            self.tableView.reloadData()
        }
    }
    
    //MARK: UICommonTableViewCellDelegate
    var indexPathForAccessoryButtonTapped: NSIndexPath?
    func commonTableViewCellDetailButtonAction(cell: UICommonTableViewCell) {
        indexPathForAccessoryButtonTapped = cell.indexPath
        let alert = UIAlertView(title: "Set order name to", message: nil, delegate: self, cancelButtonTitle: "Cancel")
        alert.alertViewStyle = UIAlertViewStyle.PlainTextInput
        
        alert.textFieldAtIndex(0)?.text = Orders.defaultOrders().orderAtIndex(cell.indexPath!.row)?.orderName
        alert.addButtonWithTitle("OK")
        alert.show()
    }
    
    // MARK: - Table View Delegate
    // MARK: - Table view data source
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return Orders.defaultOrders().orderCount // dataArray?.count ?? 0
    }
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("CommonTableViewCell", forIndexPath: indexPath) as! UICommonTableViewCell
        cell.initCell(self, indexPath: indexPath, hideRightButtons: false)
     
        
        // Configure the cell...
        let order = Orders.defaultOrders().orderAtIndex(indexPath.row)
        cell.leftLabel.text = order?.nameWithPlacedState
        cell.rightLabel.text = order?.orderTime
        
        return cell
        
    }

    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return CGFloat(UICommonTableViewCell.rowHeight)
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let detailVc = OrderDetailTableViewController.newInstance()
        detailVc.order = Orders.defaultOrders().orderAtIndex(indexPath.row)
        detailVc.delegate = self
        self.navigationController?.pushViewController(detailVc, animated: true)
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
            
            Orders.defaultOrders().removeObjectAtIndex(indexPath.row)
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
            postOrdersChangedNotification()
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
        let destVC: UIViewController = segue.destinationViewController
      
        (destVC as? OrderDetailTableViewController)?.delegate = self
        
        let order = Orders.defaultOrders().orderAtIndex(selectedIndexPath.row)
        destVC.setValue(order, forKey: "order")
    }
    
    //MARK: OrderDetailTableViewControllerDelegate
    func OrderDetailTableViewDidPlaceOrder(detailController: OrderDetailTableViewController) {
//        self.tableView.reloadData()
        self.navigationController?.popViewControllerAnimated(true)
    }
    

}
















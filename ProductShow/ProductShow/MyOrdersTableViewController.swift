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
        
        self.addNotificationObserver()
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
        self.tableView.reloadData()
    }

    //MARK: - UIAlertViewDelegate
    func alertView(alertView: UIAlertView, clickedButtonAtIndex buttonIndex: Int){
//        debugPrint("\(self) \(__FUNCTION__)")
        let title = alertView.buttonTitleAtIndex(buttonIndex)
        if title == "OK"{
            let order = Orders.defaultOrders().orderAtIndex((indexPathForAccessoryButtonTappedRow?.row)!)
                order?.orderName = alertView.textFieldAtIndex(0)?.text ?? ""
            
            self.tableView.reloadData()
        }
    }
    
    func alertViewCancel(alertView: UIAlertView) {
//        debugPrint("\(self) \(__FUNCTION__)")
    }

    // MARK: - Table View Delegate
    var indexPathForAccessoryButtonTappedRow: NSIndexPath?
    override func tableView(tableView: UITableView, accessoryButtonTappedForRowWithIndexPath indexPath: NSIndexPath) {
        indexPathForAccessoryButtonTappedRow = indexPath
        let alert = UIAlertView(title: "Set order name to", message: nil, delegate: self, cancelButtonTitle: "Cancel")
        alert.alertViewStyle = UIAlertViewStyle.PlainTextInput
//        let dic = dataArray?.objectAtIndex(indexPath.row) as? NSMutableDictionary
        
        alert.textFieldAtIndex(0)?.text = Orders.defaultOrders().orderAtIndex(indexPath.row)?.orderName// Order(dic: dic!).orderName
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
        return Orders.defaultOrders().orderCount // dataArray?.count ?? 0
    }
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("CommonTableViewCell", forIndexPath: indexPath) as! UICommonTableViewCell
        cell.initCell(self, indexPath: indexPath, hideRightButtons: false)
     
        
        // Configure the cell...
        let order = Orders.defaultOrders().orderAtIndex(indexPath.row)
        cell.leftLabel.text = order?.orderName
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
//            dataArray?.removeObjectAtIndex(indexPath.row)
//            OrderManager.defaultManager().removeObjectAtIndex(indexPath.row)
            Orders.defaultOrders().removeObjectAtIndex(indexPath.row)

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
        (destVC as? OrderDetailTableViewController)?.delegate = self
//        let dic = self.dataArray?[selectedIndexPath.row] as! NSMutableDictionary
        
        destVC.setValue(Orders.defaultOrders().orderAtIndex(selectedIndexPath.row), forKey: "order")
    }
    
    //MARK: OrderDetailTableViewControllerDelegate
    func OrderDetailTableViewDidPlaceOrder(detailController: OrderDetailTableViewController) {
//        self.navigationController?.popToViewController(self, animated: true)
//        self.navigationController?.popViewControllerAnimated(true)
        self.tableView.reloadData()
    }
    
    //MARK: UICommonTableViewCellDelegate
    func commonTableViewCellDetailButtonAction(cell: UICommonTableViewCell) {
        indexPathForAccessoryButtonTappedRow = cell.indexPath
        let alert = UIAlertView(title: "Set order name to", message: nil, delegate: self, cancelButtonTitle: "Cancel")
        alert.alertViewStyle = UIAlertViewStyle.PlainTextInput
        //        let dic = dataArray?.objectAtIndex(indexPath.row) as? NSMutableDictionary
        
        alert.textFieldAtIndex(0)?.text = Orders.defaultOrders().orderAtIndex(cell.indexPath!.row)?.orderName// Order(dic: dic!).orderName
        alert.addButtonWithTitle("OK")
        alert.show()

        
        
    }

}
















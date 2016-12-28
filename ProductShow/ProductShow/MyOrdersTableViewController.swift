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
        tableView.register(nib, forCellReuseIdentifier: "CommonTableViewCell")
        
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
    override func handleOrdersChangedNotification(_ paramNotification: Notification) {
        super.handleOrdersChangedNotification(paramNotification)
        if !self.isEqual(paramNotification.object){
            self.tableView.reloadData()
        }
    }

    //MARK: - UIAlertViewDelegate
    func alertView(_ alertView: UIAlertView, clickedButtonAt buttonIndex: Int){
        let title = alertView.buttonTitle(at: buttonIndex)
        if title == "OK"{
            let order = Orders.defaultOrders().orderAtIndex((indexPathForAccessoryButtonTapped?.row)!)
                order?.orderName = alertView.textField(at: 0)?.text ?? ""
            
            self.tableView.reloadData()
        }
    }
    
    //MARK: UICommonTableViewCellDelegate
    var indexPathForAccessoryButtonTapped: IndexPath?
    func commonTableViewCellDetailButtonAction(_ cell: UICommonTableViewCell) {
        indexPathForAccessoryButtonTapped = cell.indexPath as IndexPath?
        let alert = UIAlertView(title: "Set order name to", message: nil, delegate: self, cancelButtonTitle: "Cancel")
        alert.alertViewStyle = UIAlertViewStyle.plainTextInput
        
        alert.textField(at: 0)?.text = Orders.defaultOrders().orderAtIndex(cell.indexPath!.row)?.orderName
        alert.addButton(withTitle: "OK")
        alert.show()
    }
    
    // MARK: - Table View Delegate
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return Orders.defaultOrders().orderCount // dataArray?.count ?? 0
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CommonTableViewCell", for: indexPath) as! UICommonTableViewCell
        cell.initCell(self, indexPath: indexPath, hideRightButtons: false)
     
        
        // Configure the cell...
        let order = Orders.defaultOrders().orderAtIndex(indexPath.row)
        cell.leftLabel.text = order?.nameWithPlacedState
        cell.rightLabel.text = order?.orderTime
        
        return cell
        
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(UICommonTableViewCell.rowHeight)
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let detailVc = OrderDetailTableViewController.newInstance()
        detailVc.order = Orders.defaultOrders().orderAtIndex(indexPath.row)
        detailVc.delegate = self
        self.navigationController?.pushViewController(detailVc, animated: true)
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
            
            Orders.defaultOrders().removeOrderAtIndex(indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            postOrdersChangedNotification()
        } else if editingStyle == .insert {
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
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        let selectedIndexPath = self.tableView.indexPathForSelectedRow!
        let destVC: UIViewController = segue.destination
      
        (destVC as? OrderDetailTableViewController)?.delegate = self
        
        let order = Orders.defaultOrders().orderAtIndex(selectedIndexPath.row)
        destVC.setValue(order, forKey: "order")
    }
    
    //MARK: OrderDetailTableViewControllerDelegate
    func OrderDetailTableViewDidPlaceOrder(_ detailController: OrderDetailTableViewController) {
//        self.tableView.reloadData()
        self.navigationController?.popViewController(animated: true)
    }
    

}
















//
//  UICustomersTableViewController.swift
//  ProductShow
//
//  Created by s on 15/10/22.
//  Copyright © 2015年 gaozgao. All rights reserved.
//

import UIKit

class UICustomersTableViewController: UITableViewController {
    
    var customers = Customers()

    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "Customers"
        
        let nib = UINib(nibName: "CommonTableViewCell", bundle: nil)
        tableView.registerNib(nib, forCellReuseIdentifier: "CommonTableViewCell")
        
        
        GetCustomer()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: function
    func GetCustomer(){
        let uid = UserInfo.defaultUserInfo().firstUser?.uid
        WebApi.GetCustomer([jfsaleId: uid!],  completedHandler: { (response, data, error) -> Void in
            if WebApi.isHttpSucceed(response, data: data, error: error){
                
                let json = (try! NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableContainers)) as! NSDictionary
                
                self.customers.returnDic = json
                self.tableView.reloadData()
                
                if (self.customers.status == 1){
//                    self.tableView.reloadData()
                    
                }else{
                    let msgString = json.objectForKey(jfmessage) as! String
                    let alertView = UIAlertView(title: "", message: msgString, delegate: nil, cancelButtonTitle: "OK")
                    alertView.show()
                }
            }
//            else{
//                let alertView = UIAlertView(title: "Fail", message: "Check the internet connection", delegate: nil, cancelButtonTitle: "OK")
//                alertView.show()
//            }
        })

        
    }
    
    // MARK: - Table view delegate
    
    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return customers.customersCount
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("CommonTableViewCell", forIndexPath: indexPath) as! UICommonTableViewCell
        cell.initCell(nil, indexPath: nil, hideRightButtons: true)
        cell.accessButton.hidden = false
        
        // Configure the cell...
        let customer = customers.customerAtIndex(indexPath.row)
        let linkman = customer?.linkman ?? ""
        let custName = customer?.custName ?? ""
        cell.leftLabel.text = "\(custName) - \(linkman)"
        
        return cell
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return CGFloat(UICommonTableViewCell.rowHeight)
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let visitLogTVC = VisitLogTableViewContrller.newInstance()
        visitLogTVC.setValue(customers.customerAtIndex(indexPath.row), forKey: "customer")
        self.navigationController?.pushViewController(visitLogTVC, animated: true)
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
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
        let customer = customers.customerAtIndex(selectedIndexPath.row)
        let destVc = segue.destinationViewController
        
        destVc.setValue(customer, forKey: "customer")
    }
    

}

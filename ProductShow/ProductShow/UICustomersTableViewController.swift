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
        tableView.register(nib, forCellReuseIdentifier: "CommonTableViewCell")
        
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
                
                let json = (try! JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers)) as! NSDictionary
                
                self.customers.returnDic = json
                self.tableView.reloadData()
                
                if (self.customers.status == 1){
//                    self.tableView.reloadData()
                    
                }else{
                    let msgString = json.object(forKey: jfmessage) as! String
                    let alertView = UIAlertView(title: "", message: msgString, delegate: nil, cancelButtonTitle: "OK")
                    alertView.show()
                }
            }
        })
    }
    
    // MARK: - Table view delegate
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return customers.customersCount
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CommonTableViewCell", for: indexPath) as! UICommonTableViewCell
        cell.initCell(nil, indexPath: nil, hideRightButtons: true)
        cell.accessButton.isHidden = false
        
        // Configure the cell...
        let customer = customers.customerAtIndex(indexPath.row)
        let linkman = customer?.linkman ?? ""
        let custName = customer?.custName ?? ""
        cell.leftLabel.text = "\(custName) - \(linkman)"
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(UICommonTableViewCell.rowHeight)
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
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
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        let selectedIndexPath = self.tableView.indexPathForSelectedRow!
        let customer = customers.customerAtIndex(selectedIndexPath.row)
        let destVc = segue.destination
        
        destVc.setValue(customer, forKey: "customer")
    }
    

}

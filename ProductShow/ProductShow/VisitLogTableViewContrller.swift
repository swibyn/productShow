//
//  VisitLogTableViewContrller.swift
//  ProductShow
//
//  Created by s on 15/10/28.
//  Copyright © 2015年 zhiwx. All rights reserved.
//

import UIKit

//let dataArray : [[String]] = [[jfcustName,"Name"],[jfaddress,"Address"],[jfarea,"Area"],[jfcity, "City"],[jflinkman, "LinkMan"],[jftel,"TEL"],[jfmobile,"Mobile"],[jffax,"Fax"],[jfbankName,"BankName"],[jfdept,"Dept"],[jfsaler,"Saler"],[jfmemo,"Detail"]]
class CustomerInfoTableViewCell: UITableViewCell {
    
    @IBOutlet var NameLabel: UILabel!
    @IBOutlet var addressLabel: UILabel!
    @IBOutlet var cityLabel: UILabel!
    @IBOutlet var areaLabel: UILabel!
    @IBOutlet var linkmanLabel: UILabel!
    @IBOutlet var telLabel: UILabel!
    @IBOutlet var mobileLabel: UILabel!
    @IBOutlet var deptLabel: UILabel!
    
}

class VisitLogTableViewContrller: UITableViewController {
    var customer: Customer!

    @IBOutlet var logWriteTextView: UITextView!

    @IBAction func logBarButtonAction(sender: UIBarButtonItem) {
        self.logWriteTextView.hidden = false
        self.logWriteTextView.becomeFirstResponder()
    }
    
    override func viewDidLoad() {
        self.logWriteTextView.hidden = true
    }
    
    //MARK: function
    func setCustomerInfo(cell: CustomerInfoTableViewCell){
        cell.NameLabel.text = "Name: \(customer.custName)"
        cell.addressLabel.text = "Address: \(customer.address)"
        cell.cityLabel.text = "City: \(customer.city)"
        cell.areaLabel.text = "Name: \(customer.area)"
        cell.linkmanLabel.text = "Name: \(customer.linkman)"
        cell.telLabel.text = "Name: \(customer.tel)"
        cell.mobileLabel.text = "Name: \(customer.mobile)"
        cell.deptLabel.text = "Name: \(customer.dept)"
    }
    
    
    // MARK: - Table view delegate
    //    var indexPathForAccessoryButtonTappedRow: NSIndexPath?
    //    override func tableView(tableView: UITableView, accessoryButtonTappedForRowWithIndexPath indexPath: NSIndexPath) {
    ////        indexPathForAccessoryButtonTappedRow = indexPath
    //        let detailVC = UICustomerTableViewController.newInstance()
    //        let customer = customers.customerAtIndex(indexPath.row)
    //        detailVC.customer = customer
    //        self.navigationController?.pushViewController(detailVC, animated: true)
    ////        self.presentViewController(detailVC, animated: true, completion: nil)
    //    }
    // MARK: - Table view data source
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 0//customers.customersCount
    }
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath)
        
        // Configure the cell...
//        let customer = customers.customerAtIndex(indexPath.row)
//        let linkman = customer?.linkman ?? ""
//        let custName = customer?.custName ?? ""
//        let textLabel = cell.viewWithTag(100) as? UILabel
//        textLabel?.text = "\(custName) - \(linkman)"
        
        return cell
    }

}

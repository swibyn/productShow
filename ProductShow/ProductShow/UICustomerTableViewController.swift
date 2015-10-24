//
//  UICustomerTableViewController.swift
//  ProductShow
//
//  Created by s on 15/10/24.
//  Copyright © 2015年 gaozgao. All rights reserved.
//

import UIKit

class UICustomerTableViewController: UITableViewController {
    
    var customer : Customer?
    
    let dataArray : [[String]] = [[jfcustName,"Name"],[jfaddress,"Address"],[jfarea,"Area"],[jfcity, "City"],[jflinkman, "LinkMan"],[jftel,"TEL"],[jfmobile,"Mobile"],[jffax,"Fax"],[jfbankName,"BankName"],[jfdept,"Dept"],[jfsaler,"Saler"],[jfmemo,"Detail"]]
    
//    let user = UserInfo.defaultUserInfo().firstUser
    
    //MARK: 初始化一个实例
    static func newInstance()->UICustomerTableViewController{
        return UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("UICustomerTableViewController") as! UICustomerTableViewController
        
    }
    

    //View life
    override func viewDidLoad() {
        self.title = "Customer Detail"
    }
    
    // MARK: - Table view data source
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return dataArray.count
    }
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath)
        
        // Configure the cell...
        let data = dataArray[indexPath.row]
        
        let value = (customer?.stringForKey(data[0])) ?? ""
        
        cell.textLabel?.text = " \(data[1]): \(value)"
        
        return cell
    }
    
    //    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
    //
    //        return tableView.rowHeight
    //    }

}

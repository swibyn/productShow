//
//  UIUserTableViewController.swift
//  ProductShow
//
//  Created by s on 15/10/22.
//  Copyright © 2015年 gaozgao. All rights reserved.
//

import UIKit

class UIUserTableViewController: UITableViewController {
    
    let dataArray = [[jfuname,"Name"],[jftel,"Tel"],[jfmail,"Mail"],[jfweixin, "WeChart"],[jfqq, "QQ"],[jfuserNo,"NO"],[jfdept,"Dept"],[jfrole,"Role"]]
    let user = UserInfo.defaultUserInfo().firstUser
   
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
        
        let value = (user?.stringForKey(data[0])) ?? ""
        
        cell.textLabel?.text = " \(data[1]): \(value)"
        
        return cell
    }
    
//    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
//
//        return tableView.rowHeight
//    }
    
}

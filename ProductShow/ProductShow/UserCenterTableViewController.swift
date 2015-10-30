//
//  UserCenterTableViewController.swift
//  ProductShow
//
//  Created by s on 15/9/7.
//  Copyright (c) 2015年 gaozgao. All rights reserved.
//

import UIKit

class UITableViewCell0 : UITableViewCell {
    
    @IBOutlet var userIconImageView: UIImageView!
    @IBOutlet var userNameLabel: UILabel!
}

class UserCenterTableViewController: UITableViewController {
    
    let cellArray = ["userinfo","Customer","Announcements","My Orders","Modify password"]
    
    @IBAction func signoutBarButtonAction(sender: UIBarButtonItem) {
        UserInfo.defaultUserInfo().signout()
    
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        debugPrint("\(self) \(__FUNCTION__)")
        
        self.title = "User Center"
        self.addFirstPageButton()
        
        let nib = UINib(nibName: "CommonTableViewCell", bundle: nil)
        tableView.registerNib(nib, forCellReuseIdentifier: "CommonTableViewCell")
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        debugPrint("\(self) \(__FUNCTION__)")
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        debugPrint("\(self) \(__FUNCTION__)")
        
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
        return 5
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("cell\(indexPath.row)", forIndexPath: indexPath)
        if indexPath.row == 0{
            let cell0 = cell as! UITableViewCell0
//            debugPrint("userinfo=\(UserInfo.defaultUserInfo().returnDic)")
            let uname = UserInfo.defaultUserInfo().firstUser?.uname
            cell0.userNameLabel.text = uname
        }
        return cell

//        // Configure the cell...
//        if indexPath.row == 0{
//            let cell = tableView.dequeueReusableCellWithIdentifier("cell0", forIndexPath: indexPath)
//            let cell0 = cell as! UITableViewCell0
//            debugPrint("userinfo=\(UserInfo.defaultUserInfo().returnDic)")
//            let uname = UserInfo.defaultUserInfo().firstUser?.uname
//            cell0.userNameLabel.text = uname
//            return cell
//        }else{
//            let cell = tableView.dequeueReusableCellWithIdentifier("CommonTableViewCell", forIndexPath: indexPath) as! UICommonTableViewCell
//            cell.initCell(nil, indexPath: indexPath, hideRightButtons: true)
//            cell.accessButton.hidden = false
//            cell.leftLabel.text = cellArray[indexPath.row]
//            
//            return cell
//        }
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if indexPath.row == 0{
            return 259
            
        }else{
            return CGFloat(UICommonTableViewCell.rowHeight)
        }
        
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
    }

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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

}

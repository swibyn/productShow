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

let kAlertTitle = "Select"
let kStartSynchronization = "Start Synchronization"
let kRestartSynchronization = "Restart Synchronization"
let kCancelSynchronization = "Cancel Synchronization"
let kSynchronizationInfo = "Synchronization Info"

class UserCenterTableViewController: UITableViewController,UIAlertViewDelegate,DataSyncObjectDelegate {
    
    var progressView: UIProgressView?
    var dataSynLabel: UILabel?
    
    @IBAction func signoutBarButtonAction(sender: UIBarButtonItem) {
        UserInfo.defaultUserInfo().signout()
        self.postUserSignOutNotification()
    
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "User Center"
        self.addFirstPageButton()
        
        let nib = UINib(nibName: "CommonTableViewCell", bundle: nil)
        tableView.registerNib(nib, forCellReuseIdentifier: "CommonTableViewCell")
        
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
        return 7
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("cell\(indexPath.row)", forIndexPath: indexPath)
        if indexPath.row == 0{
            let cell0 = cell as! UITableViewCell0
            
            let uname = UserInfo.defaultUserInfo().firstUser?.uname
            cell0.userNameLabel.text = uname
        }else if indexPath.row == 5{
            dataSynLabel = cell.viewWithTag(100) as? UILabel
            progressView = cell.viewWithTag(101) as? UIProgressView
            progressView?.hidden = true
            progressView?.transform = CGAffineTransformMakeScale(1.0,3.0);
            dataSynLabel?.text = "Data Synchronization"
        }
        return cell
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if indexPath.row == 0{
            return 259
            
        }else{
            return CGFloat(UICommonTableViewCell.rowHeight)
        }
        
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.row == 5{ //数据同步
            let dataSyncObj = DataSyncObject.defaultObject()
            let alertView = UIAlertView(title: nil, message: nil, delegate: self, cancelButtonTitle: "Cancel")
            switch dataSyncObj.synstate{
            case .Init,.Canceling,.Canceled,.Finished:
                alertView.addButtonWithTitle(kStartSynchronization)
                alertView.addButtonWithTitle(kRestartSynchronization)
                alertView.addButtonWithTitle(kSynchronizationInfo)
            case .Synchronizing:
                alertView.addButtonWithTitle(kCancelSynchronization)
                alertView.addButtonWithTitle(kRestartSynchronization)
                alertView.addButtonWithTitle(kSynchronizationInfo)
            
            }
            alertView.show()
            
        }
    }
    
    //MARK: UIAlertViewDelegate 
    func alertView(alertView: UIAlertView, clickedButtonAtIndex buttonIndex: Int){

        let SyncObj = DataSyncObject.defaultObject()
        SyncObj.delegate = self
        
        let buttonTitle = alertView.buttonTitleAtIndex(buttonIndex)
        if (buttonTitle == kStartSynchronization){
            SyncObj.start()
        }else if(buttonTitle == kCancelSynchronization){
            SyncObj.cancel()
        }else if(buttonTitle == kRestartSynchronization){
            SyncObj.restart()
        }else if(buttonTitle == kSynchronizationInfo){
            let contents = SyncObj.descriptionForSynced(false, terminator: "<br />")
            let noticeDic = [jftitle: kSynchronizationInfo, jfcontents:contents]
            let notice = Notice(noticeDic: noticeDic)
            let noticeVC = UINoticeViewController.newInstance()
            noticeVC.notice = notice
            self.navigationController?.pushViewController(noticeVC, animated: true)
        }
    }
    
    //MARK: DataSyncObjectDelegate
    func dataSyncObjectDidFinishedSync(dataSyncObject: DataSyncObject) {
        progressView?.hidden = true
        dataSynLabel?.text = dataSyncObject.processDescription
    }
    
    func dataSyncObjectDidStopSync(dataSyncObject: DataSyncObject) {
        progressView?.hidden = true
        dataSynLabel?.text = dataSyncObject.processDescription
    }
    
    func dataSyncObjectDidSyncNewData(dataSyncObject: DataSyncObject) {
        progressView?.hidden = false
        progressView?.progress = dataSyncObject.progress
        dataSynLabel?.text = dataSyncObject.processDescription
    }
    
    func dataSyncSynStateDidChanged(dataSyncObject: DataSyncObject) {
        dataSynLabel?.text = dataSyncObject.processDescription
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

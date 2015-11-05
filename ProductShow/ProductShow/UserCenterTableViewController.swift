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


class UserCenterTableViewController: UITableViewController,UIAlertViewDelegate {
    
//    let cellArray = ["userinfo","Customer","Announcements","My Orders","Modify password"]
    var progressView: UIProgressView?
    var dataSynLabel: UILabel?
    
    @IBAction func signoutBarButtonAction(sender: UIBarButtonItem) {
        UserInfo.defaultUserInfo().signout()
        self.postUserSignOutNotification()
    
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
        return 6
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("cell\(indexPath.row)", forIndexPath: indexPath)
        if indexPath.row == 0{
            let cell0 = cell as! UITableViewCell0
//            debugPrint("userinfo=\(UserInfo.defaultUserInfo().returnDic)")
            let uname = UserInfo.defaultUserInfo().firstUser?.uname
            cell0.userNameLabel.text = uname
        }else if indexPath.row == 5{
            dataSynLabel = cell.viewWithTag(100) as? UILabel
            progressView = cell.viewWithTag(101) as? UIProgressView
            progressView?.hidden = true
            progressView?.transform = CGAffineTransformMakeScale(1.0,3.0);
            let lastSynTime = NSUserDefaults.standardUserDefaults().valueForKey(kLastSynTime) as? String
            if lastSynTime != nil{
                dataSynLabel?.text = "Data Synchronization(\(lastSynTime!))"
            }
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
            if (synstate == 0)||(synstate == 2){
                let alertView = UIAlertView(title: nil, message: "Start Synchronization", delegate: self, cancelButtonTitle: "YES")
                alertView.addButtonWithTitle("NO")
                alertView.show()
            }else{
                
                let alertView = UIAlertView(title: nil, message: "Cancel Synchronization", delegate: self, cancelButtonTitle: "YES")
                alertView.addButtonWithTitle("NO")
                alertView.show()
            }
            
        }
    }
    //MARK: UIAlertViewDelegate 
    func alertView(alertView: UIAlertView, clickedButtonAtIndex buttonIndex: Int){
        let message = alertView.message
        let buttonTitle = alertView.buttonTitleAtIndex(buttonIndex)
        if (message == "Start Synchronization") && (buttonTitle == "YES"){
            GetAllUrlAndProfiles()
        }else if(message == "Cancel Synchronization") && (buttonTitle == "YES"){
            synstate = 2
            self.progressView?.hidden = true
        }
    }
    
    //MARK: 数据同步
    let allUrl = AllCRMUrl()
    let allProFiles = ProductFiles()
    var currentSynIndex = 0
    var failCount = 0
    var synstate = 0 //0: 未开始 1:同步中 2:取消
    func GetAllUrlAndProfiles(){
        WebApi.GetAllUrl { (response, data, error) -> Void in
            if WebApi.isHttpSucceed(response, data: data, error: error){
                
                let json = (try! NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.AllowFragments)) as! NSArray
                self.allUrl.urlArray = json
                
                WebApi.GetAllProFiles({ (response, data, error) -> Void in
                    if WebApi.isHttpSucceed(response, data: data, error: error){
                        let json = (try! NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.AllowFragments)) as! NSDictionary
                        self.allProFiles.returnDic = json
                        self.currentSynIndex = 0
                        self.failCount = 0
                        self.synstate = 1
                        self.SynCrmUrl()
                    }else{
                        let alertView = UIAlertView(title: nil, message: Pleasecheckthenetworkconnection, delegate: nil, cancelButtonTitle: "OK")
                        alertView.show()
                    }
                    
                })
            }else{
                let alertView = UIAlertView(title: nil, message: Pleasecheckthenetworkconnection, delegate: nil, cancelButtonTitle: "OK")
                alertView.show()
            }
        }
    }

    //获取该同步的url并同步数据
    func SynCrmUrl(){
        if synstate == 2{
            progressView?.hidden = true
//            let lastSyntime = NSDate().toString("yyyy-MM-dd HH:mm:ss")
            dataSynLabel?.text = "Data Synchronization canceled"
            return
        }
        progressView?.hidden = false
        progressView?.progress = Float(currentSynIndex) / Float(allUrl.urlCount + allProFiles.filesCount)
        if currentSynIndex < allUrl.urlCount{
            self.dataSynLabel?.text = "Synchronize product data"
            let crmUrl = allUrl.urlAtIndex(currentSynIndex)
            let url = crmUrl?.url
            WebApi.RequestAURL(url!, completedHandler: { (response, data, error) -> Void in
                if WebApi.isHttpSucceed(response, data: data, error: error){
                    NSUserDefaults.standardUserDefaults().setValue(data, forKey: url!)
                    self.currentSynIndex++
                    self.performSelector(Selector("SynCrmUrl"))
                }else{
                    self.currentSynIndex++
                    self.failCount++
                    self.performSelector(Selector("SynCrmUrl"))
                }
            })
            
        }else if currentSynIndex - allUrl.urlCount < allProFiles.filesCount{
            let index = currentSynIndex - allUrl.urlCount
            let filepath = allProFiles.productFileAtIndex(index)?.filePath
            self.dataSynLabel?.text = "File downloading \(filepath!)"
            
                WebApi.GetFile(filepath!, completedHandler: { (response, data, error) -> Void in
                    if WebApi.isHttpSucceed(response, data: data, error: error){
                        self.currentSynIndex++
                        self.performSelector(Selector("SynCrmUrl"))
                    }else{
                        self.currentSynIndex++
                        self.failCount++
                        self.performSelector(Selector("SynCrmUrl"))
                    }
                })
         
        }else{
            progressView?.hidden = true
            let lastSyntime = NSDate().toString("yyyy-MM-dd HH:mm:ss")
            NSUserDefaults.standardUserDefaults().setValue(lastSyntime, forKey: kLastSynTime)
            dataSynLabel?.text = "Data Synchronization(\(lastSyntime))"
        }
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

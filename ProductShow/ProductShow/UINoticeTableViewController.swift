//
//  UINoticeTableViewController.swift
//  ProductShow
//
//  Created by s on 15/10/22.
//  Copyright © 2015年 gaozgao. All rights reserved.
//

import UIKit

class UINoticeTableViewController: UITableViewController {
    
    var notices: Notices?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Announcements"
        
        let nib = UINib(nibName: "CommonTableViewCell", bundle: nil)
        tableView.registerNib(nib, forCellReuseIdentifier: "CommonTableViewCell")
        
        GetNotice()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: api
    func GetNotice(){
        
        WebApi.GetNotice(nil,  completedHandler: { (response, data, error) -> Void in
            if WebApi.isHttpSucceed(response, data: data, error: error){
                
                let json = (try! NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableContainers)) as! NSDictionary
                
                self.notices = Notices(returnDic: json)
                self.tableView.reloadData()
                
                if (self.notices!.status == 1){
                }else{
                    let msgString = self.notices?.message
                    let alertView = UIAlertView(title: "", message: msgString, delegate: nil, cancelButtonTitle: "OK")
                    alertView.show()
                }
            }
        })
    }

    // MARK: - Table view data source
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return notices?.noticesCount ?? 0
    }
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("CommonTableViewCell", forIndexPath: indexPath) as! UICommonTableViewCell
        cell.initCell(nil, indexPath: nil, hideRightButtons: false)
        cell.detailButton.hidden = true
        
        
        // Configure the cell...
        let notice = notices?.noticeAtIndex(indexPath.row)
        cell.leftLabel.text = notice?.title 
        cell.rightLabel.text = notice?.releaseDate
        
        return cell
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return CGFloat(UICommonTableViewCell.rowHeight)
    }
    
    //MARK: - Table view Delegate
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let notice = notices?.noticeAtIndex(indexPath.row)
        let noticeViewController = UINoticeViewController.newInstance()
        noticeViewController.notice = notice
        self.navigationController?.pushViewController(noticeViewController, animated: true)
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
        let notice = notices?.noticeAtIndex(selectedIndexPath.row)
        let destVc = segue.destinationViewController
        
        destVc.setValue(notice, forKey: "notice")
    }


}

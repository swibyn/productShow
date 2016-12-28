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
        tableView.register(nib, forCellReuseIdentifier: "CommonTableViewCell")
        
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
                
                let json = (try! JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers)) as! NSDictionary
                
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
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return notices?.noticesCount ?? 0
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CommonTableViewCell", for: indexPath) as! UICommonTableViewCell
        cell.initCell(nil, indexPath: nil, hideRightButtons: false)
        cell.detailButton.isHidden = true
        
        
        // Configure the cell...
        let notice = notices?.noticeAtIndex(indexPath.row)
        cell.leftLabel.text = notice?.title 
        cell.rightLabel.text = notice?.releaseDate
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(UICommonTableViewCell.rowHeight)
    }
    
    //MARK: - Table view Delegate
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
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
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        let selectedIndexPath = self.tableView.indexPathForSelectedRow!
        let notice = notices?.noticeAtIndex(selectedIndexPath.row)
        let destVc = segue.destination
        
        destVc.setValue(notice, forKey: "notice")
    }


}

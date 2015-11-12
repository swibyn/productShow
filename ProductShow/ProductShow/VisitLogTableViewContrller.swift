//
//  VisitLogTableViewContrller.swift
//  ProductShow
//
//  Created by s on 15/10/28.
//  Copyright © 2015年 zhiwx. All rights reserved.
//

import UIKit


//MARK: - CustomerInfoTableViewCell
class CustomerInfoTableViewCell: UITableViewCell {
    
    var customer: Customer!
    
    @IBOutlet var bgView: UIView!
    @IBOutlet var NameLabel: UILabel!
    @IBOutlet var addressLabel: UILabel!
    @IBOutlet var cityLabel: UILabel!
    @IBOutlet var areaLabel: UILabel!
    @IBOutlet var linkmanLabel: UILabel!
    @IBOutlet var telLabel: UILabel!
    @IBOutlet var mobileLabel: UILabel!
    @IBOutlet var deptLabel: UILabel!
    @IBOutlet var mailLabel: UILabel!
    
    func refreshView(){
        NameLabel.text = "Name: \(customer.custName!)"
        addressLabel.text = "Address: \(customer.address!)"
        cityLabel.text = "City: \(customer.city!)"
        areaLabel.text = "Area: \(customer.area!)"
        linkmanLabel.text = "Linkman: \(customer.linkman!)"
        telLabel.text = "Tel: \(customer.tel!)"
        mobileLabel.text = "Mobile: \(customer.mobile!)"
        deptLabel.text = "Dept: \(customer.dept!)"
        mailLabel.text = "Mail: \(customer.mail!)"
    }
    
    func adjustPosition(){
        
        let centerx =  self.contentView.center.x
        let width = self.contentView.bounds.size.width

        NameLabel.frame.size.width = width
        addressLabel.frame.size.width = width
        linkmanLabel.frame.size.width = width
        cityLabel.frame.size.width = width/2
        areaLabel.frame.size.width = width/2
        mailLabel.frame.size.width = width/2
        
        telLabel.frame.origin.x = centerx
        telLabel.frame.size.width = width/2
        mobileLabel.frame.origin.x = centerx
        mobileLabel.frame.size.width = width/2
        deptLabel.frame.origin.x = centerx
        deptLabel.frame.size.width = width/2
    }
}

//MARK: ConfigureCell
func ConfigureCell(cell: CustomerInfoTableViewCell, customer: Customer){
    cell.customer = customer
    cell.refreshView()
    cell.adjustPosition()
}

//MARK: - VisitLogTableViewContrller
class VisitLogTableViewContrller: UITableViewController,LogEditorViewControllerDelegate{
   
    //MARK: 初始化一个实例
    static func newInstance()->VisitLogTableViewContrller{
        
        let aInstance = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("VisitLogTableViewContrller") as! VisitLogTableViewContrller
        return aInstance
    }


    var customer: Customer!
    var logs: Logs?
    

    //MARK: @IB

    
    //MARK: view life
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let nib = UINib(nibName: "BasicTableViewCell", bundle: nil)
        self.tableView.registerNib(nib, forCellReuseIdentifier: "BasicTableViewCell")
        
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        GetWorkLogOnce()
    }
    
    //MARK: function
    var bFirstIn = true
    func GetWorkLogOnce(){
        if bFirstIn{
            bFirstIn = false
            GetWorkLog(true)
        }
    }
    
    func GetWorkLog(canReadLocal: Bool){
        let uid = UserInfo.defaultUserInfo().firstUser?.uid
        let custId = customer.custId
        WebApi.GetWorkLog(canReadLocal, dic: [jfuid: uid!,jfcustId: custId!]) { (response, data, error) -> Void in
            if WebApi.isHttpSucceed(response, data: data, error: error){
                
                let json = (try! NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableContainers)) as! NSMutableDictionary
                
                self.logs = Logs(returnDic: json)
                self.tableView.reloadData()
                
                if (self.logs!.status == 1){
//                    self.tableView.reloadData()
                    
                }else{
                    let msgString = self.logs?.message// json.objectForKey(jfmessage) as! String
                    let alertView = UIAlertView(title: nil, message: msgString, delegate: nil, cancelButtonTitle: "OK")
                    alertView.show()
                }
            }
        }
    }
    
    func DeleteLogAtIndexPath(indexPath: NSIndexPath,  completion: ((Bool) -> Void)?){
        
        let uid = UserInfo.defaultUserInfo().firstUser?.uid
        let uName = UserInfo.defaultUserInfo().firstUser?.uname
        let logDate = ""// NSDate().toString("yyyy-MM-dd")
        let logDesc = ""//logText!
        let custId = customer?.custId
        let custName = customer?.custName
        
        let log = logs?.logAtIndex(indexPath.row - 1)
        let logId = log?.logId
        let logIdStr = (logId == nil) ? "" : "\(logId!)"
        let caozuo = "del"
        
        let dic = [jfuid: uid!, jfuName: uName!, jflogDate: logDate, jflogDesc: logDesc, jfcustId: custId!, jfcustName: custName!, jflogId: logIdStr, jfcaozuo: caozuo]
        
        WebApi.WriteCustLog(dic, completedHandler: { (response, data, error) -> Void in
            if WebApi.isHttpSucceed(response, data: data, error: error){
                
                let json = (try! NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableContainers)) as! NSDictionary

                let returnDic = ReturnDic(returnDic: json)
                
                if (returnDic.status == 1){
                    
                    completion?(true)
                    
                }else{
                    let message = returnDic.message// json.objectForKey(jfmessage) as! String
                    let alertView = UIAlertView(title: "", message: message, delegate: nil, cancelButtonTitle: "OK")
                    alertView.show()
                    completion?(false)
                }
            }else{
                let alertView = UIAlertView(title: "", message: Pleasecheckthenetworkconnection, delegate: nil, cancelButtonTitle: "OK")
                alertView.show()
                completion?(false)
            }
        })
    }
    
    // MARK: - Table view delegate
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if indexPath.row == 0{
            return 214
        }
        
        return CGFloat(BasicTableViewCell.rowHeight)
    }
    
    
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        if indexPath.row > 0{
            return true
        }
        
        return false
    }
    
    
    
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            
            DeleteLogAtIndexPath(indexPath, completion: { (bDelete) -> Void in
                if bDelete{
                    self.logs?.removeLogAtIndex(indexPath.row - 1)
                    tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
                    self.GetWorkLog(false)
                }else{
                    tableView.reloadRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Automatic)
                }
            })
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }
    }
    
    
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
    
    // MARK: - Table view data source
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        let logsCount = self.logs?.logsCount ?? 0
        return logsCount + 1//customers.customersCount
    }
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        if indexPath.row == 0{
            let cell = tableView.dequeueReusableCellWithIdentifier("cell0", forIndexPath: indexPath) as! CustomerInfoTableViewCell
            ConfigureCell(cell, customer: customer)
            return cell
            
        }else{
            let log = logs?.logAtIndex(indexPath.row - 1)
            let cell = tableView.dequeueReusableCellWithIdentifier("BasicTableViewCell", forIndexPath: indexPath) as! BasicTableViewCell
            let content = log?.logDesc?.stringByReplacingOccurrencesOfString("\n", withString: " ")
            cell.leftLabel.text = content//log?.logContent
            cell.rightLabel.text = log?.logDate
            return cell
            
        }
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.row > 0{
            let log = logs?.logAtIndex(indexPath.row - 1)
            let destVC = LogEditorViewController.newInstance()
            destVC.log = log
            destVC.customer = customer
            destVC.delegate = self
            self.navigationController?.pushViewController(destVC, animated: true)
        }
    }
    
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        let destVc = segue.destinationViewController as! LogEditorViewController
        destVc.customer = customer
        destVc.delegate = self
    }
    
    
    //MARK:LogEditorViewControllerDelegate
    func LogEditorViewControllerSubmitSecceed(logEditorVC: LogEditorViewController) {
        self.GetWorkLog(false)
        self.navigationController?.popViewControllerAnimated(true)
    }
    

}






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
    
    func refreshView(){
        NameLabel.text = "Name: \(customer.custName!)"
        addressLabel.text = "Address: \(customer.address!)"
        cityLabel.text = "City: \(customer.city!)"
        areaLabel.text = "Area: \(customer.area!)"
        linkmanLabel.text = "Link: \(customer.linkman!)"
        telLabel.text = "Tel: \(customer.tel!)"
        mobileLabel.text = "Mobile: \(customer.mobile!)"
        deptLabel.text = "Dept: \(customer.dept!)"
       
    }
    
    func adjustPosition(){
        let x = self.bgView.center.x
        linkmanLabel.frame.origin.x = x
        telLabel.frame.origin.x = x
        mobileLabel.frame.origin.x = x
        deptLabel.frame.origin.x = x
    }
}

//MARK: ConfigureCell
func ConfigureCell(cell: CustomerInfoTableViewCell, customer: Customer){
    cell.customer = customer
    cell.refreshView()
    cell.adjustPosition()
}

//MARK: - VisitLogTableViewContrller
class VisitLogTableViewContrller: UITableViewController,UITextViewDelegate,UIAlertViewDelegate {
   
    var customer: Customer!
    var logs: Logs?
    
    var logWriting = false
    var logTextView: UITextView?

    //MARK: 初始化一个实例
    static func newInstance()->VisitLogTableViewContrller{
        
        let aInstance = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("VisitLogTableViewContrller") as! VisitLogTableViewContrller
        return aInstance
    }


    //MARK: @IB
    @IBOutlet var logBarButtonItem: UIBarButtonItem!
    @IBAction func logBarButtonAction(sender: UIBarButtonItem) {

        logWriting = !logWriting
        if logWriting{
            logBarButtonItem.title = "Submit"
        }else{
//            logTextView?.resignFirstResponder()
            self.view.endEditing(true)
            submitLog()
            logBarButtonItem.title = "Log"
        }
        self.tableView.reloadData()
        
    }
    
    //MARK: view life
    override func viewDidLoad() {
        
        self.GetWorkLog()
    }
    
    //MARK: function
    
    func submitLog(){
        
        let log = self.logTextView?.text.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
        if log!.characters.count > 0{
            let uid = UserInfo.defaultUserInfo().firstUser?.uid
            let uName = UserInfo.defaultUserInfo().firstUser?.uname
            let formatter = NSDateFormatter()
            formatter.dateFormat = "yyyy-MM-dd"
            let logDate = formatter.stringFromDate(NSDate())
            let logContent = log!
            let custId = customer?.custId
            let custName = customer?.custName
            
            let dic = [jfuid: uid!, jfuName: uName!, jflogDate: logDate, jflogContent: logContent, jfcustId: custId!, jfcustName: custName!]
            
            WebApi.WriteCustLog(dic, completedHandler: { (response, data, error) -> Void in
                if WebApi.isHttpSucceed(response, data: data, error: error){
                    
                    let json = (try! NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.AllowFragments)) as! NSDictionary
                    
                    //                debugPrint("\(self) \(__FUNCTION__) json=\(json)")
                    let returnDic = ReturnDic(returnDic: json)
                    
                    if (returnDic.status == 1){
                        let alertView = UIAlertView(title: "Succeed", message: "Submit succeed", delegate: self, cancelButtonTitle: "OK")
                        alertView.show()
                        
                    }else{
                        let message = returnDic.message// json.objectForKey(jfmessage) as! String
                        let alertView = UIAlertView(title: "Error", message: message, delegate: nil, cancelButtonTitle: "OK")
                        alertView.show()
                    }
                }else{
                    let alertView = UIAlertView(title: "Fail", message: "Check the internet connection", delegate: nil, cancelButtonTitle: "OK")
                    alertView.show()
                    
                }
            })
        }
    }
    
    func GetWorkLog(){
        let uid = UserInfo.defaultUserInfo().firstUser?.uid
        WebApi.GetWorkLog([jfuid: uid!]) { (response, data, error) -> Void in
            if WebApi.isHttpSucceed(response, data: data, error: error){
                
                let json = (try! NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.AllowFragments)) as! NSDictionary
                
                self.logs = Logs(returnDic: json)
                
                if (self.logs!.status == 1){
                    self.tableView.reloadData()
                    
                }else{
                    let msgString = self.logs?.message// json.objectForKey(jfmessage) as! String
                    let alertView = UIAlertView(title: "Error", message: msgString, delegate: nil, cancelButtonTitle: "OK")
                    alertView.show()
                }
            }else{
                let alertView = UIAlertView(title: "Fail", message: "Check the internet connection", delegate: nil, cancelButtonTitle: "OK")
                alertView.show()
            }
        }
    }
    
    // MARK: - Table view delegate
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if indexPath.row == 0{
            return logWriting ? 130 : 167
        }
        
        return 130
    }
    
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
            if logWriting{
                let cell = tableView.dequeueReusableCellWithIdentifier("cell1", forIndexPath: indexPath)
                if logWriting{
                    let textView = cell.viewWithTag(100) as! UITextView
                    self.logTextView = textView
                    textView.editable = true
                    textView.text = ""
//                    textView.textContainerInset = UIEdgeInsetsMake(10, 10, 10, 10)
//                    textView.contentInset = UIEdgeInsetsMake(20, 20, 20, 20)
//                    textView.scrollIndicatorInsets  =  UIEdgeInsetsMake(20, 20, 20, 20)
                    textView.font = UIFont.systemFontOfSize(20)
                    textView.becomeFirstResponder()
                    
                }
                return cell
            }else{
                let cell = tableView.dequeueReusableCellWithIdentifier("cell0", forIndexPath: indexPath) as! CustomerInfoTableViewCell
                ConfigureCell(cell, customer: customer)
                return cell
            }
        }else{
            let cell = tableView.dequeueReusableCellWithIdentifier("cell2", forIndexPath: indexPath)
            let textView = cell.viewWithTag(100) as! UITextView
            let log = logs?.logAtIndex(indexPath.row - 1)
            textView.text = "\(log!.logDate!)\n\(log!.logContent!)"
            textView.font = UIFont.systemFontOfSize(20)
//            textView.textContainerInset = UIEdgeInsetsMake(10, 10, 10, 10)
            
            return cell
        }
    }
    
    //MARK: UITextViewDelegate
    func textViewDidEndEditing(textView: UITextView){
        debugPrint("\(self) \(__FUNCTION__)")
//        textView.resignFirstResponder()
    }
    
    //MARK: UIAlertViewDelegate
    func alertView(alertView: UIAlertView, clickedButtonAtIndex buttonIndex: Int){
        let message = alertView.message
        let buttonTitle = alertView.buttonTitleAtIndex(buttonIndex)
        if (message == "Submit succeed") && (buttonTitle == "OK"){
//            self.logTextView?.text = ""
            self.GetWorkLog()
        }
    }
    
    func alertViewCancel(alertView: UIAlertView){
        
    }
}

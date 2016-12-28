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
func ConfigureCell(_ cell: CustomerInfoTableViewCell, customer: Customer){
    cell.customer = customer
    cell.refreshView()
    cell.adjustPosition()
}

//MARK: - VisitLogTableViewContrller
class VisitLogTableViewContrller: UITableViewController,LogEditorViewControllerDelegate{
   
    //MARK: 初始化一个实例
    static func newInstance()->VisitLogTableViewContrller{
        
        let aInstance = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "VisitLogTableViewContrller") as! VisitLogTableViewContrller
        return aInstance
    }


    var customer: Customer!
    var logs: Logs?
    

    //MARK: @IB
    
    @IBAction func CareProductsButtonAction(_ sender: UIButton) {
        let destVc = ProductsTableViewController.newInstance()
        destVc.title = sender.titleLabel?.text
        
        let custId = customer?.custId
        if custId == nil { return }
        WebApi.GetCustomerCare([jfcustId: custId!], completedHandler: { (response, data, error) -> Void in
            
            if WebApi.isHttpSucceed(response, data: data, error: error){
                
                let json = (try! JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers)) as! NSDictionary
                let products = Products(returnDic: json)
                destVc.products = products
                self.navigationController?.pushViewController(destVc, animated: true)
            }
        })
    }
    
    //MARK: view life
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Customer"
        
        let nib = UINib(nibName: "BasicTableViewCell", bundle: nil)
        self.tableView.register(nib, forCellReuseIdentifier: "BasicTableViewCell")
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
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
    
    func GetWorkLog(_ canReadLocal: Bool){
        let uid = UserInfo.defaultUserInfo().firstUser?.uid
        let custId = customer.custId
        WebApi.GetWorkLog(canReadLocal, dic: [jfuid: uid!,jfcustId: custId!]) { (response, data, error) -> Void in
            if WebApi.isHttpSucceed(response, data: data, error: error){
                
                let json = (try! JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers)) as! NSMutableDictionary
                
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
    
    func DeleteLogAtIndexPath(_ indexPath: IndexPath,  completion: ((Bool) -> Void)?){
        
        let uid = UserInfo.defaultUserInfo().firstUser?.uid
        let uName = UserInfo.defaultUserInfo().firstUser?.uname
        let logDate = ""// NSDate().toString("yyyy-MM-dd")
        let logDesc = ""//logText!
        let custId = customer?.custId
        let custName = customer?.custName
        
        let log = logs?.logAtIndex(indexPath.row)
        let logId = log?.logId
        let logIdStr = (logId == nil) ? "" : "\(logId!)"
        let caozuo = "del"
        
        let dic = [jfuid: uid!, jfuName: uName!, jflogDate: logDate, jflogDesc: logDesc, jfcustId: custId!, jfcustName: custName!, jflogId: logIdStr, jfcaozuo: caozuo] as [String : Any]
        
        WebApi.WriteCustLog(dic as NSDictionary, completedHandler: { (response, data, error) -> Void in
            if WebApi.isHttpSucceed(response, data: data, error: error){
                
                let json = (try! JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers)) as! NSDictionary

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
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0{
            if indexPath.row == 0{
                return 214
            }else if indexPath.row == 1{
                return 80
            }
        }
        
        return CGFloat(BasicTableViewCell.rowHeight)
    }
    
    
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        if indexPath.section == 0{
            return false
        }else{
            return true
        }
    }
    
    
    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            
            DeleteLogAtIndexPath(indexPath, completion: { (bDelete) -> Void in
                if bDelete{
                    self.logs?.removeLogAtIndex(indexPath.row)
                    tableView.deleteRows(at: [indexPath], with: .fade)
                    self.GetWorkLog(false)
                }else{
                    tableView.reloadRows(at: [indexPath], with: UITableViewRowAnimation.automatic)
                }
            })
        } else if editingStyle == .insert {
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
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 2
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return section == 0 ? 2 : self.logs?.logsCount ?? 0
//        let logsCount = self.logs?.logsCount ?? 0
//        return logsCount + 2//customers.customersCount
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0{
            if indexPath.row == 0{
                let cell = tableView.dequeueReusableCell(withIdentifier: "cell0", for: indexPath) as! CustomerInfoTableViewCell
                ConfigureCell(cell, customer: customer)
                return cell
            }else{
                let cell = tableView.dequeueReusableCell(withIdentifier: "cell1", for: indexPath)
                return cell
            }
        }else{
            let log = logs?.logAtIndex(indexPath.row)
            let cell = tableView.dequeueReusableCell(withIdentifier: "BasicTableViewCell", for: indexPath) as! BasicTableViewCell
            let content = log?.logDesc?.replacingOccurrences(of: "\n", with: " ")
            cell.leftLabel.text = content//log?.logContent
            cell.rightLabel.text = log?.logDate
            return cell
            
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section > 0{
//            if indexPath.row > 0{
                let log = logs?.logAtIndex(indexPath.row)
                let destVC = LogEditorViewController.newInstance()
                destVC.log = log
                destVC.customer = customer
                destVC.delegate = self
                self.navigationController?.pushViewController(destVC, animated: true)
//            }
        }
    }
    
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "logToEditor"{
            let editorVc = segue.destination as! LogEditorViewController
            editorVc.customer = customer
            editorVc.delegate = self
        }
    }
    
    
    //MARK:LogEditorViewControllerDelegate
    func LogEditorViewControllerSubmitSecceed(_ logEditorVC: LogEditorViewController) {
        self.GetWorkLog(false)
        _ = self.navigationController?.popViewController(animated: true)
    }
    

}






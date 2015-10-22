//
//  UIVisitLogViewController.swift
//  ProductShow
//
//  Created by s on 15/10/22.
//  Copyright © 2015年 gaozgao. All rights reserved.
//

import UIKit


class UIVisitLogViewController: UIViewController,UIAlertViewDelegate {
    
    var customer: Customer?

    @IBOutlet var logTextView: UITextView!
    @IBAction func submitButtonAction(sender: UIBarButtonItem) {
        let log = logTextView.text.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
        if log.characters.count > 0{
            let uid = UserInfo.defaultUserInfo().firstUser?.uid
            let uName = UserInfo.defaultUserInfo().firstUser?.uname
            let formatter = NSDateFormatter()
            formatter.dateFormat = "yyyy-MM-dd"
            let logDate = formatter.stringFromDate(NSDate())
            let logContent = log
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
                }
            )
            
        }
        
    }
    
    //MARK: UIAlertViewDelegate
    func alertView(alertView: UIAlertView, clickedButtonAtIndex buttonIndex: Int){
        let message = alertView.message
        let buttonTitle = alertView.buttonTitleAtIndex(buttonIndex)
        if (message == "Submit succeed") && (buttonTitle == "OK"){
            self.navigationController?.popViewControllerAnimated(true)
        }
    }
    
    func alertViewCancel(alertView: UIAlertView){
        
    }
    
}













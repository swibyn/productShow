//
//  PasswordViewController.swift
//  ProductShow
//
//  Created by s on 15/10/28.
//  Copyright © 2015年 zhiwx. All rights reserved.
//

import UIKit

class PasswordViewController: UIViewController, UIAlertViewDelegate {

    @IBOutlet var oldPasswordTextField: UITextField!
    @IBOutlet var newPasswordTextField1: UITextField!
    @IBOutlet var newPasswordTextField2: UITextField!
    @IBOutlet var submitButton: UIButton!
    
    @IBAction func submitButtonAction(sender: UIButton) {
//        oldPasswordTextField.resignFirstResponder()
//        newPasswordTextField1.resignFirstResponder()
//        newPasswordTextField2.resignFirstResponder()
        self.view.endEditing(true)
        ChangePwd()
    }
    
    //MARK: view life
    override func viewDidLoad() {
        submitButton.layer.masksToBounds = true
        submitButton.layer.cornerRadius = 5
    }
    
    override func viewWillAppear(animated: Bool) {
        self.navigationController?.navigationBarHidden = true
        self.addObserverKeyboardNotification()
    }
    
    
    override func viewDidAppear(animated: Bool) {
        
    }
    
    
    override func viewWillDisappear(animated: Bool) {
        self.removeObserverKeyboardNotification()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    //MARK: KeyboardNotification
    override func handleKeyboardWillShow(paramNotification: NSNotification) {
        
        UIView.animateWithDuration(1) { () -> Void in
            self.view.frame.origin.y = -200
        }
        
    }
    
    override func handleKeyboardWillHide(paramNotification: NSNotification) {
        UIView.animateWithDuration(1.0) { () -> Void in
            self.view.frame.origin.y = 0
        }
    }
    
    //MARK: function
    func ChangePwd(){
        if newPasswordTextField1.text == newPasswordTextField2.text{
            let uid = UserInfo.defaultUserInfo().firstUser?.uid
            let pwd = oldPasswordTextField.text?.md5
            let newPwd = newPasswordTextField1.text?.md5
            WebApi.ChangePwd([jfuid: uid!, jfpwd: pwd!, jfnewPwd: newPwd!]) { (response, data, error) -> Void in
                if WebApi.isHttpSucceed(response, data: data, error: error){
                    
                    let json = (try! NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.AllowFragments)) as! NSDictionary
                    
                    let returnDic = ReturnDic(returnDic: json)
                    
                    if (returnDic.status == 1){
                        let alertView = UIAlertView(title: nil, message: "Password changed", delegate: self, cancelButtonTitle: "OK")
                        
                        alertView.show()
                        
                    }else{
                        let msgString = returnDic.message
                        let alertView = UIAlertView(title: "Error", message: msgString, delegate: nil, cancelButtonTitle: "OK")
                        alertView.show()
                    }
                }else{
                    let alertView = UIAlertView(title: "Fail", message: "Check the internet connection", delegate: nil, cancelButtonTitle: "OK")
                    alertView.show()
                }
            }
        }else{
            let alertview = UIAlertView(title: nil, message: "The two new password is not same", delegate: nil, cancelButtonTitle: "OK")
            alertview.show()
        }
    }
    
    //MARK: UIAlertViewDelegate
    func alertView(alertView: UIAlertView, clickedButtonAtIndex buttonIndex: Int) {
        
        let message = alertView.message
        if message == "Password changed"{
            self.navigationController?.popViewControllerAnimated(true)
        }
        
    }
    
}

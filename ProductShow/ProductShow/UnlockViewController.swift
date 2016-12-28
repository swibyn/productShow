//
//  UnlockViewController.swift
//  ProductShow
//
//  Created by s on 15/11/11.
//  Copyright © 2015年 zhiwx. All rights reserved.
//

import UIKit

class UnlockViewController: UIViewController {
    
    @IBOutlet var centerView: UIView!
    @IBOutlet var passwordTextField: UITextField!
    @IBOutlet var unlockButton: UIButton!
    
    @IBAction func unlockButtonAction(_ sender: UIButton) {
        let passswordEnter = passwordTextField.text
        let pwd = UserInfo.defaultUserInfo().loginInfo?.pwd
        if passswordEnter == pwd{
            _ = self.navigationController?.popViewController(animated: true)
        }else{
            let alertView = UIAlertView(title: nil, message: "Error password", delegate: nil, cancelButtonTitle: "OK")
            alertView.show()
            passwordTextField.text = ""
        }
    }
    
    //MARK: view life
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.addKeyboardNotificationObserver()
        self.navigationItem.hidesBackButton = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        unlockButton.layer.masksToBounds = true
        unlockButton.layer.cornerRadius = 5
        centerView.layer.masksToBounds = true
        centerView.layer.cornerRadius = 5
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.removeKeyboardNotificationObserver()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    //MARK: KeyboardNotification
    override func handleKeyboardWillShow(_ paramNotification: Notification) {
        super.handleKeyboardWillShow(paramNotification)
        
        UIView.animate(withDuration: 1, animations: { () -> Void in
            self.view.frame.origin.y = -150
        }) 
    }
    
    override func handleKeyboardWillHide(_ paramNotification: Notification) {
        super.handleKeyboardWillHide(paramNotification)
        UIView.animate(withDuration: 1.0, animations: { () -> Void in
            self.view.frame.origin.y = 0
        }) 
    }
    
    //MARK: function
    
    
    

}

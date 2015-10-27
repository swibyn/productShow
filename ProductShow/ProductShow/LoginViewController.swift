//
//  LoginViewController.swift
//  ProductShow
//
//  Created by s on 15/9/6.
//  Copyright (c) 2015年 gaozgao. All rights reserved.
//

import UIKit

protocol LoginViewControllerDelegate : NSObjectProtocol{
    func loginViewController(loginViewController: LoginViewController, userInfo: AnyObject?)
}


class LoginViewController: UIViewController {
    
    //MARK: 初始化一个实例
    static func newInstance()->LoginViewController{
        
        let aInstance = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("LoginViewController") as! LoginViewController
        return aInstance
    }

    //MARK: delegate
    var delegate: LoginViewControllerDelegate?
    
    //MARK: @IBOutlet
    @IBOutlet var eqNoAllowHintLabel: UILabel!
    @IBOutlet var usernameTextField: UITextField!
    @IBOutlet var passwordTextField: UITextField!
    @IBOutlet var loginButton: UIButton!
    
    //MARK: @IBAction
    @IBAction func loginButtonAction(sender: UIButton) {
        //如果登录成功，则交给代理处理
        let username = usernameTextField.text!
        let password = passwordTextField.text!.md5 // (passwordTextField.text as NSString).md5()
        
        
        WebApi.Login([jfusername : username, jfpwd : password], completedHandler: { (response, data, error) -> Void in
            if WebApi.isHttpSucceed(response, data: data, error: error){
                
                let json = (try! NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.AllowFragments)) as! NSDictionary
//                debugPrint("\(self) \(__FUNCTION__) json=\(json)")
                
                UserInfo.defaultUserInfo().returnDic = json
                if (UserInfo.defaultUserInfo().status == 1){
                    //登录成功
                    self.delegate?.loginViewController(self, userInfo: json)
                    NSUserDefaults.standardUserDefaults().setValue(username, forKey: jfusername)
                    NSUserDefaults.standardUserDefaults().setValue(self.passwordTextField.text!, forKey: jfpwd)
                }else{
                    let msgString = json.objectForKey(jfmessage) as! String
                    let alertView = UIAlertView(title: "Error", message: msgString, delegate: nil, cancelButtonTitle: "OK")
                    alertView.show()
                    self.SendEquipCode()
                }
            }else{
                let alertView = UIAlertView(title: "Fail", message: "Check the internet connection", delegate: nil, cancelButtonTitle: "OK")
                alertView.show()
            }
        })
    }
    

    
    //MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.title = "Sign In"
        
        //显示登录名
        let username = NSUserDefaults.standardUserDefaults().valueForKey(jfusername) as? String
        let pwd = NSUserDefaults.standardUserDefaults().valueForKey(jfpwd) as? String
        self.usernameTextField.text = username ?? ""
        self.passwordTextField.text = pwd ?? ""
        
        //loginbutton设置成圆角 //        self.loginButton.buttonType = UIButtonType.RoundedRect
        self.loginButton.layer.masksToBounds = true
        self.loginButton.layer.cornerRadius = 5
        
        
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
            self.view.frame.origin.y = -250
        }
        
    }

    override func handleKeyboardWillHide(paramNotification: NSNotification) {
        UIView.animateWithDuration(1.0) { () -> Void in
            self.view.frame.origin.y = 0
        }
    }
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
     
    }
    
    
    override func shouldPerformSegueWithIdentifier(identifier: String, sender: AnyObject?) -> Bool {
        return true
    }
    
    
    override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        return UIInterfaceOrientationMask.Landscape
    }
    
    //MARK: 发送设备编码
    func SendEquipCode(){
        
        //检查设备是否允许访问
        let eqNo = UIDevice.currentDevice().advertisingIdentifier.UUIDString
        let eqName = UIDevice.currentDevice().name
        WebApi.SendEquipCode([jfeqName:eqName],  completedHandler: { (response, data, error) -> Void in
            if WebApi.isHttpSucceed(response, data: data, error: error){
                
                let json = (try! NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.AllowFragments)) as! NSDictionary
                let returnDic = ReturnDic(returnDic: json)
                
                let status = returnDic.status
                if status == 0{
                    let alertView = UIAlertView(title: "Hint", message: "Equipment forbidden，contact the admin\nNO：\(eqNo)\nName：\(eqName)", delegate: nil, cancelButtonTitle: "OK")
                    alertView.show()
                    
                }
                
            }
        })

    }


}

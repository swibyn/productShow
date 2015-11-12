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
        Login()
    }
    
    //MARK: funtion
    func Login(){
        //如果登录成功，则交给代理处理
        let username = usernameTextField.text!
        let password = passwordTextField.text!.md5
        
        WebApi.Login([jfusername : username, jfpwd : password], completedHandler: { (response, data, error) -> Void in
            if WebApi.isHttpSucceed(response, data: data, error: error){
                
                let json = (try? NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableContainers)) as? NSDictionary
                //                debugPrint("\(self) \(__FUNCTION__) json=\(json)")
                
                UserInfo.defaultUserInfo().returnDic = json
                if (UserInfo.defaultUserInfo().status == 1){
                    //登录成功
                    let loginInfo = LoginInfo(username: username, pwd: self.passwordTextField.text!)
                    UserInfo.defaultUserInfo().loginInfo = loginInfo
                    
                    self.delegate?.loginViewController(self, userInfo: json)
                    
                    self.postLoginSucceedNotification()
                    
                }else{
                    let msgString = json?.objectForKey(jfmessage) as? String
                    let alertView = UIAlertView(title: "Error", message: msgString ?? "", delegate: nil, cancelButtonTitle: "OK")
                    alertView.show()
                    self.SendEquipCode()
                }
            }else{
                //网络不通或服务器问题则根据本地的来判断
                let localLoginInfo = UserInfo.defaultUserInfo().loginInfo
                let localusername = localLoginInfo?.username
                let localpwd = localLoginInfo?.pwd
                if (username == localusername) && (self.passwordTextField.text! == localpwd){
                    UserInfo.defaultUserInfo().readLocalReturnData()
                    self.delegate?.loginViewController(self, userInfo: nil)
                    self.postLoginSucceedNotification()
                }else{
                    let alertView = UIAlertView(title: nil, message: Pleasecheckthenetworkconnection, delegate: nil, cancelButtonTitle: "OK")
                    alertView.show()
                
                }
            }
        })
    }
    
    //MARK: view Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.title = "Sign In"
        
        //显示登录名
        let username = UserInfo.defaultUserInfo().loginInfo?.username
        self.usernameTextField.text = username ?? ""
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.addKeyboardNotificationObserver()
    }
    
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        //loginbutton设置成圆角
        self.loginButton.layer.masksToBounds = true
        self.loginButton.layer.cornerRadius = 5
        
    }
    

    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        self.removeKeyboardNotificationObserver()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    //MARK: KeyboardNotification
    override func handleKeyboardWillShow(paramNotification: NSNotification) {
        super.handleKeyboardWillShow(paramNotification)
        UIView.animateWithDuration(1) { () -> Void in
            self.view.frame.origin.y = -250
        }
        
    }

    override func handleKeyboardWillHide(paramNotification: NSNotification) {
        super.handleKeyboardWillHide(paramNotification)
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
    
    //MARK: 支持设备方向
    override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        return UIInterfaceOrientationMask.Landscape
    }
    
    //MARK: 发送设备编码
    func SendEquipCode(){
        
        //检查设备是否允许访问
        let eqNo = UIDevice.currentDevice().advertisingIdentifier.UUIDString
        let eqName = UIDevice.currentDevice().name
        WebApi.SendEquipCode(nil,  completedHandler: { (response, data, error) -> Void in
            if WebApi.isHttpSucceed(response, data: data, error: error){
                
                let json = (try! NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableContainers)) as! NSDictionary
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

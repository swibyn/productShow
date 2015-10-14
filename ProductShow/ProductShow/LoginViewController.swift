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
    static func shareInstance()->LoginViewController{
        
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
        let username = usernameTextField.text
        let password = passwordTextField.text.md5 // (passwordTextField.text as NSString).md5()
        
        let authcodeobjopt: AnyObject? = Global.userInfo?.objectForKey(jfauthcode)
        
        WebApi.Login([jfusername : username, jfpwd : password], completedHandler: { (response, data, error) -> Void in
            if WebApi.isHttpSucceed(response, data: data, error: error){
                
                let json = NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.AllowFragments, error: nil) as! NSDictionary
                debugPrintln("\(self) \(__FUNCTION__) json=\(json)")
//                let statusobj: AnyObject? = json.objectForKey(jfstatus)
//                let statusString = statusobj as! Int
                let statusInt = json.objectForKey(jfstatus) as! Int
                if (statusInt == 1){
                    //登录成功
                    Global.userInfo = NSMutableDictionary(dictionary: json)
                    self.delegate?.loginViewController(self, userInfo: json)
                }else{
                    let msgString = json.objectForKey(jfmessage) as! String
                    let alertView = UIAlertView(title: "登录失败", message: msgString, delegate: nil, cancelButtonTitle: "OK")
                    alertView.show()
                }
            }
        })
    }
    
    //MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.title = "登录"
        
    }
    
    override func viewDidAppear(animated: Bool) {
        //检查设备是否允许访问
        let eqNo = UIDevice.currentDevice().identifierForVendor.UUIDString
        let eqName = UIDevice.currentDevice().name
        WebApi.SendEquipCode([jfeqName:eqName],  completedHandler: { (response, data, error) -> Void in
            if WebApi.isHttpSucceed(response, data: data, error: error){
                
                let json = NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.AllowFragments, error: nil) as! NSDictionary
//                debugPrintln("\(__FILE__) \(__FUNCTION__) json=\(json)")
                let statusobj: AnyObject? = json.objectForKey(jfstatus)
                let statusString = statusobj as! Int
                if (statusString == 0){
                    self.eqNoAllowHintLabel.hidden = false
                    self.eqNoAllowHintLabel.text = "设备未允许，请联系管理员。\n设备编码：\(eqNo)\n设备名称：\(eqName)"
                    self.loginButton.enabled = false
                }
                
            }
        })

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        self.navigationController?.navigationBarHidden = true
    }
    
    deinit{
        println("\(self) deinit")
    }

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
     
    }
    
    
    override func shouldPerformSegueWithIdentifier(identifier: String?, sender: AnyObject?) -> Bool {
        return true
    }
    
    


}

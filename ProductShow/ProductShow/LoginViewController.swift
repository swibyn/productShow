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

    var delegate: LoginViewControllerDelegate?
    
    //MARK: @IBAction
    @IBAction func loginButtonAction(sender: UIButton) {
        //如果登录成功，则交给代理处理
        UserCenterTableViewController.signIn = true
        delegate?.loginViewController(self, userInfo: nil)
    }
    
    //MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.title = "登录"
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
    //MARK: 初始化一个实例
    static func shareInstance()->LoginViewController{
        
        let aInstance = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("LoginViewController") as! LoginViewController
        return aInstance
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

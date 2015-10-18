//
//  HomeTabBarViewController.swift
//  ProductShow
//
//  Created by s on 15/9/6.
//  Copyright (c) 2015年 gaozgao. All rights reserved.
//

import UIKit

class HomeTabBarViewController: UITabBarController,FirstPageViewControllerDelegate/*,LoginViewControllerDelegate*/ {

    override func viewDidLoad() {
        super.viewDidLoad()

        self.addUserSignOutNotificationObserver()
    }
    
    override func viewDidAppear(animated: Bool) {
        //如果还没登录，则弹出登录界面
        let bsignin = UserInfo.defaultUserInfo().status == 1

        if !bsignin{
            self.presentFirstPageVC(UIModalTransitionStyle.FlipHorizontal, animated: false, completion: nil)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    deinit{
        self.removeUserSignOutNotificationObserver()
    }
    
    
    //MARK: 监听注销消息通知
    func addUserSignOutNotificationObserver(){
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("handleUserSignOutNotification"), name: kUserSignOutNotification, object: nil)
    }
    
    func removeUserSignOutNotificationObserver(){
        NSNotificationCenter.defaultCenter().removeObserver(self, name: kUserSignOutNotification, object: nil)
    }
    
    func handleUserSignOutNotification(){
        self.presentFirstPageVC(UIModalTransitionStyle.FlipHorizontal, animated: false, completion: nil)
    }
    
    //MARK: 弹出首页
    func presentFirstPageVC(modalTransitionStyle: UIModalTransitionStyle, animated: Bool, completion:(()->Void)?){
        let firstPageVC = FirstPageViewController.shareInstance()
        firstPageVC.delegate = self
        firstPageVC.modalTransitionStyle = modalTransitionStyle
        self.presentViewController(firstPageVC, animated: animated, completion: nil)
    }
    
    func presentFirstPageVC(){
        presentFirstPageVC(UIModalTransitionStyle.FlipHorizontal, animated: true, completion: nil)
    }
    
//    func presentLoginVC(modalTransitionStyle: UIModalTransitionStyle,animated: Bool, completion:(()->Void)?){
//        let loginVC = LoginViewController.shareInstance()
//        loginVC.modalTransitionStyle = modalTransitionStyle
//        loginVC.delegate = self
//        self.presentViewController(loginVC, animated: animated, completion: completion)
//    }
    
    // MARK: FirstPageViewControllerDelegate
    func firstPageViewController(firstPageViewController: FirstPageViewController, didClickButton button: UIButton) {
        for vc in self.viewControllers! {
            print("vc.title=\(vc.tabBarItem.title)  button.title=\(button.titleForState(UIControlState.Normal))")
            if vc.tabBarItem.title == button.titleForState(UIControlState.Normal){
                self.selectedViewController = vc
                break
            }
        }
    }
    
    
    // MARK: LoginViewControllerDelegate
//    func loginViewController(loginViewController: LoginViewController, userInfo: AnyObject?) {
//        loginViewController.dismissViewControllerAnimated(true, completion: nil)
//        
//    }


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

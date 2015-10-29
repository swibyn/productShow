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
    
    override func viewWillAppear(animated: Bool) {
        debugPrint("\(self) \(__FUNCTION__)")
//        changeTabBarIfNever1()
    }
    override func viewDidAppear(animated: Bool) {
        debugPrint("\(self) \(__FUNCTION__)")
        //如果还没登录，则弹出登录界面
        let bsignin = UserInfo.defaultUserInfo().status == 1

        if !bsignin{
            self.presentFirstPageVC(UIModalTransitionStyle.FlipHorizontal, animated: false, completion: nil)
        }
        changeTabBarIfNever1()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    deinit{
        self.removeUserSignOutNotificationObserver()
    }
    //MARK: 使tabbaritem进入使用状态
    var bever = false
//    func changeTabBarIfNever(){
//        if !bever{
//            bever = true
//            for i in 0..<self.viewControllers!.count{
//                self.selectedIndex = i
//            }
//        }
//    }
    
    func changeTabBarIfNever1(){
        if !bever{
            bever = true
            for i in 0..<self.tabBar.items!.count{
                resetTabBar(self.tabBar.items![i])
            }
        }
    }
    
    func resetTabBar(tabBarItem: UITabBarItem){
//        debugPrint("\(self) \(__FUNCTION__)")
        let old = tabBarItem.imageInsets
        tabBarItem.imageInsets = UIEdgeInsets(top: old.top + 5, left: old.left - 7, bottom: old.bottom - 10, right: old.right - 8)
        tabBarItem.image? = tabBarItem.image!.imageWithRenderingMode(UIImageRenderingMode.AlwaysOriginal)
        
        tabBarItem.selectedImage? = tabBarItem.selectedImage!.imageWithRenderingMode(UIImageRenderingMode.AlwaysOriginal)
        tabBarItem.titlePositionAdjustment = UIOffset(horizontal: 0, vertical: 20)
        //        print("\(self) \(__FUNCTION__)")
        //        print("\(self)  tabBarItem.imageInsets=\(self.tabBarItem.imageInsets)")
        
    }
    
    override func handleUserSignOutNotification() {
        self.presentFirstPageVC(UIModalTransitionStyle.FlipHorizontal, animated: false, completion: nil)
    }
    
    //MARK: 弹出首页
    func presentFirstPageVC(modalTransitionStyle: UIModalTransitionStyle, animated: Bool, completion:(()->Void)?){
        let firstPageVC = FirstPageViewController.newInstance()
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
        
//        let title = button.titleForState(.Normal)
//        switch title!{
//        case "Hot Products":
//            self.selectedIndex = 0
//        case "Product Categories":
//            self.selectedIndex = 1
//        case "Search":
//            self.selectedIndex = 2
//        case "User Center":
//            self.selectedIndex = 3
//        default:
//            self.selectedIndex = 0
//        }
        
        for vc in self.viewControllers! {
//            debugPrint("vc.title=\(vc.title) tabBarItem.title=\(vc.tabBarItem.title)  button.title=\(button.titleForState(UIControlState.Normal))")
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
    //MARK: 支持设备方向
    override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        return UIInterfaceOrientationMask.Landscape
    }

}

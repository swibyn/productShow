//
//  HomeTabBarViewController.swift
//  ProductShow
//
//  Created by s on 15/9/6.
//  Copyright (c) 2015年 gaozgao. All rights reserved.
//

import UIKit

class HomeTabBarViewController: UITabBarController, FirstPageViewControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        debugPrint("\(self) \(__FUNCTION__)")

        self.addUserSignOutNotificationObserver()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        debugPrint("\(self) \(__FUNCTION__)")
        
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        debugPrint("\(self) \(__FUNCTION__)")
        
        adjustTabBarItems()
        
        
        //如果还没登录，则弹出登录界面
        let bsignin = UserInfo.defaultUserInfo().status == 1

        if !bsignin{
//            self.performSelectorOnMainThread(Selector("presentFirstPageVC"), withObject: nil, waitUntilDone: false)
            self.presentFirstPageVC(UIModalTransitionStyle.FlipHorizontal, animated: false, completion: nil)
        }

    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        debugPrint("\(self) \(__FUNCTION__)")
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        debugPrint("\(self) \(__FUNCTION__)")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    deinit{
        self.removeUserSignOutNotificationObserver()
    }
    //MARK: 使tabbaritem进入使用状态
//    var bselected = false
//    func selectedTabBarIfNever(){
//        if !bselected{
//            bselected = true
//            for i in 0..<self.viewControllers!.count{
//                self.selectedIndex = i
//            }
//        }
//    }
    
    var bchangeTabBar = false
    func adjustTabBarItems(){
        if !bchangeTabBar{
            bchangeTabBar = true
            self.tabBar.tintColor = UIColor.whiteColor()
            for i in 0..<self.tabBar.items!.count{
                adjustTabBarItem(self.tabBar.items![i])
            }
        }
    }
    
    //往下面挪一点
    func adjustTabBarItem(tabBarItem: UITabBarItem){
        debugPrint("\(self) \(__FUNCTION__)")
        let old = tabBarItem.imageInsets
//        tabBarItem.imageInsets = UIEdgeInsets(top: old.top + 5, left: old.left - 7, bottom: old.bottom - 10, right: old.right - 8)
        let offset: CGFloat = 5
        
        tabBarItem.imageInsets = UIEdgeInsets(top: old.top + offset, left: old.left, bottom: old.bottom - offset, right: old.right)

//        tabBarItem.image? = tabBarItem.image!.imageWithRenderingMode(UIImageRenderingMode.AlwaysOriginal)
        
//        tabBarItem.selectedImage? = tabBarItem.selectedImage!.imageWithRenderingMode(UIImageRenderingMode.AlwaysOriginal)
        tabBarItem.titlePositionAdjustment = UIOffset(horizontal: 0, vertical: 20)
        //        print("\(self) \(__FUNCTION__)")
//        print("\(self)  tabBarItem.imageInsets=\(self.tabBarItem.imageInsets)")
        
    }
    
    
    //MARK: 消息通知
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
    
    
    // MARK: FirstPageViewControllerDelegate
    func firstPageViewController(firstPageViewController: FirstPageViewController, didClickButton button: UIButton) {
        
        for vc in self.viewControllers! {
            //            debugPrint("vc.title=\(vc.title) tabBarItem.title=\(vc.tabBarItem.title)  button.title=\(button.titleForState(UIControlState.Normal))")
            if vc.tabBarItem.title == button.titleForState(UIControlState.Normal){
                self.selectedViewController = vc
                
                break
            }
        }

        firstPageViewController.dismissViewControllerAnimated(true, completion: nil)
    }
    


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

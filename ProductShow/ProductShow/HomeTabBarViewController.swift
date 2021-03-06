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
        
        self.addUserSignOutNotificationObserver()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        adjustTabBarItems()
        
        //如果还没登录，则弹出登录界面
        let bsignin = UserInfo.defaultUserInfo().status == 1

        if !bsignin{
            self.presentFirstPageVC(UIModalTransitionStyle.flipHorizontal, animated: false, completion: nil)
        }

    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    deinit{
        self.removeUserSignOutNotificationObserver()
    }
    
    //MARK: function
    var bchangeTabBar = false
    func adjustTabBarItems(){
        if !bchangeTabBar{
            bchangeTabBar = true
            self.tabBar.tintColor = UIColor.white
            for i in 0..<self.tabBar.items!.count{
                adjustTabBarItem(self.tabBar.items![i])
            }
        }
    }
    
    //往下面挪一点
    func adjustTabBarItem(_ tabBarItem: UITabBarItem){
        let old = tabBarItem.imageInsets
        let offset: CGFloat = 5
        
        tabBarItem.imageInsets = UIEdgeInsets(top: old.top + offset, left: old.left, bottom: old.bottom - offset, right: old.right)

        tabBarItem.titlePositionAdjustment = UIOffset(horizontal: 0, vertical: 20)

    }
    
    
    //MARK: 消息通知
    
    override func handleUserSignOutNotification(_ paramNotification: Notification) {
        super.handleUserSignOutNotification(paramNotification)
        self.presentFirstPageVC(UIModalTransitionStyle.flipHorizontal, animated: false, completion: nil)
    }
    
    //MARK: 弹出首页
    func presentFirstPageVC(_ modalTransitionStyle: UIModalTransitionStyle, animated: Bool, completion:(()->Void)?){
        let firstPageVC = FirstPageViewController.newInstance()
        firstPageVC.delegate = self
        firstPageVC.modalTransitionStyle = modalTransitionStyle
        self.present(firstPageVC, animated: animated, completion: nil)
    }
    
    func presentFirstPageVC(){
        presentFirstPageVC(UIModalTransitionStyle.flipHorizontal, animated: true, completion: nil)
    }
    
    
    // MARK: FirstPageViewControllerDelegate
    func firstPageViewController(_ firstPageViewController: FirstPageViewController, didClickButton button: UIButton) {
        
        for vc in self.viewControllers! {
            if vc.tabBarItem.title == button.title(for: UIControlState()){
                self.selectedViewController = vc
                
                break
            }
        }

        firstPageViewController.dismiss(animated: true, completion: nil)
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
    override var supportedInterfaceOrientations : UIInterfaceOrientationMask {
        return UIInterfaceOrientationMask.landscape
    }

}

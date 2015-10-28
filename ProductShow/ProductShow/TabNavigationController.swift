//
//  TabNavigationController.swift
//  ProductShow
//
//  Created by s on 15/9/7.
//  Copyright (c) 2015年 gaozgao. All rights reserved.
//

import UIKit

class TabNavigationController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.navigationBar.tintColor = UIColor.whiteColor()
//        resetTabBar()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
//        self.navigationController?.navigationBarHidden = true
//        self.title = self.topViewController.title ?? "未命名"
//        self.tabBarItem.title = self.viewControllers[0].title
//        self.navigationItem.backBarButtonItem?.tintColor = UIColor.whiteColor()
    }
    override func viewWillDisappear(animated: Bool) {
//        self.navigationController?.navigationBarHidden = false
    }
    
    
    func resetTabBar(){
        let old = self.tabBarItem.imageInsets
        self.tabBarItem.imageInsets = UIEdgeInsets(top: old.top + 5, left: old.left - 7, bottom: old.bottom - 10, right: old.right - 8)
        self.tabBarItem.image? = self.tabBarItem.image!.imageWithRenderingMode(UIImageRenderingMode.AlwaysOriginal)
        
        self.tabBarItem.selectedImage? = self.tabBarItem.selectedImage!.imageWithRenderingMode(UIImageRenderingMode.AlwaysOriginal)
        self.tabBarItem.titlePositionAdjustment = UIOffset(horizontal: 0, vertical: 20)
//        print("\(self) \(__FUNCTION__)")
        //        print("\(self)  tabBarItem.imageInsets=\(self.tabBarItem.imageInsets)")
        
    }

    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

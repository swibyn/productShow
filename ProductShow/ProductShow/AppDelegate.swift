//
//  AppDelegate.swift
//  ProductShow
//
//  Created by s on 15/10/15.
//  Copyright (c) 2015年 gaozgao. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
//        adjustTabBarInTabBarController()
        return true
    }
    
    func adjustTabBarInTabBarController(){
        let tabbarController = self.window?.rootViewController as! UITabBarController
        let tabBar = tabbarController.tabBar
        
        for item in tabBar.items!{
            resetTabBar(item)
        }
    }
    func resetTabBar(tabBarItem: UITabBarItem){
        debugPrint("\(self) \(__FUNCTION__)")
        let old = tabBarItem.imageInsets
        //        tabBarItem.imageInsets = UIEdgeInsets(top: old.top + 5, left: old.left - 7, bottom: old.bottom - 10, right: old.right - 8)
        tabBarItem.imageInsets = UIEdgeInsets(top: old.top + 8, left: old.left - 8, bottom: old.bottom - 8, right: old.right - 8)
        
        tabBarItem.image? = tabBarItem.image!.imageWithRenderingMode(UIImageRenderingMode.AlwaysOriginal)
        
        tabBarItem.selectedImage? = tabBarItem.selectedImage!.imageWithRenderingMode(UIImageRenderingMode.AlwaysOriginal)
        tabBarItem.titlePositionAdjustment = UIOffset(horizontal: 0, vertical: 20)
        //        print("\(self) \(__FUNCTION__)")
//        print("\(self)  tabBarItem.imageInsets=\(self.tabBarItem.imageInsets)")
        
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        
    }
    
    func application(application: UIApplication, supportedInterfaceOrientationsForWindow window: UIWindow?) -> UIInterfaceOrientationMask {
        return UIInterfaceOrientationMask.All
    }
    
}


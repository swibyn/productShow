//
//  UIViewController+FirstVCExtension.swift
//  ProductShow
//
//  Created by s on 15/10/15.
//  Copyright © 2015年 gaozgao. All rights reserved.
//

import Foundation
import UIKit

let kLoginSucceed = "kLoginSucceed"
let kProductsInCartChanged = "kProductsInCartChanged"
let kUserSignOutNotification = "kUserSignOutNotification"

extension UIViewController{
    
    //MARK: 增加首页按钮
    func addFirstPageButton(){
        let firstPageButtonItem = UIBarButtonItem(title: "Home", style: UIBarButtonItemStyle.Plain, target: self, action: Selector("firstPageButtonAction:"))
        firstPageButtonItem.tintColor = UIColor.whiteColor()
//        self.navigationItem.leftBarButtonItems?.append(firstPageButtonItem)
        self.navigationItem.leftBarButtonItems = [firstPageButtonItem]
        
    }
    
    //增加返回首页按钮
    func firstPageButtonAction(sender: UIBarButtonItem){
        (self.tabBarController as! HomeTabBarViewController).presentFirstPageVC()
    }
    
    //MARK: Keyboard Notification
    func addObserverKeyboardNotification(){
        let center = NSNotificationCenter.defaultCenter()
        center.addObserver(self, selector: Selector("handleKeyboardWillShow:"), name: UIKeyboardWillShowNotification, object: nil)
        center.addObserver(self, selector: Selector("handleKeyboardWillHide:"), name: UIKeyboardWillHideNotification, object: nil)
    }
    
    func removeObserverKeyboardNotification(){
        let center = NSNotificationCenter.defaultCenter()
        center.removeObserver(self, name: UIKeyboardWillShowNotification, object: nil)
        center.removeObserver(self, name: UIKeyboardWillHideNotification, object: nil)
    }
    
    func handleKeyboardWillShow(paramNotification: NSNotification){
        //nothing to be override
    }
    
    func handleKeyboardWillHide(paramNotification: NSNotification){
        //nothing to be override
    }
    
    //MARK: Login Notification
    func addObserverLoginNotification(){
        let center = NSNotificationCenter.defaultCenter()
        center.addObserver(self, selector: Selector("handleLoginSucceed:"), name: kLoginSucceed, object: nil)
    }
    
    func removeObserverLoginNotification(){
        let center = NSNotificationCenter.defaultCenter()
        center.removeObserver(self, name: kLoginSucceed, object: nil)
    }
    
    func handleLoginSucceed(paramNotification: NSNotification){
        //nothing         //to be override
    }
        
    
    //MARK: 购物车消息通知
    func addObserverProductsInCartChangedNotification(){
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("handleProductsInCartChanged:"), name: kProductsInCartChanged, object: nil)
    }
    
    func removeObserverProductsInCartChangedNotification(){
        let center = NSNotificationCenter.defaultCenter()
        center.removeObserver(self, name: kProductsInCartChanged, object: nil)
    }
    
    func handleProductsInCartChanged(paramNotification: NSNotification){
        //nothing         //to be override
    }
    
    //MARK: 监听注销消息通知
    func addUserSignOutNotificationObserver(){
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("handleUserSignOutNotification"), name: kUserSignOutNotification, object: nil)
    }
    
    func removeUserSignOutNotificationObserver(){
        NSNotificationCenter.defaultCenter().removeObserver(self, name: kUserSignOutNotification, object: nil)
    }
    
    func handleUserSignOutNotification(){
        
    }
    
    
}



























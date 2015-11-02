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
let kOrdersChanged = "kOrdersChanged"

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
    //MARK: - 各种消息通知的处理
    func removeSelfObserver() {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    //MARK: Keyboard Notification
    func addKeyboardNotificationObserver(){
        let center = NSNotificationCenter.defaultCenter()
        center.addObserver(self, selector: Selector("handleKeyboardWillShow:"), name: UIKeyboardWillShowNotification, object: nil)
        center.addObserver(self, selector: Selector("handleKeyboardWillHide:"), name: UIKeyboardWillHideNotification, object: nil)
    }
    
    func removeKeyboardNotificationObserver(){
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
    func postLoginSucceedNotification(){
        NSNotificationCenter.defaultCenter().postNotificationName(kLoginSucceed, object: self)
    }

    func addLoginNotificationObserver(){
        let center = NSNotificationCenter.defaultCenter()
        center.addObserver(self, selector: Selector("handleLoginSucceed:"), name: kLoginSucceed, object: nil)
    }
    
    func removeLoginNotificationObserver(){
        let center = NSNotificationCenter.defaultCenter()
        center.removeObserver(self, name: kLoginSucceed, object: nil)
    }
    
    func handleLoginSucceed(paramNotification: NSNotification){
        //nothing         //to be override
    }
        
    
    //MARK: 购物车消息通知
    func postProductsInCartChangedNotification(){
        NSNotificationCenter.defaultCenter().postNotificationName(kProductsInCartChanged, object: self)
    }
    
    func addProductsInCartChangedNotificationObserver(){
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("handleProductsInCartChanged:"), name: kProductsInCartChanged, object: nil)
    }
    
    func removeProductsInCartChangedNotificationObserver(){
        let center = NSNotificationCenter.defaultCenter()
        center.removeObserver(self, name: kProductsInCartChanged, object: nil)
    }
    
    func handleProductsInCartChanged(paramNotification: NSNotification){
        //nothing         //to be override
    }
    
    //MARK: 监听注销消息通知
    
    func postUserSignOutNotification(){
        NSNotificationCenter.defaultCenter().postNotificationName(kUserSignOutNotification, object: self)
    }

    func addUserSignOutNotificationObserver(){
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("handleUserSignOutNotification"), name: kUserSignOutNotification, object: nil)
    }
    
    func removeUserSignOutNotificationObserver(){
        NSNotificationCenter.defaultCenter().removeObserver(self, name: kUserSignOutNotification, object: nil)
    }
    
    func handleUserSignOutNotification(){
        
    }
    
    //MARK: 订单有变
    
    func postOrdersChangedNotification(){
        NSNotificationCenter.defaultCenter().postNotificationName(kOrdersChanged, object: self)
    }

    func addOrdersChangedNotificationObserver(){
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("handleOrdersChanged"), name: kOrdersChanged, object: nil)
    }
    
    func removeOrdersChangedNotificationObserver(){
        NSNotificationCenter.defaultCenter().removeObserver(self,name:kOrdersChanged,object:nil)
    }
    
    func handleOrdersChangedNotification(){
        
    }
    
    
}



























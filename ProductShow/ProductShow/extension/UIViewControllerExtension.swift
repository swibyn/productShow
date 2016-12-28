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
    
    //MARK: Home Button
    func addFirstPageButton(){
        let firstPageButtonItem = UIBarButtonItem(title: "Home", style: UIBarButtonItemStyle.plain, target: self, action: #selector(UIViewController.firstPageButtonAction(_:)))
        firstPageButtonItem.tintColor = UIColor.white
//        self.navigationItem.leftBarButtonItems?.append(firstPageButtonItem)
        self.navigationItem.leftBarButtonItems = [firstPageButtonItem]
        
    }
    
    //Home Button event
    func firstPageButtonAction(_ sender: UIBarButtonItem){
        (self.tabBarController as! HomeTabBarViewController).presentFirstPageVC()
    }
    
    //MARK: - Notifications
    //MARK: removeSelfObserver
    func removeSelfObserver() {
        NotificationCenter.default.removeObserver(self)
    }
    
    //MARK: Keyboard Notification
    func addKeyboardNotificationObserver(){
        let center = NotificationCenter.default
        center.addObserver(self, selector: #selector(UIViewController.handleKeyboardWillShow(_:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        center.addObserver(self, selector: #selector(UIViewController.handleKeyboardWillHide(_:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    func removeKeyboardNotificationObserver(){
        let center = NotificationCenter.default
        center.removeObserver(self, name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        center.removeObserver(self, name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    func handleKeyboardWillShow(_ paramNotification: Notification){
        //nothing -to be override
    }
    
    func handleKeyboardWillHide(_ paramNotification: Notification){
        //nothing -to be override
    }
    
    func keyboardAnimationDurationAndEndRect(_ paramNotification: Notification) -> (animationDuration: Double,keyboardEndRect: CGRect){
        let userInfo = paramNotification.userInfo!
        let animationDurationObject = userInfo[UIKeyboardAnimationDurationUserInfoKey]
        let keyboardEndRectObject = userInfo[UIKeyboardFrameEndUserInfoKey]
        var animationDuration = 0.0
        var keyboardEndRect = CGRect(x: 0, y: 0, width: 0, height: 0)
        (animationDurationObject as AnyObject).getValue(&animationDuration)
        (keyboardEndRectObject as AnyObject).getValue(&keyboardEndRect)
        return (animationDuration,keyboardEndRect)
        
    }
    
    //MARK: Login Notification
    func postLoginSucceedNotification(){
        NotificationCenter.default.post(name: Notification.Name(rawValue: kLoginSucceed), object: self)
    }

    func addLoginNotificationObserver(){
        let center = NotificationCenter.default
        center.addObserver(self, selector: #selector(UIViewController.handleLoginSucceedNotification(_:)), name: NSNotification.Name(rawValue: kLoginSucceed), object: nil)
    }
    
    func removeLoginNotificationObserver(){
        let center = NotificationCenter.default
        center.removeObserver(self, name: NSNotification.Name(rawValue: kLoginSucceed), object: nil)
    }
    
    func handleLoginSucceedNotification(_ paramNotification: Notification){
        //nothing         //to be override
    }
        
    
    //MARK: ProductsInCartChangedNotification
    func postProductsInCartChangedNotification(){
        NotificationCenter.default.post(name: Notification.Name(rawValue: kProductsInCartChanged), object: self)
    }
    
    func addProductsInCartChangedNotificationObserver(){
        NotificationCenter.default.addObserver(self, selector: #selector(UIViewController.handleProductsInCartChangedNotification(_:)), name: NSNotification.Name(rawValue: kProductsInCartChanged), object: nil)
    }
    
    func removeProductsInCartChangedNotificationObserver(){
        let center = NotificationCenter.default
        center.removeObserver(self, name: NSNotification.Name(rawValue: kProductsInCartChanged), object: nil)
    }
    
    func handleProductsInCartChangedNotification(_ paramNotification: Notification){
        //nothing         //to be override
    }
    
    //MARK: UserSignOutNotification
    func postUserSignOutNotification(){
        NotificationCenter.default.post(name: Notification.Name(rawValue: kUserSignOutNotification), object: self)
    }

    func addUserSignOutNotificationObserver(){
        NotificationCenter.default.addObserver(self, selector: #selector(UIViewController.handleUserSignOutNotification(_:)), name: NSNotification.Name(rawValue: kUserSignOutNotification), object: nil)
    }
    
    func removeUserSignOutNotificationObserver(){
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: kUserSignOutNotification), object: nil)
    }
    
    func handleUserSignOutNotification(_ paramNotification: Notification){
        
    }
    
    //MARK: OrdersChangedNotification
    func postOrdersChangedNotification(){
        NotificationCenter.default.post(name: Notification.Name(rawValue: kOrdersChanged), object: self)
    }

    func addOrdersChangedNotificationObserver(){
        NotificationCenter.default.addObserver(self, selector: #selector(UIViewController.handleOrdersChangedNotification(_:)), name: NSNotification.Name(rawValue: kOrdersChanged), object: nil)
    }
    
    func removeOrdersChangedNotificationObserver(){
        NotificationCenter.default.removeObserver(self,name:NSNotification.Name(rawValue: kOrdersChanged),object:nil)
    }
    
    func handleOrdersChangedNotification(_ paramNotification: Notification){
        
    }
    
    
}



























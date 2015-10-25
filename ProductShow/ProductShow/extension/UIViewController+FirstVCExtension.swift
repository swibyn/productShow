//
//  UIViewController+FirstVCExtension.swift
//  ProductShow
//
//  Created by s on 15/10/15.
//  Copyright © 2015年 gaozgao. All rights reserved.
//

import Foundation
import UIKit

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
    
//    func setBarButtonTint(color: UIColor){
//        if self.navigationItem.leftBarButtonItems?.count > 0{
//            for barButton in self.navigationItem.leftBarButtonItems!{
//                barButton.tintColor = color
//            }}
//        if self.navigationItem.rightBarButtonItems?.count > 0{
//            for barButton in self.navigationItem.rightBarButtonItems!{
//                barButton.tintColor = color
//            }
//        }
//    }
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
    
   
    
    
}



























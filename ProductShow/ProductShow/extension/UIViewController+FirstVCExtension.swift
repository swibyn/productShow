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
        let firstPageButtonItem = UIBarButtonItem(title: "首页", style: UIBarButtonItemStyle.Plain, target: self, action: Selector("firstPageButtonAction:"))
//        self.navigationItem.leftBarButtonItems?.append(firstPageButtonItem)
        self.navigationItem.leftBarButtonItems = [firstPageButtonItem]
    }
    
    
    //增加返回首页按钮
    func firstPageButtonAction(sender: UIBarButtonItem){
        (self.tabBarController as! HomeTabBarViewController).presentFirstPageVC()
    }

    //MARK:增加购物车按钮
//    func addCartButton(){
//        let cartButton = UIBarButtonItem(title: "购物车", style: UIBarButtonItemStyle.Plain, target: self, action: Selector("cartButtonAction:"))
//        self.navigationItem.rightBarButtonItem = cartButton
//    }
//    
//    private func cartButtonAction(sender: UIBarButtonItem){
//        
//    }
    
    
}
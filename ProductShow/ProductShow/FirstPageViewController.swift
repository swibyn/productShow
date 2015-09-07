//
//  FirstPageViewController.swift
//  ProductShow
//
//  Created by s on 15/9/6.
//  Copyright (c) 2015年 gaozgao. All rights reserved.
//

import UIKit

class FirstPageViewController: UIViewController {

    @IBOutlet var hotProducts: UIButton!
    @IBOutlet var productCategories: UIButton!
    @IBOutlet var productSearch: UIButton!
    @IBOutlet var userCenter: UIButton!
    
    //Mark: 增加阴影
    func addShadows(){
        
//        [[m_masterView layer] setShadowOffset:CGSizeMake(1, 1)];
//        [[m_masterView layer] setShadowRadius:5];
//        [[m_masterView layer] setShadowOpacity:1];
//        [[m_masterView layer] setShadowColor:[UIColor blackColor].CGColor];
        hotProducts.layer.shadowOffset = CGSize(width: 100, height: 100)
//        hotProducts.layer.shadowColor 
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "首页"

        // Do any additional setup after loading the view
        addShadows()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
  
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
//        let destVC = segue.destinationViewController as! UINavigationController
//        let tabVC = destVC.viewControllers[0] as! UITabBarController
        
        let tabVC = segue.destinationViewController as! UITabBarController
        
        
        switch segue.identifier!{
        case "hotProducts":
            tabVC.selectedIndex = 0
        case "productCategories":
            tabVC.selectedIndex = 1
        case "productSearch":
            tabVC.selectedIndex = 2
        case "userCenter":
            tabVC.selectedIndex = 3
        default:
            tabVC.selectedIndex = 0
        }
    }
    

}

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

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        debugPrint("\(self.tabBarItem.title) \(__FUNCTION__)")
    }
    
    override func viewDidAppear(animated: Bool) {
        debugPrint("\(self.tabBarItem.title) \(__FUNCTION__)")
    }
    
    override func viewWillDisappear(animated: Bool) {
        debugPrint("\(self.tabBarItem.title) \(__FUNCTION__)")
    }
    
    override func viewDidDisappear(animated: Bool) {
        debugPrint("\(self.tabBarItem.title) \(__FUNCTION__)")
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

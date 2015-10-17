//
//  FirstPageViewController.swift
//  ProductShow
//
//  Created by s on 15/9/6.
//  Copyright (c) 2015年 gaozgao. All rights reserved.
//

import UIKit

protocol FirstPageViewControllerDelegate : NSObjectProtocol{
    func firstPageViewController(firstPageViewController: FirstPageViewController, didClickButton button: UIButton)
}

class FirstPageViewController: UIViewController,LoginViewControllerDelegate/*,UITabBarControllerDelegate*/ {

    //MARK: Property
    var delegate: FirstPageViewControllerDelegate?
    
    //MARK: @IB
    @IBOutlet var hotProducts: UIButton!
    @IBOutlet var productCategories: UIButton!
    @IBOutlet var productSearch: UIButton!
    @IBOutlet var userCenter: UIButton!
    
    @IBAction func buttonClick(sender: UIButton) {
        delegate?.firstPageViewController(self, didClickButton: sender)
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    //Mark: 增加阴影
    func addShadows(){
        
//        [[m_masterView layer] setShadowOffset:CGSizeMake(1, 1)];
//        [[m_masterView layer] setShadowRadius:5];
//        [[m_masterView layer] setShadowOpacity:1];
//        [[m_masterView layer] setShadowColor:[UIColor blackColor].CGColor];
        hotProducts.layer.shadowOffset = CGSize(width: 100, height: 100)
//        hotProducts.layer.shadowColor 
    }
    
    // MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "首页"

        // Do any additional setup after loading the view
        addShadows()
        
    }
    
    
    override func viewDidAppear(animated: Bool) {
        let bsignin = UserInfo.defaultUserInfo().status == 1
//        var bsignin = false
//        if let userinfo = Global.userInfo{
//            let status = userinfo.objectForKey(jfstatus) as! Int
//            bsignin = status == 1
//        }
        if (!bsignin){
            presentLoginVC(UIModalTransitionStyle.CoverVertical, animated: true, completion: nil)
        }
        
    }
    
    deinit{
        print("\(self) \(__FUNCTION__)")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // MARK: 初始化一个实例
    static func shareInstance()->FirstPageViewController{
        
        let aInstance = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("FirstPageViewController") as! FirstPageViewController
        return aInstance
    }
    
    // MARK: metheds
    
    func presentLoginVC(modalTransitionStyle: UIModalTransitionStyle,animated: Bool, completion:(()->Void)?){
        let loginVC = LoginViewController.shareInstance()
        loginVC.modalTransitionStyle = modalTransitionStyle
        loginVC.delegate = self
        self.presentViewController(loginVC, animated: animated, completion: completion)
    }
    
    // MARK: LoginViewControllerDelegate
    func loginViewController(loginViewController: LoginViewController, userInfo: AnyObject?) {
        loginViewController.dismissViewControllerAnimated(true, completion: nil)
        //        presentFirstPageVC()
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        let tabVC = segue.destinationViewController as! UITabBarController
        let btn = sender as! UIButton
        for vc in tabVC.viewControllers! {
            if vc.tabBarItem.title == btn.titleForState(UIControlState.Normal){
                tabVC.selectedViewController = vc
//                let window = UIApplication.sharedApplication().delegate?.window!
//                window!.rootViewController = tabVC
                break
            }
        }
        
//        switch segue.identifier!{
//        case "hotProducts":
//            tabVC.selectedIndex = 0
//        case "productCategories":
//            tabVC.selectedIndex = 1
//        case "productSearch":
//            tabVC.selectedIndex = 2
//        case "userCenter":
//            tabVC.selectedIndex = 3
//        default:
//            tabVC.selectedIndex = 0
//        }
    }
    

}

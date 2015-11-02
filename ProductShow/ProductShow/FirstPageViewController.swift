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

class FirstPageViewController: UIViewController,LoginViewControllerDelegate {

    //MARK: Property
    var delegate: FirstPageViewControllerDelegate?
    
    //MARK: @IB
    @IBOutlet var hotProducts: UIButton!
    @IBOutlet var productCategories: UIButton!
    @IBOutlet var productSearch: UIButton!
    @IBOutlet var userCenter: UIButton!
    
    @IBAction func buttonClick(sender: UIButton) {
        delegate?.firstPageViewController(self, didClickButton: sender)
//        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    // MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Home"
        
    }
    
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        let bsignin = UserInfo.defaultUserInfo().status == 1

        if (!bsignin){
            presentLoginVC(UIModalTransitionStyle.CoverVertical, animated: true, completion: nil)
        }
        
    }
    
    deinit{
//        print("\(self) \(__FUNCTION__)")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // MARK: 初始化一个实例
    static func newInstance()->FirstPageViewController{
        
        let aInstance = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("FirstPageViewController") as! FirstPageViewController
        return aInstance
    }
    
    // MARK: metheds
    
    func presentLoginVC(modalTransitionStyle: UIModalTransitionStyle,animated: Bool, completion:(()->Void)?){
        let loginVC = LoginViewController.newInstance()
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
        
    }
    
    override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        return UIInterfaceOrientationMask.Landscape
    }

}

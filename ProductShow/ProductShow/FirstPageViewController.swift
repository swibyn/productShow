                        //
//  FirstPageViewController.swift
//  ProductShow
//
//  Created by s on 15/9/6.
//  Copyright (c) 2015年 gaozgao. All rights reserved.
//

import UIKit

protocol FirstPageViewControllerDelegate : NSObjectProtocol{
    func firstPageViewController(_ firstPageViewController: FirstPageViewController, didClickButton button: UIButton)
}

class FirstPageViewController: UIViewController,LoginViewControllerDelegate {

    //MARK: Property
    var delegate: FirstPageViewControllerDelegate?
    
    //MARK: @IB
    @IBOutlet var hotProducts: UIButton!
    @IBOutlet var productCategories: UIButton!
    @IBOutlet var productSearch: UIButton!
    @IBOutlet var userCenter: UIButton!
    
    @IBAction func buttonClick(_ sender: UIButton) {
        delegate?.firstPageViewController(self, didClickButton: sender)
//        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    // MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Home"
        
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        let bsignin = UserInfo.defaultUserInfo().state == 1

        if (!bsignin){
            presentLoginVC(UIModalTransitionStyle.coverVertical, animated: true, completion: nil)
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
        
        let aInstance = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "FirstPageViewController") as! FirstPageViewController
        return aInstance
    }
    
    // MARK: metheds
    
    func presentLoginVC(_ modalTransitionStyle: UIModalTransitionStyle,animated: Bool, completion:(()->Void)?){
        let loginVC = LoginViewController.newInstance()
        loginVC.modalTransitionStyle = modalTransitionStyle
        loginVC.delegate = self
        self.present(loginVC, animated: animated, completion: completion)
    }
    
    // MARK: LoginViewControllerDelegate
    func loginViewController(_ loginViewController: LoginViewController, userInfo: AnyObject?) {
        loginViewController.dismiss(animated: true, completion: nil)
        //        presentFirstPageVC()
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
    }
    
    override var supportedInterfaceOrientations : UIInterfaceOrientationMask {
        return UIInterfaceOrientationMask.landscape
    }

}

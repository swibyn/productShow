//
//  UITextViewController.swift
//  ProductShow
//
//  Created by s on 15/11/10.
//  Copyright © 2015年 zhiwx. All rights reserved.
//

import UIKit
protocol UITextViewControllerDelegate{
    func textViewControllerDone(textViewVC:UITextViewController)
}

class UITextViewController: UIViewController {

    //MARK: 初始化一个实例
    static func newInstance()->UITextViewController{
        
        let aInstance = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("UITextViewController") as! UITextViewController
        return aInstance
    }
    
    
//    var customer: Customer!
//    var log: Log?
    var delegate: UITextViewControllerDelegate?
    
    //MARK: @IB
    @IBOutlet var textView: UITextView!
    @IBAction func doneBarButtonAction(sender: UIBarButtonItem) {
        delegate?.textViewControllerDone(self)
   
    }
   
    //MARK: view life
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
    }
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        //        logTextView.text = log?.logContent
        self.addKeyboardNotificationObserver()
    }
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        self.removeKeyboardNotificationObserver()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: Observer
    override func handleKeyboardWillShow(paramNotification: NSNotification) {
        super.handleKeyboardWillShow(paramNotification)
        //        let userInfo = paramNotification.userInfo!// as! NSDictionary
        //        let animationDurationObject = userInfo[UIKeyboardAnimationDurationUserInfoKey]
        //        let keyboardEndRectObject = userInfo[UIKeyboardFrameEndUserInfoKey]
        //        var animationDuration = 0.0
        //        var keyboardEndRect = CGRectMake(0, 0, 0, 0)
        //        animationDurationObject?.getValue(&animationDuration)
        //        keyboardEndRectObject?.getValue(&keyboardEndRect)
        
        var (animationDuration,keyboardEndRect) = keyboardAnimationDurationAndEndRect(paramNotification)
        
        let window = UIApplication.sharedApplication().keyWindow
        
        keyboardEndRect = self.view.convertRect(keyboardEndRect, fromView: window)
        //        debugPrint("keyboardEndRect=\(keyboardEndRect)")
        let intersectionOfKeyboardRectAndWindowRect = CGRectIntersection(self.view.frame, keyboardEndRect)
        //        debugPrint("intersectionOfKeyboardRectAndWindowRect=\(intersectionOfKeyboardRectAndWindowRect)")
        
        UIView.animateWithDuration(animationDuration) { () -> Void in
            self.textView.contentInset = UIEdgeInsetsMake(0, 0, intersectionOfKeyboardRectAndWindowRect.size.height, 0)
            
            //            debugPrint("contentInset=\(self.logTextView.contentInset)")
        }
        
        
    }
    
    override func handleKeyboardWillHide(paramNotification: NSNotification) {
        super.handleKeyboardWillHide(paramNotification)
        //        let userInfo = paramNotification.userInfo!
        //        let animationDurationObject = userInfo[UIKeyboardAnimationDurationUserInfoKey]
        //        var animationDuration = 0.0
        //        animationDurationObject?.getValue(&animationDuration)
        let (animationDuration,_) = keyboardAnimationDurationAndEndRect(paramNotification)
        
        UIView.animateWithDuration(animationDuration) { () -> Void in
            self.textView.contentInset = UIEdgeInsetsZero
        }
        
    }
    
    //MARK: function
    
    
    /*
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    // Get the new view controller using segue.destinationViewController.
    // Pass the selected object to the new view controller.
    }
    */
    
}
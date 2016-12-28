//
//  UITextViewController.swift
//  ProductShow
//
//  Created by s on 15/11/10.
//  Copyright © 2015年 zhiwx. All rights reserved.
//

import UIKit
protocol UITextViewControllerDelegate{
    func textViewControllerDone(_ textViewVC:UITextViewController)
}

class UITextViewController: UIViewController {

    //MARK: 初始化一个实例
    static func newInstance()->UITextViewController{
        
        let aInstance = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "UITextViewController") as! UITextViewController
        return aInstance
    }
    
    var delegate: UITextViewControllerDelegate?
    var initTextViewText: String?
    
    //MARK: @IB
    @IBOutlet var textView: UITextView!
    @IBAction func doneBarButtonAction(_ sender: UIBarButtonItem) {
        delegate?.textViewControllerDone(self)
   }
   
    //MARK: view life
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        textView.text = initTextViewText

    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.addKeyboardNotificationObserver()
    }
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        self.removeKeyboardNotificationObserver()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: Observer
    override func handleKeyboardWillShow(_ paramNotification: Notification) {
        super.handleKeyboardWillShow(paramNotification)
        
        var (animationDuration,keyboardEndRect) = keyboardAnimationDurationAndEndRect(paramNotification)
        
        let window = UIApplication.shared.keyWindow
        
        keyboardEndRect = self.view.convert(keyboardEndRect, from: window)
        let intersectionOfKeyboardRectAndWindowRect = self.view.frame.intersection(keyboardEndRect)
        
        UIView.animate(withDuration: animationDuration, animations: { () -> Void in
            self.textView.contentInset = UIEdgeInsetsMake(0, 0, intersectionOfKeyboardRectAndWindowRect.size.height, 0)
        }) 
    }
    
    override func handleKeyboardWillHide(_ paramNotification: Notification) {
        super.handleKeyboardWillHide(paramNotification)
        
        let (animationDuration,_) = keyboardAnimationDurationAndEndRect(paramNotification)
        
        UIView.animate(withDuration: animationDuration, animations: { () -> Void in
            self.textView.contentInset = UIEdgeInsets.zero
        }) 
        
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

//
//  LogEditorViewController.swift
//  ProductShow
//
//  Created by s on 15/11/10.
//  Copyright © 2015年 zhiwx. All rights reserved.
//

import UIKit

protocol LogEditorViewControllerDelegate{
    func LogEditorViewControllerSubmitSecceed(logEditorVC:LogEditorViewController)
}

class LogEditorViewController: UIViewController {
    
    //MARK: 初始化一个实例
    static func newInstance()->LogEditorViewController{
        
        let aInstance = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("LogEditorViewController") as! LogEditorViewController
        return aInstance
    }

    
    var customer: Customer!
    var log: Log?
    var delegate: LogEditorViewControllerDelegate?
    
    //MARK: @IB
    @IBOutlet var logTextView: UITextView!
    @IBAction func submitBarButtonItemAction(sender: AnyObject) {
        submitLog()
    }
    
    //MARK: view life
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        logTextView.text = log?.logDesc
    }
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
//        logTextView.text = log?.logContent
        self.addKeyboardNotificationObserver()
    }
    override func viewDidDisappear(animated: Bool) {
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
            self.logTextView.contentInset = UIEdgeInsetsMake(0, 0, intersectionOfKeyboardRectAndWindowRect.size.height, 0)
        
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
            self.logTextView.contentInset = UIEdgeInsetsZero
        }
        
    }
    
    //MARK: function
    
    func submitLog(){
        
        let logText = self.logTextView?.text.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
        if logText!.characters.count > 0{
            let uid = UserInfo.defaultUserInfo().firstUser?.uid
            let uName = UserInfo.defaultUserInfo().firstUser?.uname
            let logDate = NSDate().toString("yyyy-MM-dd")
            let logDesc = logText!
            let custId = customer?.custId
            let custName = customer?.custName
            let logId = log?.logId
            let logIdStr = (logId == nil) ? "" : "\(logId!)"
            let caozuo = (log == nil) ? "add" : "modify"
            
            let dic = [jfuid: uid!, jfuName: uName!, jflogDate: logDate, jflogContent: logDesc, jfcustId: custId!, jfcustName: custName!, jflogId: logIdStr, jfcaozuo: caozuo]
            
            WebApi.WriteCustLog(dic, completedHandler: { (response, data, error) -> Void in
                if WebApi.isHttpSucceed(response, data: data, error: error){
                    
                    let json = (try! NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableContainers)) as! NSDictionary
                    
                    //                debugPrint("\(self) \(__FUNCTION__) json=\(json)")
                    let returnDic = ReturnDic(returnDic: json)
                    
                    if (returnDic.status == 1){
//                        let alertView = UIAlertView(title: "Succeed", message: "Submit succeed", delegate: self, cancelButtonTitle: "OK")
//                        alertView.show()
                        self.delegate?.LogEditorViewControllerSubmitSecceed(self)
                        
                    }else{
                        let message = returnDic.message// json.objectForKey(jfmessage) as! String
                        let alertView = UIAlertView(title: "", message: message, delegate: nil, cancelButtonTitle: "OK")
                        alertView.show()
                    }
                }else{
                    let alertView = UIAlertView(title: "", message: Pleasecheckthenetworkconnection, delegate: nil, cancelButtonTitle: "OK")
                    alertView.show()
                    
                }
            })
        }
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

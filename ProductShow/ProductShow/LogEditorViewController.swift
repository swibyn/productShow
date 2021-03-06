//
//  LogEditorViewController.swift
//  ProductShow
//
//  Created by s on 15/11/10.
//  Copyright © 2015年 zhiwx. All rights reserved.
//

import UIKit

protocol LogEditorViewControllerDelegate{
    func LogEditorViewControllerSubmitSecceed(_ logEditorVC:LogEditorViewController)
}

class LogEditorViewController: UIViewController {
    
    //MARK: 初始化一个实例
    static func newInstance()->LogEditorViewController{
        
        let aInstance = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "LogEditorViewController") as! LogEditorViewController
        return aInstance
    }

    
    var customer: Customer!
    var log: Log?
    var delegate: LogEditorViewControllerDelegate?
    
    //MARK: @IB
    @IBOutlet var logTextView: UITextView!
    @IBAction func submitBarButtonItemAction(_ sender: AnyObject) {
        submitLog()
    }
    
    //MARK: view life
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        logTextView.text = log?.logDesc
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.addKeyboardNotificationObserver()
    }
    override func viewDidDisappear(_ animated: Bool) {
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
            self.logTextView.contentInset = UIEdgeInsetsMake(0, 0, intersectionOfKeyboardRectAndWindowRect.size.height, 0)
        }) 
    }
    
    override func handleKeyboardWillHide(_ paramNotification: Notification) {
        super.handleKeyboardWillHide(paramNotification)

        let (animationDuration,_) = keyboardAnimationDurationAndEndRect(paramNotification)
        
        UIView.animate(withDuration: animationDuration, animations: { () -> Void in
            self.logTextView.contentInset = UIEdgeInsets.zero
        }) 
    }
    
    //MARK: function
    
    func submitLog(){
        
        let logText = self.logTextView?.text.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        if logText!.characters.count > 0{
            let uid = UserInfo.defaultUserInfo().firstUser?.uid
            let uName = UserInfo.defaultUserInfo().firstUser?.uname
            let logDate = Date().toString("yyyy-MM-dd")
            let logDesc = logText!
            let custId = customer?.custId
            let custName = customer?.custName
            let logId = log?.logId
            let logIdStr = (logId == nil) ? "" : "\(logId!)"
            let caozuo = (log == nil) ? "add" : "modify"
            
            let dic = [jfuid: uid!, jfuName: uName!, jflogDate: logDate, jflogContent: logDesc, jfcustId: custId!, jfcustName: custName!, jflogId: logIdStr, jfcaozuo: caozuo] as [String : Any]
            
            WebApi.WriteCustLog(dic as NSDictionary, completedHandler: { (response, data, error) -> Void in
                if WebApi.isHttpSucceed(response, data: data, error: error){
                    
                    let json = (try! JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers)) as! NSDictionary
                    
                    let returnDic = ReturnDic(returnDic: json)
                    
                    if (returnDic.status == 1){
                        self.delegate?.LogEditorViewControllerSubmitSecceed(self)
                        
                    }else{
                        let message = returnDic.message
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

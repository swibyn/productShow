//
//  UINoticeViewController.swift
//  ProductShow
//
//  Created by s on 15/10/22.
//  Copyright © 2015年 gaozgao. All rights reserved.
//

import UIKit

class UINoticeViewController: UIViewController {
    var notice: Notice?
    
    @IBOutlet var webView: UIWebView!
    
    
    //MARK: 初始化一个实例
    static func newInstance()->UINoticeViewController{
        
        let aInstance = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "UINoticeViewController") as! UINoticeViewController
        return aInstance
    }


    //MARK: view life
    override func viewDidLoad() {
        self.title = notice?.title
        let contentsOpt = notice?.contents
        if let contents = contentsOpt{
            self.webView.loadHTMLString(contents, baseURL: nil)
        }
    }

}

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
    
    override func viewDidLoad() {
        self.title = notice?.title
        let contentsOpt = notice?.contents
        if let contents = contentsOpt{
            self.webView.loadHTMLString(contents, baseURL: nil)
        }
    }

}

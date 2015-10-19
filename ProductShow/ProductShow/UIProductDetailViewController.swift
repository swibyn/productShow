//
//  UIProductDetailViewController.swift
//  ProductShow
//
//  Created by s on 15/10/18.
//  Copyright © 2015年 gaozgao. All rights reserved.
//

import UIKit

class UIProductDetailViewController: UIViewController {
//    var productDic: NSDictionary?
    var product: Product?
    
    @IBOutlet var webView: UIWebView!
    
    override func viewDidLoad() {
        
        webView.loadHTMLString((product?.promemo!)!, baseURL: nil)
    }
    
    

}

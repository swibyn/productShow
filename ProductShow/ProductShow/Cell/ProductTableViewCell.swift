//
//  ProductTableViewCell.swift
//  ProductShow
//
//  Created by s on 15/10/14.
//  Copyright (c) 2015年 gaozgao. All rights reserved.
//

import Foundation
import UIKit

class UIProductTableViewCell : UITableViewCell {
    var productDic: NSDictionary!
    
    static let rowHeight = 90

    
    
    @IBOutlet var proThumbImageView: UIImageView!
    @IBOutlet var proNameLabel: UILabel!
    @IBOutlet var proSizeLabel: UILabel!
    @IBOutlet var remarkLabel: UILabel!
 
    @IBOutlet var addToCartButton: UIButton!
    
    @IBAction func addToCartButtonAction(sender: UIButton) {
        Global.cart.addProduct(productDic)
        NSNotificationCenter.defaultCenter().postNotificationName(kProductsInCartChanged, object: self)
        
    }
    
    func configureFromDictionary(){
        let dic = productDic
        self.proNameLabel.text = dic.objectForKey(jfproName) as? String
        self.proSizeLabel.text = dic.objectForKey(jfproSize) as? String
        self.remarkLabel.text = dic.objectForKey(jfremark) as? String
        
        let imgUrl = dic.objectForKey(jfimgUrl) as? String
        WebApi.GetFile(imgUrl) { (response, data, error) -> Void in
            if data?.length > 0{
                self.proThumbImageView.image = UIImage(data: data!)
            }
        }

        
    }
    
    
}
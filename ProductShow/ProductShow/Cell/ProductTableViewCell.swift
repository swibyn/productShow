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
    
//    var productDic: NSDictionary!
    var product: Product!
    
    var delegate: UIProductTableViewCellDelegate?
    
    static let rowHeight = 90

    
    
    @IBOutlet var proThumbImageView: UIImageView!
    @IBOutlet var proNameLabel: UILabel!
    @IBOutlet var proSizeLabel: UILabel!
    @IBOutlet var remarkLabel: UILabel!
 
    @IBOutlet var operationButton: UIButton!
    
    @IBAction func operationButtonAction(sender: UIButton) {
        delegate?.productTableViewCellButtonDidClick(self)
    }
    
    func refreshView(){
//        let dic = productDic
        self.proNameLabel.text = product.proName// dic.objectForKey(jfproName) as? String
        self.proSizeLabel.text = product.proSize// dic.objectForKey(jfproSize) as? String
        self.remarkLabel.text = product.remark// dic.objectForKey(jfremark) as? String
        
//        let imgUrl = dic.objectForKey(jfimgUrl) as? String
        debugPrint("\(product.proName) \(product.imgUrl)")
        self.proThumbImageView.image = UIImage(named: "ic_suoluetu_90_75")
        WebApi.GetFile(product.imgUrl) { (response, data, error) -> Void in
            if data?.length > 0{
                self.proThumbImageView.image = UIImage(data: data!)
            }
        }
    }
    
    func productTableViewController()->UIProductTableViewController{
        let detailVc = UIProductTableViewController.newInstance()
        detailVc.product = product
        return detailVc
    }
}

func ConfigureCell(cell: UIProductTableViewCell, buttonTitle:String, product: Product, delegate: UIProductTableViewCellDelegate?){
    cell.product = product
    cell.operationButton.setTitle(buttonTitle, forState: UIControlState.Normal)
    cell.delegate = delegate
    cell.refreshView()
}



protocol UIProductTableViewCellDelegate : NSObjectProtocol {
   
    func productTableViewCellButtonDidClick(cell: UIProductTableViewCell)
}


















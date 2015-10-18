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
    
    func productTableViewController()->UIProductTableViewController{
        let detailVc = UIProductTableViewController.newInstance()
        detailVc.productDic = productDic
        return detailVc
    }
}

func ConfigureCell(cell: UIProductTableViewCell, buttonTitle:String, productDic: NSDictionary, delegate: UIProductTableViewCellDelegate?){
    cell.productDic = productDic
    cell.operationButton.setTitle(buttonTitle, forState: UIControlState.Normal)
    cell.delegate = delegate
    cell.configureFromDictionary()
}



protocol UIProductTableViewCellDelegate : NSObjectProtocol {
   
    func productTableViewCellButtonDidClick(cell: UIProductTableViewCell)
}


















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
    
    static let rowHeight = 110

    
    
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
//        debugPrint("\(product.proName) \(product.imgUrl)")
        var imageloaded = false
        WebApi.GetFile(product.imgUrl) { (response, data, error) -> Void in
            if data?.length > 0{
                self.proThumbImageView.image = UIImage(data: data!)
                imageloaded = true
            }
        }
        if !imageloaded {
            self.proThumbImageView.image = UIImage(named: "商品默认图片96X96")
            
        }
    }
    
    func productTableViewController()->UIProductTableViewController{
        let detailVc = UIProductTableViewController.newInstance()
        detailVc.product = product
        return detailVc
    }
}

func ConfigureCell(cell: UIProductTableViewCell, canAddToCart:Bool, product: Product, delegate: UIProductTableViewCellDelegate?){
    cell.product = product
    cell.operationButton.hidden = !canAddToCart
    cell.delegate = delegate
    cell.refreshView()
}



protocol UIProductTableViewCellDelegate : NSObjectProtocol {
   
    func productTableViewCellButtonDidClick(cell: UIProductTableViewCell)
}


















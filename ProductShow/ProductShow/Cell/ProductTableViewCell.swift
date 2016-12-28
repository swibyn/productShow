//
//  ProductTableViewCell.swift
//  ProductShow
//
//  Created by s on 15/10/14.
//  Copyright (c) 2015年 gaozgao. All rights reserved.
//

import Foundation
import UIKit
// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l < r
  case (nil, _?):
    return true
  default:
    return false
  }
}

// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func > <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l > r
  default:
    return rhs < lhs
  }
}


class UIProductTableViewCell : UITableViewCell {
    
    var product: Product!
    
    var delegate: UIProductTableViewCellDelegate?
    
    static let rowHeight = 151

    
    
    @IBOutlet var proThumbImageView: UIImageView!
    @IBOutlet var proNameLabel: UILabel!
    @IBOutlet var proSizeLabel: UILabel!
    @IBOutlet var remarkLabel: UILabel!
 
    @IBOutlet var operationButton: UIButton!
    
    @IBAction func operationButtonAction(_ sender: UIButton) {
        delegate?.productTableViewCellButtonDidClick(self)
    }
    
    func refreshView(){
        self.proNameLabel.text = product.proName
        self.proSizeLabel.text = product.proSize
        self.remarkLabel.text = product.remark
        
        var imageloaded = false
        WebApi.GetFile(product.thumbUrl) { (response, data, error) -> Void in
            
            if data?.count > 0{
                self.proThumbImageView.image = UIImage(data: data!)
                imageloaded = true
            }else{
                debugPrint("error=\(error)")
            }
        }
        if !imageloaded {
            self.proThumbImageView.image = UIImage(named: "商品默认图片96X96")
            
        }
    }
    
    func productViewController()->ProductViewController{
        let detailVc = ProductViewController.newInstance()
        detailVc.product = product
        return detailVc
    }
}

func ConfigureCell(_ cell: UIProductTableViewCell, canAddToCart:Bool, product: Product, delegate: UIProductTableViewCellDelegate?){
    cell.product = product
    cell.operationButton.isHidden = !canAddToCart
    cell.delegate = delegate
    cell.refreshView()
}



protocol UIProductTableViewCellDelegate : NSObjectProtocol {
   
    func productTableViewCellButtonDidClick(_ cell: UIProductTableViewCell)
}


















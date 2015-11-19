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
    
    var product: Product!
    
    var delegate: UIProductTableViewCellDelegate?
    
    static let rowHeight = 151

    
    
    @IBOutlet var proThumbImageView: UIImageView!
    @IBOutlet var proNameLabel: UILabel!
    @IBOutlet var proSizeLabel: UILabel!
    @IBOutlet var remarkLabel: UILabel!
 
    @IBOutlet var operationButton: UIButton!
    
    @IBAction func operationButtonAction(sender: UIButton) {
        delegate?.productTableViewCellButtonDidClick(self)
    }
    
    func refreshView(){
        self.proNameLabel.text = product.proName
        self.proSizeLabel.text = product.proSize
        self.remarkLabel.text = product.remark
        
        var imageloaded = false
        WebApi.GetFile(product.thumbUrl) { (response, data, error) -> Void in
            
            if data?.length > 0{
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

func ConfigureCell(cell: UIProductTableViewCell, canAddToCart:Bool, product: Product, delegate: UIProductTableViewCellDelegate?){
    cell.product = product
    cell.operationButton.hidden = !canAddToCart
    cell.delegate = delegate
    cell.refreshView()
}



protocol UIProductTableViewCellDelegate : NSObjectProtocol {
   
    func productTableViewCellButtonDidClick(cell: UIProductTableViewCell)
}


















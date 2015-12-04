//
//  ProductAndRemarkTableViewCell.swift
//  ProductShow
//
//  Created by s on 15/11/10.
//  Copyright © 2015年 zhiwx. All rights reserved.
//

import Foundation
import UIKit

class UIProductAndRemarkTableViewCell : UITableViewCell {
    static let cellid = "ProductAndRemarkTableViewCell"
    static let nibName = "ProductAndRemarkTableViewCell"
    
    var product: Product!
    
    var delegate: UIProductAndRemarkTableViewCellDelegate?
    
    static let rowHeight = 151
    
    @IBOutlet var proThumbImageView: UIImageView!
    @IBOutlet var proNameLabel: UILabel!
    @IBOutlet var proSizeLabel: UILabel!
    @IBOutlet var remarkLabel: UILabel!
    @IBOutlet var operationButton: UIButton!
    @IBOutlet var textView: UITextView!
    
    @IBAction func operationButtonAction(sender: UIButton) {
        delegate?.productAndRemarkTableViewCellButtonDidClick(self)
    }
    
    func refreshView(){
        self.proNameLabel.text = product.proName
        self.proSizeLabel.text = product.proSize
        self.remarkLabel.text = product.remark
        self.textView.text = product.additionInfo
        self.textView.font = UIFont.systemFontOfSize(16)
        var imageloaded = false
        WebApi.GetFile(product.thumbUrl) { (response, data, error) -> Void in
            if data?.length > 0{
                self.proThumbImageView.image = UIImage(data: data!)
                imageloaded = true
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
    
    static func heightForProduct(tableView: UITableView, product: Product)->CGFloat{
        return CGFloat(rowHeight)
//        let additionInfo = product.additionInfo
//        if additionInfo != nil{
//            //55
//            let tmptextView = UITextView(frame: CGRectMake(0, 0, tableView.bounds.size.width - 55, CGFloat.max))
//            tmptextView.font = UIFont.systemFontOfSize(16)
//            tmptextView.text = additionInfo!
//            let textFrame = tmptextView.layoutManager.usedRectForTextContainer(tmptextView.textContainer)
//            let height = textFrame.size.height
//            return CGFloat(height + CGFloat(rowHeight) + 10)
//            
//        }else{
//            return CGFloat(rowHeight)
//        }
        
    }
    
    
}

func ConfigureCell(cell: UIProductAndRemarkTableViewCell, showRightButton:Bool, product: Product, delegate: UIProductAndRemarkTableViewCellDelegate?){
    cell.product = product
    cell.operationButton.hidden = !showRightButton
    cell.delegate = delegate
    cell.refreshView()
}



protocol UIProductAndRemarkTableViewCellDelegate : NSObjectProtocol {
    
    func productAndRemarkTableViewCellButtonDidClick(cell: UIProductAndRemarkTableViewCell)
}
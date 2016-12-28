//
//  BasicTableViewCell.swift
//  ProductShow
//
//  Created by s on 15/11/10.
//  Copyright © 2015年 zhiwx. All rights reserved.
//

import Foundation
import UIKit

class BasicTableViewCell: UITableViewCell {
    
    static let rowHeight = 76
    var delegate: BasicTableViewCellDelegate?
    var indexPath: IndexPath?
    
    @IBOutlet var bgView: UIView!
    @IBOutlet var leftLabel: UILabel!
    @IBOutlet var rightLabel: UILabel!
    @IBOutlet var detailButton: UIButton!
    @IBOutlet var accessButton: UIButton!
    
    
    @IBAction func detailButtonAction(_ sender: UIButton) {
        delegate?.basicTableViewCellDetailButtonAction(self)
    }
    
    func initCell(_ delegate: BasicTableViewCellDelegate?, indexPath: IndexPath?, hideRightButtons: Bool){
        self.delegate = delegate
        self.indexPath = indexPath
        self.hideRightButtons(hideRightButtons)
    }
    
    func hideRightButtons(_ hide: Bool){
        rightLabel.isHidden = hide
        detailButton.isHidden = hide
        accessButton.isHidden = hide
    }
    
}

protocol BasicTableViewCellDelegate : NSObjectProtocol {
    
    func basicTableViewCellDetailButtonAction(_ cell: BasicTableViewCell)
}

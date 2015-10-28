//
//  CommenTableViewCell.swift
//  ProductShow
//
//  Created by s on 15/10/28.
//  Copyright © 2015年 zhiwx. All rights reserved.
//

import Foundation
import UIKit

class UICommonTableViewCell : UITableViewCell {
    
    static let rowHeight = 76
    var delegate: UICommonTableViewCellDelegate?
    var indexPath: NSIndexPath?
    
    @IBOutlet var bgView: UIView!
    @IBOutlet var leftLabel: UILabel!
    @IBOutlet var rightLabel: UILabel!
    @IBOutlet var detailButton: UIButton!
    @IBOutlet var accessButton: UIButton!
    
    
    @IBAction func operationButtonAction(sender: UIButton) {
        delegate?.commonTableViewCellDetailButtonAction(self)
    }
    
    func initCell(delegate: UICommonTableViewCellDelegate?, indexPath: NSIndexPath?, hideRightButtons: Bool){
        self.delegate = delegate
        self.indexPath = indexPath
        self.hideRightButtons(hideRightButtons)
    }
    
    func hideRightButtons(hide: Bool){
        rightLabel.hidden = hide
        detailButton.hidden = hide
        accessButton.hidden = hide
    }
    
}

protocol UICommonTableViewCellDelegate : NSObjectProtocol {
    
    func commonTableViewCellDetailButtonAction(cell: UICommonTableViewCell)
}

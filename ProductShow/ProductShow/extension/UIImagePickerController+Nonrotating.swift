//
//  UIImagePickerController+Nonrotating.swift
//  ProductShow
//
//  Created by s on 15/10/23.
//  Copyright © 2015年 gaozgao. All rights reserved.
//

import Foundation
import UIKit

extension UIImagePickerController{
    override public func shouldAutorotate() -> Bool {
//        debugPrint("\(self) \(__FUNCTION__)")
        return true
    }
}

//extension PUUIAlbumListViewController{
//    
//}

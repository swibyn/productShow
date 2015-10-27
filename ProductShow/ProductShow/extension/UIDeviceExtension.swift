//
//  UIDeviceExtension.swift
//  ProductShow
//
//  Created by s on 15/10/27.
//  Copyright © 2015年 zhiwx. All rights reserved.
//

import Foundation
import UIKit
import AdSupport


extension UIDevice{
    
    var advertisingIdentifier: NSUUID!{
        let uuid = ASIdentifierManager.sharedManager().advertisingIdentifier
        return uuid
    }
    
}

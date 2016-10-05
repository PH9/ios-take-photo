//
//  UIUpsideDown.swift
//  takePhoto
//
//  Created by Wasith Theerapattrathamrong on 10/5/2559 BE.
//  Copyright © 2559 Wasith Theerapattrathamrong. All rights reserved.
//

import UIKit

extension UINavigationController {
    
    public override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        return .All
    }
}

extension UITabBarController {
    
    public override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        return .All
    }
}
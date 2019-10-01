//
//  offlineView.swift
//  User
//
//  Created by CSS on 07/05/18.
//  Copyright © 2018 Appoets. All rights reserved.
//

import UIKit
import EFAutoScrollLabel

class offlineView: UIView {
    @IBOutlet var mainView: UIView!
    @IBOutlet var viewAutoScrollNotVerified: EFAutoScrollLabel!

    override func draw(_ rect: CGRect) {
        setAutoScroll()
    }
    
    func setAutoScroll(){
        viewAutoScrollNotVerified.text = Constants.string.accountNotVerifiedYet.localize()
        viewAutoScrollNotVerified.labelSpacing = UIScreen.main.bounds.width
        viewAutoScrollNotVerified.pauseInterval = 2.0
        viewAutoScrollNotVerified.scrollSpeed = 60
        viewAutoScrollNotVerified.textAlignment = .left
        viewAutoScrollNotVerified.fadeLength = 0
        viewAutoScrollNotVerified.scrollDirection = .left
        viewAutoScrollNotVerified.font = UIFont(name: FontCustom.bold.rawValue, size: 18)
        viewAutoScrollNotVerified.observeApplicationNotifications()
        viewAutoScrollNotVerified.isUserInteractionEnabled = false
        mainView.addSubview(viewAutoScrollNotVerified)
    }
}

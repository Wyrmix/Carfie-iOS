//
//  DriverHomeIntercator.swift
//  Driver
//
//  Created by Christopher Olsen on 11/12/19.
//  Copyright © 2019 Carfie. All rights reserved.
//

import UIKit

class DriverHomeInteractor {
    
    weak var viewController: HomepageViewController?
    
    init() {
        
    }
    
    func showAddDocuments() {
        guard viewController?.presentedViewController == nil else { return }
        viewController?.present(DocumentsViewController.viewController(), animated: true)
    }
}

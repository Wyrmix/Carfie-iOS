//
//  RootViewController.swift
//  Carfie
//
//  Created by Christopher Olsen on 10/10/19.
//  Copyright © 2019 Carfie. All rights reserved.
//

import UIKit

/// Protocol for communication between the RootViewController and the RootContainerInteractor.
protocol RootViewControllerDelegate: class {
    func rootViewController(_ viewController: RootViewController, isLoaded: Bool)
}

/// The Root view controller for the app. Provides notification for initial view load so the
/// AppDelegate can trigger additional presents and loads.
final class RootViewController: UIViewController {
    
    weak var delegate: RootViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        delegate?.rootViewController(self, isLoaded: true)
    }
}

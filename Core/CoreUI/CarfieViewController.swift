//
//  CarfieViewController.swift
//  Carfie
//
//  Created by Christopher Olsen on 10/10/19.
//  Copyright © 2019 Carfie. All rights reserved.
//

import UIKit

extension UIViewController {
    
    // TODO: I hate this and it needs to go away at some point.
    @objc func popOrDismiss(animation: Bool = true) {
        DispatchQueue.main.async {
            if self.navigationController != nil {
                self.navigationController?.popViewController(animated: animation)
            } else {
                self.dismiss(animated: animation, completion: nil)
            }
        }
    }
}

//
//  UserFacingErrorIntent.swift
//  Carfie
//
//  Created by Christopher Olsen on 10/7/19.
//  Copyright © 2019 Carfie. All rights reserved.
//

import UIKit

protocol ErrorIntent {
    var alertController: UIAlertController { get }
    
    func execute(via presenter: UIViewController)
}

extension ErrorIntent {
    func execute(via presenter: UIViewController) {
        presenter.present(alertController, animated: true)
    }
}

class UserFacingErrorIntent: ErrorIntent {
    let alertController: UIAlertController
    
    init(title: String, message: String, action: ((UIAlertAction) -> Void)? = nil) {
        alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Ok", style: .default, handler: action))
    }
}

class UserFacingErrorRetryIntent: ErrorIntent {
    let alertController: UIAlertController
    
    init(title: String, message: String, action: ((UIAlertAction) -> Void)? = nil, retry: ((UIAlertAction) -> Void)?) {
        alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: action))
        alertController.addAction(UIAlertAction(title: "Retry", style: .default, handler: retry))
    }
}

class UserFacingDestructiveErrorIntent: ErrorIntent {
    let alertController: UIAlertController
    
    init(title: String, message: String, destructiveTitle: String, action: ((UIAlertAction) -> Void)? = nil, destructiveAction: ((UIAlertAction) -> Void)?) {
        alertController = UIAlertController()
        alertController.title = title
        alertController.message = message
        alertController.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: action))
        alertController.addAction(UIAlertAction(title: destructiveTitle, style: .destructive, handler: destructiveAction))
    }
}

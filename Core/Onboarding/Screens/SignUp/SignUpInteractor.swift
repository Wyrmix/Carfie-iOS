//
//  SignUpInteractor.swift
//  Carfie
//
//  Created by Christopher Olsen on 10/26/19.
//  Copyright © 2019 Carfie. All rights reserved.
//

import Foundation

class SignUpInteractor {
    weak var viewController: CarfieSignUpViewController?
    
    private let theme: AppTheme
    
    init(theme: AppTheme) {
        self.theme = theme
    }
}

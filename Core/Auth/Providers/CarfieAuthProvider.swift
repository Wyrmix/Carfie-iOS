//
//  CarfieAuthProvider.swift
//  Carfie
//
//  Created by Christopher Olsen on 11/1/19.
//  Copyright © 2019 Carfie. All rights reserved.
//

import UIKit

final class CarfieAuthProvider: AuthProvider {
    
    let type: AuthProviderType = .carfie
    
    weak var delegate: AuthProviderDelegate?
    
    func login(withPresentingViewController viewController: UIViewController) {
        
    }
    
    func logout() {
        
    }
    
    func getAccessToken(completion: @escaping (String?) -> Void) {
        
    }
}

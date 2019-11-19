//
//  DriverIdentificationInteractor.swift
//  Driver
//
//  Created by Christopher Olsen on 11/18/19.
//  Copyright © 2019 Carfie. All rights reserved.
//

import Foundation

class DriverIdentificationInteractor {
    weak var viewController: DriverIdentificationViewController?
    
    let profileController: ProfileController
    
    init(profileController: ProfileController = CarfieProfileController()) {
        self.profileController = profileController
    }
    
    func saveSocialSecurityNumber(_ ssn: String?) {
        do {
            let ssn = try SSNValidator().validate(ssn).resolve()
            updateProfileWithSSN(ssn)
        } catch {
            return
        }
    }
    
    private func updateProfileWithSSN(_ ssn: String) {
        viewController?.animateNetworkActivity(true)
        
        profileController.updateSSN(ssn) { result in
            self.viewController?.animateNetworkActivity(false)
            
            switch result {
            case .success:
                self.viewController?.onboardingDelegate?.onboardingScreenComplete()
            case .failure:
                UserFacingErrorIntent(title: "Something went wrong", message: "Please try again.").execute(via: self.viewController)
            }
        }
    }
}

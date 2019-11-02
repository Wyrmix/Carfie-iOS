//
//  MockOnboardingDelegate.swift
//  CoreTests
//
//  Created by Christopher Olsen on 10/17/19.
//  Copyright © 2019 Carfie. All rights reserved.
//

import Foundation

class MockOnboardingDelegate: OnboardingDelegate {
    var onboardingWillCompleteWasCalled = false
    
    func onboardingWillComplete() {
        onboardingWillCompleteWasCalled = true
    }
    
    func showLogin() {}
}

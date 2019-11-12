//
//  OnboardingInteractorSpec.swift
//  CoreTests
//
//  Created by Christopher Olsen on 10/17/19.
//  Copyright © 2019 Carfie. All rights reserved.
//

import Nimble
import Quick
import UIKit

class OnboardingInteractorSpec: QuickSpec {
    override func spec() {
        describe("An OnboardingInteractor") {
            var subject: OnboardingInteractor!
            
            let viewControllerOne = MockOnboardingScreen(withTitle: "Screen One")
            let viewControllerTwo = MockOnboardingScreen(withTitle: "Screen Two")
            
            let viewControllers = [
                viewControllerOne,
                viewControllerTwo
            ]
            
            beforeEach {
                let configuration = MockWelcomeConfiguration(viewControllers: viewControllers)
                subject = OnboardingInteractor(configuration: configuration)
            }
            
            context("init") {
                it("should set itself as the delegate of the first view controller") {
                    expect(subject).to(beIdenticalTo(viewControllerOne.onboardingDelegate))
                }
            }
            
            context("completing onboading screen") {
                it("should present the next screen") {
                    subject.onboardingScreenComplete()
                    // should set the next onboaring screen as its delegate
                    expect(subject).to(beIdenticalTo(viewControllerTwo.onboardingDelegate))
                }
                
                it("should end onboarding if there are no remaining screens") {
                    let delegate = MockOnboardingDelegate()
                    subject.delegate = delegate
                    
                    // complete all screen
                    subject.onboardingScreenComplete()
                    subject.onboardingScreenComplete()
                    
                    expect(delegate.onboardingWillCompleteWasCalled).to(beTrue())
                }
            }
        }
    }
}

//
//  RootContainerInteractorSpec.swift
//  CoreTests
//
//  Created by Christopher Olsen on 10/9/19.
//  Copyright © 2019 Carfie. All rights reserved.
//

import Nimble
import Quick
import UIKit

class RootContainerInteractorSpec: QuickSpec {
    override func spec() {
        describe("A RootContainerInteractor") {
            var subject: RootContainerInteractor!
            
            beforeEach {
                subject = RootContainerInteractor()
                subject.configureRootViewController(RootViewController())
            }
            
            context("on start") {
                it("should load the childViewController as a child of the rootViewController") {
                    subject.configureChildViewController(UIViewController())
                    subject.start()
                    expect(subject.rootViewController!.children.first!).toNot(beNil())
                }
            }
            
            context("on logout") {
                it("should unload the child view controller if one exists") {
                    subject.configureChildViewController(UIViewController())
                    subject.configureLoginViewController(UIViewController())
                    NotificationCenter.default.post(name: .UserDidLogout, object: nil)
                    expect(subject.rootViewController!.children.first).to(beNil())
                }
            }
            
            context("on login dismissal") {
                it("should load the childViewController as a child of the rootViewController") {
                    subject.configureChildViewController(UIViewController())
                    subject.dismissLoginExperience()
                    expect(subject.rootViewController!.children.first!).toNot(beNil())
                }
            }
        }
    }
}

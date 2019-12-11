//
//  VehicleYearValidatorSpec.swift
//  CoreTests
//
//  Created by Christopher Olsen on 12/11/19.
//  Copyright © 2019 Carfie. All rights reserved.
//

import Nimble
import Quick

class VehicleYearValidatorSepc: QuickSpec {
    override func spec() {
        describe("A VehicleYearValidator") {
            var subject: VehicleYearValidator!
            
            beforeEach {
                subject = VehicleYearValidator()
            }
            
            it("should return a year if the year is a valid year") {
                expect { try subject.validate("1985").resolve() }.to(equal("1985"))
            }
            
            it("should throw and error if the year is not a valid year") {
                expect { try subject.validate("1245abc").resolve() }.to(throwError(VehicleYearValidationError.notAValidYear))
            }
            
            it("should throw and error if no year is entered") {
                expect { try subject.validate(nil).resolve() }.to(throwError(VehicleYearValidationError.noYearEntered))
            }
        }
    }
}

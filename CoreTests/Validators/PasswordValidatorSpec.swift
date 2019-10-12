//
//  PasswordValidatorSpec.swift
//  CoreTests
//
//  Created by Christopher Olsen on 10/12/19.
//

import Nimble
import Quick

class PasswordValidatorSpec: QuickSpec {
    override func spec() {
        describe("A PasswordValidator") {
            var subject: PasswordValidator!
            
            beforeEach {
                subject = PasswordValidator()
            }
            
            it("should throw an error if the password is nil") {
                expect { try subject.validate(nil).resolve() }.to(throwError(PasswordValidationError.empty))
            }
            
            it("should throw an error if the password is less than 8 characters") {
                expect { try subject.validate("P4sswor").resolve() }.to(throwError(PasswordValidationError.tooShort))
            }
            
            it("should throw an error if the password does not have an uppercase letter") {
                expect { try subject.validate("p4ssword").resolve() }.to(throwError(PasswordValidationError.invalidPassword))
            }
            
            it("should throw an error if the password does not have a number") {
                expect { try subject.validate("Password").resolve() }.to(throwError(PasswordValidationError.invalidPassword))
            }
            
            it("should pass validation is the password meets all requirements") {
                expect { try subject.validate("P4ssword").resolve() }.to(equal("P4ssword"))
            }
        }
    }
}

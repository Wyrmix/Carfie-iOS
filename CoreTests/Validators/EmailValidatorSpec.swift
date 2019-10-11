//
//  AuthValidatorSpec.swift
//  CarfieCoreTests
//
//  Created by Christopher Olsen on 9/25/19.
//  Copyright © 2019 espy. All rights reserved.
//

import Nimble
import Quick

class EmailValidatorSpec: QuickSpec {
    override func spec() {
        describe("An EmailValidator") {
            var subject: EmailValidator!

            beforeEach {
                subject = EmailValidator()
            }

            it("with an empty email should throw an error") {
                expect { try subject.validate(nil).resolve() }.to(throwError(EmailValidationError.noEmailEntered))
            }

            it("with no '@' should throw an error") {
                expect { try subject.validate("emailemail.com").resolve() }.to(throwError(EmailValidationError.notAValidEmail))
            }

            it("with no '.' should throw an error") {
                expect { try subject.validate("email@email").resolve() }.to(throwError(EmailValidationError.notAValidEmail))
            }

            it("with proper formatting should pass validation") {
                expect { try subject.validate("email@email.io").resolve() }.to(equal("email@email.io"))
            }
            
            it("should trim whitespace"){
                expect { try subject.validate(" email@email.io ").resolve() }.to(equal("email@email.io"))
            }
        }
    }
}

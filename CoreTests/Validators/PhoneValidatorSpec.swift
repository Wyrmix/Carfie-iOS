//
//  PhoneValidatorSpec.swift
//  CoreTests
//
//  Created by Christopher Olsen on 10/10/19.
//  Copyright © 2019 Carfie. All rights reserved.
//

import Nimble
import Quick

class PhoneValidatorSpec: QuickSpec {
    override func spec() {
        describe("A PhoneValidator") {
            var subject: PhoneValidator!
            
            beforeEach {
                subject = PhoneValidator()
            }
            
            context("phone number") {
                it("that is nil should throw an error") {
                    expect { try subject.validate(nil).resolve() }.to(throwError(PhoneValidationError.noPhoneNumberEntered))
                }
                
                it("without exactly 10 characters should throw an error") {
                    expect { try subject.validate("1234567").resolve() }.to(throwError(PhoneValidationError.notAValidPhoneNumber))
                }
                
                it("with non-numerical items should throw an error") {
                    expect { try subject.validate("123ad45-").resolve() }.to(throwError(PhoneValidationError.notAValidPhoneNumber))
                }
                
                it("with 10 numerical characters should pass validation") {
                    expect { try subject.validate("1234567890").resolve() }.to(equal("1234567890"))
                }
                
                context("with typical phone number symbols: '()-' or whitespace") {
                    it("should strip symbols and pass validation if valid phone number remains") {
                        expect { try subject.validate(" (123) 456-7890 ").resolve() }.to(equal("1234567890"))
                    }
                    
                    it("should still fail if remaining characters are not valid") {
                        expect { try subject.validate("(123) 123-abcd").resolve() }.to(throwError(PhoneValidationError.notAValidPhoneNumber))
                    }
                }
            }
        }
    }
}

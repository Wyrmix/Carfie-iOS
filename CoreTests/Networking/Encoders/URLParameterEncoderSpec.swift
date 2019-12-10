//
//  URLParameterEncoderSpec.swift
//  CoreTests
//
//  Created by Christopher Olsen on 12/4/19.
//  Copyright © 2019 Carfie. All rights reserved.
//

import Nimble
import Quick

class URLParameterEncoderSpec: QuickSpec {
    override func spec() {
        describe("A URLParameterEncoder") {
            var subject: URLParameterEncoder!
            
            beforeEach {
                subject = URLParameterEncoder()
            }
            
            it("should encode parameters and add them as a query string") {
                let url = URL(string: "https://google.com")!
                var request = URLRequest(url: url)
                let parameters = ["locale": "en_US"]

                subject.encode(request: &request, with: parameters)

                expect(request.url?.absoluteString).to(equal("https://google.com?locale=en_US"))
            }
            
            it("should assert if the request does not have a URL") {
                let url = URL(string: "https://google.com")!
                var request = URLRequest(url: url)
                request.url = nil
                let parameters = ["locale": "en_US"]
                
                expect { subject.encode(request: &request, with: parameters) }.to(throwAssertion())
            }
        }
    }
}

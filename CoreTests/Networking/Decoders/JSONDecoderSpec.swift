//
//  JSONDecoderSpec.swift
//  CoreTests
//
//  Created by Christopher Olsen on 12/4/19.
//  Copyright © 2019 Carfie. All rights reserved.
//

import Nimble
import Quick

class JSONResponseDecoderSpec: QuickSpec {
    override func spec() {
        describe("A JSONResponseDecoder") {
            var subject: JSONResponseDecoder!
            
            beforeEach {
                subject = JSONResponseDecoder()
            }
            
            it("should decode JSON data to an object") {
                let mockData = Data(("{\"id\": 6}").utf8)
                let decodedObject: MockDecodableObject = try! subject.decode(from: mockData)
                expect(decodedObject).to(beAKindOf(MockDecodableObject.self))
                expect(decodedObject.id).to(be(6))
            }
            
            it("should throw an error if the object cannot be decoded") {
                let mockData = Data(("{\"id\": \"not_an_integer\"}").utf8)
                expect { try subject.decode(from: mockData) as MockDecodableObject }.to(throwError())
            }
        }
    }
}

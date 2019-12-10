//
//  ServiceSpec.swift
//  CoreTests
//
//  Created by Christopher Olsen on 12/5/19.
//  Copyright © 2019 Carfie. All rights reserved.
//

import Nimble
import Quick

class NetworkServiceSpec: QuickSpec {
    override func spec() {
        describe("A NetworkService") {
            var subject: NetworkService!
            var configuration: ServiceConfiguration!
            var session: MockNetworkSession!
            
            beforeEach {
                configuration = MockServiceConfiguration()
                session = MockNetworkSession()
                subject = DefaultNetworkService(configuration: configuration, session: session)
            }
            
            context("request") {
                it("should call the completion with a failure result if an error occurs.") {
                    var result: Result<MockDecodableObject>!
                    
                    session.error = MockNetworkError.internalServerError
                    subject.request(MockNetworkRequest()) { r in
                        result = r
                    }
                    
                    expect(result).toEventually(equal(.failure(MockNetworkError.internalServerError)))
                }
                
                it("should call the completion with a success result if the request succeeds.") {
                    var result: Result<MockDecodableObject>!
                    
                    session.data = Data(("{\"id\": 6}").utf8)
                    subject.request(MockNetworkRequest()) { r in
                        result = r
                    }
                    
                    expect(result).toEventually(equal(.success(MockDecodableObject(id: 6))))
                }
                
                it("should call the completion with a failure result if the response decoding fails.") {
                    var result: Result<MockDecodableObject>!
                    
                    session.data = Data(("{\"quantity\": 6}").utf8)
                    subject.request(MockNetworkRequest()) { r in
                        result = r
                    }
                    
                    expect(result).toEventually(equal(.failure(MockNetworkError.internalServerError)))
                }
            }
        }
    }
}

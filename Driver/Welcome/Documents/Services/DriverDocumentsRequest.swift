//
//  DriverDocumentsRequest.swift
//  Driver
//
//  Created by Christopher Olsen on 10/20/19.
//  Copyright © 2019 Carfie. All rights reserved.
//

import Foundation

struct DriverDocumentsRequest: NetworkRequest {
    typealias Response = DriverDocumentList

    let path = "/api/provider/profile/documents"
    let method: HTTPMethod = .GET
    let headers: HTTPHeaders? = nil
}

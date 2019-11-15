//
//  GetCardsResponse.swift
//  Carfie
//
//  Created by Christopher Olsen on 11/13/19.
//  Copyright © 2019 Carfie. All rights reserved.
//

import Foundation

// The GET cards endpoint response returns a root level array with no key. This typealias is a helpful
// wrapper to give us a type we can pass around for associatedTypes with NetworkRequests.
typealias GetCardsResponse = [CarfieCard]

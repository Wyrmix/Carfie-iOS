//
//  AppData.swift
//  User
//
//  Created by CSS on 10/01/18.
//  Copyright © 2018 Appoets. All rights reserved.
//

import UIKit

let AppName = "Carfie Driver"
var deviceTokenString = Constants.string.noDevice
var deviceId = Constants.string.noDevice
let appSecretKey = "HXX00MQv8IQncJqlk8MmJGLPcPRxtdPXNcSxznUy" // this isn't currently used in the driver app, but leaving it here in case we need it in the future
let appClientId = 2
let helpPhoneNumber = "1098"
let defaultMapLocation = LocationCoordinate(latitude: 13.009245, longitude: 80.212929)

/// Base API url for the app. This should eventually get refactored into the networking layer.
let baseUrl = "https://sapi.carfie.com/"

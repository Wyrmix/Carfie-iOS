//
//  AppData.swift
//  User
//
//  Created by CSS on 10/01/18.
//  Copyright © 2018 Appoets. All rights reserved.
//

import UIKit

let AppName = "Carfie"
var deviceTokenString = Constants.string.noDevice

/// This is a required parameter for sign up. It appears to be used no other place.
let appSecretKey = "HXX00MQv8IQncJqlk8MmJGLPcPRxtdPXNcSxznUy"

let appClientId = 2
let defaultMapLocation = LocationCoordinate(latitude: 13.009245, longitude: 80.212929)
let baseUrl = "https://sapi.carfie.com/"
let passwordLengthMax = 10
let requestCheckInterval : TimeInterval = 5
var offlineNumber = "57777"
let requestInterval : TimeInterval = 60  // seconds

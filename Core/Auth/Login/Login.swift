//
//  Login.swift
//  Carfie
//
//  Created by Christopher Olsen on 11/11/19.
//

import Foundation

struct Login: Codable {
    let email: String // used by driver app
    let username: String // used by rider app
    let password: String
    
    let clientId = 2
    let clientSecret = "HXX00MQv8IQncJqlk8MmJGLPcPRxtdPXNcSxznUy"
    
    // TECH-DEBT: These values are necessary for a successful sign up, but never seem to get used.
    // For now I'm hardcoding the values the app has been using.
    let deviceId: String = UUID().uuidString // this should eventually be made something idetifiable and unique
    let deviceToken: String = "no device"
    let deviceType: String = "ios"
    let loginBy: String = "manual"
    
    enum CodingKeys: String, CodingKey {
        case email
        case username
        case password
        case deviceId = "device_id"
        case deviceToken = "device_token"
        case deviceType = "device_type"
        case loginBy = "login_by"
        case clientId = "client_id"
        case clientSecret = "client_secret"
    }
}

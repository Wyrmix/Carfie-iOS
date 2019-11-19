//
//  MakeJson.swift
//  User
//
//  Created by CSS on 11/01/18.
//  Copyright © 2018 Appoets. All rights reserved.
//

import UIKit

class MakeJson {
    
    // MARK:- SignUp
    
   class func signUp(loginBy : LoginType = .manual, email : String?, password : String?, socialId : String? = nil, firstName : String?, lastName : String?, mobile : Int?)->UserData {
        
        let userDataObject = UserData()
        userDataObject.device_id = UUID().uuidString
        userDataObject.device_token = deviceTokenString
        userDataObject.device_type = .ios
        userDataObject.email = email
        userDataObject.first_name = firstName
        userDataObject.last_name = lastName
        userDataObject.login_by = loginBy
        userDataObject.mobile = mobile 
        userDataObject.password = password
        userDataObject.social_unique_id = socialId
    
//        var json = userDataObject.JSONRepresentation
//
//        if socialId == nil {
//
//            json.removeValue(forKey: "social_unique_id")
//        }
    
        return userDataObject
        
    }
    
    
    // MARK:- Login
    
   class func login(withUser userName : String?, password : String?) -> Data?{
        
        var loginData = LoginRequest()
        
        loginData.client_id = CarfieKey.appClientId
        loginData.client_secret = CarfieKey.appSecretKey
        loginData.grant_type = WebConstants.string.password
        loginData.password = password
        loginData.username = userName
        loginData.device_id = UUID().uuidString
        loginData.device_type = .ios
        loginData.device_token = deviceTokenString
        return loginData.toData()
    }
   
}



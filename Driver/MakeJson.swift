//
//  MakeJson.swift
//  User
//
//  Created by CSS on 11/01/18.
//  Copyright © 2018 Appoets. All rights reserved.
//

import UIKit

class MakeJson {
    
    class func SingUp(firstName : String, lastName: String, email: String, mobile: Int, password: String, ConfirmPassword: String,device_Id: String, device_type: String, device_token: String) -> UserData {
        
        var userdata = UserData()
        userdata.email = email
        userdata.first_name = firstName
        userdata.last_name = lastName
        userdata.mobile = "\(mobile)"
        userdata.password = password
        userdata.password_confirmation = ConfirmPassword
        userdata.device_id = device_Id
        userdata.device_token = device_token
        userdata.device_type = device_type
        
        return userdata
    
    }
    
    
    class func login(email: String, password: String, deviceId: String, deviceType: String,deviceToken: String)-> Data{
        
        var loginmodel = LoginModel()
        
        loginmodel.email = email
        loginmodel.password = password
        loginmodel.device_id = deviceId
        loginmodel.device_token = deviceToken
        loginmodel.device_type = deviceType
        
        return loginmodel.toData()!
        
    }
    
    class func  resetPassword(password:  String, confirmPassword: String, oldPassword: String )-> Data{
        
        return resetPasswordModel(password: password, password_confirmation: confirmPassword, password_old: oldPassword).toData()!
        
    }
    
    class func updateLoaction(latitute: Double?, lontitute: Double?)-> Data{
        
        return updateLocationModel(latitude: latitute, longitude: lontitute).toData()!
    }
    
    class func OnlineStatus(status: String?)-> Data{
        
        return OnlinestatusModel(service_status: status).toData()!
    }
    
    class func UpdateTripStatus(tripStatus: String)-> Data {
        return UpdateTripStatusModel(status: tripStatus, _method: "PATCH").toData()!
    }
    
    class func invoiceUpdate(rating: Int?, comment: String?)-> Data{
        return InvoiceModel(rating: rating, comment: comment ).toData()!
        
        
    }
   
}



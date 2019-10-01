//
//  Profile.swift
//  User
//
//  Created by CSS on 31/05/18.
//  Copyright © 2018 Appoets. All rights reserved.
//

import Foundation

class Profile : JSONSerializable {
    
    var id : Int?
    var first_name : String?
    var last_name : String?
    var email : String?
    var mobile : String?
    var avatar : String?
    var device_token : String?
    var access_token : String?
    var currency : String?
    var service : ServiceModel?
    var serviceID : Int?
    var wallet_balance : Float?
    var measurement : String?
    var profile : LocalizationEntity?
    var card : Int?
    var cash : Int?
    var stripe_secret_key : String?
    var stripe_publishable_key : String?
    
//    public func encode(to encoder: Encoder) throws {
//
//        var container =  encoder.container(keyedBy: CodingKeys.self)
//        try container.encode(id, forKey: .id)
//        try container.encode(first_name, forKey: .first_name)
//        try container.encode(last_name, forKey: .last_name)
//        try container.encode(email, forKey: .email)
//        try container.encode(mobile, forKey: .mobile)
//        try container.encode(avatar, forKey: .avatar)
//        try container.encode(device_token, forKey: .device_token)
//        try container.encode(access_token, forKey: .access_token)
//        try container.encode(service, forKey: .service)
//        try container.encode(serviceID, forKey: .service)
//        try container.encode(currency, forKey: .currency)
//        try container.encode(wallet_balance, forKey: .wallet_balance)
//        try container.encode(measurement, forKey: .measurement)
//        try container.encode(profile, forKey: .profile)
//        try container.encode(card, forKey: .card)
//        try container.encode(cash, forKey: .cash)
//        try container.encode(stripe_secret_key, forKey: .stripe_secret_key)
//        try container.encode(stripe_publishable_key, forKey: .stripe_publishable_key)
//
//    }

    
//
//    required init(from decoder: Decoder) throws {
//
//        let values = try decoder.container(keyedBy: CodingKeys.self)
//        id = try? values.decode(Int.self, forKey: .id)
//        first_name = try? values.decode(String.self, forKey: .first_name)
//        last_name = try? values.decode(String.self, forKey: .last_name)
//        email = try? values.decode(String.self, forKey: .email)
//        mobile = try? values.decode(String.self, forKey: .mobile)
//        avatar = try? values.decode(String.self, forKey: .avatar)
//        device_token = try? values.decode(String.self, forKey: .device_token)
//        access_token = try? values.decode(String.self, forKey: .access_token)
//        service = try? values.decode(ServiceModel.self , forKey: .service)
//        serviceID = try? values.decode(Int.self, forKey: .service)
//
//    }
    
    
    init() {   }

}


struct ServiceModel: JSONSerializable {
    var service : Int?
    var provider_id : Int?
    var service_type : ServiceTypeModel?
    
    
}

struct ServiceTypeModel : JSONSerializable {
    var name: String?
    var id : Int?
}


struct LocalizationEntity : JSONSerializable {
    var language : Language?
}






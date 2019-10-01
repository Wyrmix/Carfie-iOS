//
//  UpdateTripStatusModel.swift
//  User
//
//  Created by CSS on 23/05/18.
//  Copyright © 2018 Appoets. All rights reserved.
//

import Foundation

struct UpdateTripStatusModel: JSONSerializable {
    
    var status : String?
    var _method : String?
    
}

struct UpdateTripStatusModelResponse: JSONSerializable {
    var error: String?
    var id : Int?
    var booking_id : String?
    var user_id : Int?
    var status : String?
    var payment_mode : String?
    var paid : Int?
    var distance : Int?
    var s_address : String?
    var s_latitude: Double?
    var s_longitude : Double?
    var d_address: String?
    var started_at : String?
    var finished_at: String?
    var static_map : String?
    var user : userUpdateDeatil?
}

struct userUpdateDeatil: JSONSerializable {
    //    var device_id : String?
    //    var device_token: String?
    //    var device_type: String?
    //    var email : String?
    var first_name: String?
    var id: Int?
    var last_name : String?
    var rating : String?
    //    var mobile: Int?
    //    var picture: String?
    //    var stripe_cust_id: String?
    //    var wallet_balance: Int?
    //    var user_id: Int?
    //    var request_id: Int?
    //    var status : Int?
    
    
}

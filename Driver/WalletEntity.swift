//
//  WalletEntity.swift
//  Provider
//
//  Created by CSS on 20/09/18.
//  Copyright © 2018 Appoets. All rights reserved.
//

import Foundation

struct WalletEntity : JSONSerializable {
    var wallet_transation : [WalletTransaction]?
    var wallet_balance : Float?
    var amount : Float?
    var type : UserType?
    var pendinglist : [WalletTransaction]?
}

struct WalletTransaction : JSONSerializable {
    var transaction_alias : String?
    var transaction_desc : String?
    var type : TransactionType?
    var amount : Float?
    var created_at : String?
    var alias_id : String?
    var id : Int?
}



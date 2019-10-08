//
//  CredentialRevoker.swift
//  Carfie
//
//  Created by Christopher Olsen on 10/7/19.
//  Copyright © 2019 Carfie. All rights reserved.
//

import FacebookCore

protocol CredentialRevoker {
    func revoke(completion: @escaping (Error?) -> Void)
}

struct FacebookCredentialRevoker: CredentialRevoker {
    func revoke(completion: @escaping (Error?) -> Void) {
        let connection = GraphRequestConnection()
        let request = GraphRequest(graphPath: "/me/permissions", httpMethod: .delete)
        
        connection.add(request) { _, _, error in
            completion(error)
        }
        
        connection.start()
    }
}

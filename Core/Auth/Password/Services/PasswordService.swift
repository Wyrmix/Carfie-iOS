//
//  PasswordService.swift
//  Carfie
//
//  Created by Christopher Olsen on 12/12/19.
//  Copyright © 2019 Carfie. All rights reserved.
//

import Foundation

protocol PasswordService {
    func requestPasswordResetOTP(forEmail email: String, completion: @escaping (Result<ForgotPasswordResponse>) -> Void)
    func resetPassword(forUserId id: Int, oldPassword: String, toNewPassword newPassword: String, withConfirmation confirmPassword: String, completion: @escaping (Result<ResetPasswordResponse>) -> Void)
}

class DefaultPasswordService: PasswordService {
    private let service: NetworkService
    
    init(service: NetworkService = DefaultNetworkService()) {
        self.service = service
    }
    
    func requestPasswordResetOTP(forEmail email: String, completion: @escaping (Result<ForgotPasswordResponse>) -> Void) {
        let request = ForgotPasswordRequest(email: email)
        service.request(request) { result in
            completion(result)
        }
    }
    
    func resetPassword(forUserId id: Int, oldPassword: String, toNewPassword newPassword: String, withConfirmation confirmPassword: String, completion: @escaping (Result<ResetPasswordResponse>) -> Void) {
        let passwordData = ChangePasswordData(id: id, oldPassword: oldPassword, newPassword: newPassword, confirmPassword: confirmPassword)
        let request = ResetPasswordRequest(changePasswordData: passwordData)
        service.request(request) { result in
            completion(result)
        }
    }
}

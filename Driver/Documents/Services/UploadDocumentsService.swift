//
//  UploadDocumentsService.swift
//  Driver
//
//  Created by Christopher Olsen on 11/10/19.
//  Copyright © 2019 Carfie. All rights reserved.
//

import Alamofire
import Foundation

protocol UploadImageDataService {
    func uploadImages(_ imageData: [String: Data], parameters: [String: Any], completion: @escaping (Result<DriverDocumentList>) -> Void)
}

/// This is a temporary network service that uses Alamofire's multipart upload functionality to upload images. This is a port of legacy behavior
/// that should be re-examined at some point to determine if it is truly necessary.
class UploadDocumentsService: UploadImageDataService {
    
    let authRepository: AuthRepository
    
    init(authRepository: AuthRepository = DefaultAuthRepository()) {
        self.authRepository = authRepository
    }
    
    func uploadImages(_ imageData: [String: Data], parameters: [String: Any], completion: @escaping (Result<DriverDocumentList>) -> Void) {
        // Pretty much everything in this functions was lifted from the legacy webservice and thus I'm not really sure how much of it is necessary
        // but it does work. 
        
        guard let url = URL(string: baseUrl + "/api/provider/profile/documents/store") else {
            fatalError("Invalid URL. Something is wrong with the baseUrl if you got here.")
        }
        
        guard let accessToken = authRepository.auth.accessToken else {
            assertionFailure("Access token should not be nil.")
            return
        }
        
        var headers = HTTPHeaders()
        headers.updateValue(WebConstants.string.XMLHttpRequest, forKey: WebConstants.string.X_Requested_With)
        headers.updateValue("Bearer \(accessToken)", forKey: WebConstants.string.Authorization)
        
        Alamofire.upload(multipartFormData: { (multipartFormData) in
            for (key, value) in parameters {
                multipartFormData.append("\(value)".data(using: String.Encoding.utf8)!, withName: key)
            }
            for data in imageData {
                multipartFormData.append(data.value, withName: data.key, fileName: "image.png", mimeType: "image/png")
            }
        }, usingThreshold: UInt64.init(), to: url, method: .post, headers: headers) { result in
            switch result {
            case .success(let upload, _, _):
                upload.responseData { response in
                    let decoder = JSONDecoder()
                    let result: Result<DriverDocumentList> = decoder.decodeResponse(from: response)
                    completion(result)
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}

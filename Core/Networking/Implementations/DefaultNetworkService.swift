//
//  DefaultNetworkService.swift
//  Carfie
//
//  Created by Christopher Olsen on 10/20/19.
//  Copyright © 2019 Carfie. All rights reserved.
//

import Foundation

class DefaultNetworkService: NetworkService {
    
    private var task: URLSessionTask?
    private var authRepository: AuthRepository
    
    init(authRepository: AuthRepository = DefaultAuthRepository()) {
        self.authRepository = authRepository
    }
    
    /// Send a network request using URLSession shared session. The request is built from a NetworkRequest object.
    ///
    /// - Parameters:
    ///   - endpoint: object containing configuration for the request
    ///   - completion: called on success or failure
    func request<T: NetworkRequest>(_ request: T, completion: @escaping (Result<T.Response>) -> Void) {
        let session = URLSession.shared
        do {
            let request = try buildRequest(from: request)
            task = session.dataTask(with: request) { (data, response, error) in
                guard error == nil else {
                    DispatchQueue.main.async {
                        completion(.failure(error!))
                    }
                    return
                }
                
                do {
                    guard let data = data else { return }
                    let response: T.Response = try JSONParser.parse(data: data)
                    DispatchQueue.main.async {
                        completion(.success(response))
                    }
                } catch {
                    DispatchQueue.main.async {
                        completion(.failure(error))
                    }
                }
            }
        } catch {
            DispatchQueue.main.async {
                completion(.failure(error))
            }
        }
        
        task?.resume()
    }
    
    /// Cancels the active session task. e.g. to end long running tasks
    func cancel() {
        task?.cancel()
    }
    
    private func buildRequest<T: NetworkRequest>(from request: T) throws -> URLRequest {
        var urlRequest = URLRequest(url: request.baseURL.appendingPathComponent(request.path),
                                 cachePolicy: .useProtocolCachePolicy,
                                 timeoutInterval: 10.0)
        urlRequest.httpMethod = request.method.rawValue
        urlRequest.httpBody = request.body
        
        // TECH-DEBT: refactor after updating how User model is handled
        if request.isAuthorizedRequest, let token = authRepository.auth.accessToken {
            urlRequest.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }
        
        addAdditionalHeaders(request.headers, request: &urlRequest)
        
        do {
            switch request.task {
            case .request:
                urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
            case .requestParameters(let bodyParameters, let urlParameters):
                try configureParameters(bodyParameters: bodyParameters, urlParameters: urlParameters, request: &urlRequest)
            case .requestParametersAndHeaders(let bodyParameters, let urlParameters, let additionalHeaders):
                addAdditionalHeaders(additionalHeaders, request: &urlRequest)
                try configureParameters(bodyParameters: bodyParameters, urlParameters: urlParameters, request: &urlRequest)
            }
            return urlRequest
        } catch {
            throw error
        }
    }
    
    private func configureParameters(bodyParameters: Parameters?, urlParameters: Parameters?, request: inout URLRequest) throws {
        do {
            if let bodyParameters = bodyParameters {
                try JSONParameterEncoder.encode(request: &request, with: bodyParameters)
            }
            
            if let urlParameters = urlParameters {
                try URLParameterEncoder.encode(request: &request, with: urlParameters)
            }
        } catch {
            throw error
        }
    }
    
    private func addAdditionalHeaders(_ headers: HTTPHeaders?, request: inout URLRequest) {
        guard let headers = headers else { return }
        for (key, value) in headers {
            request.setValue(value, forHTTPHeaderField: key)
        }
    }
}

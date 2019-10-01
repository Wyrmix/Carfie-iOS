//
//  PresenterProcessor.swift
//  User
//
//  Created by imac on 1/1/18.
//  Copyright © 2018 Appoets. All rights reserved.
//

import Foundation

class PresenterProcessor {
    
    
    static let shared = PresenterProcessor()

    
    func success(api : Base, response : Data)->String{
        return .Empty
        
    }
    
    func signUpAuth(data: Data)-> UserData?{
        
        
        return data.getDecodedObject(from: UserData.self)
    }
    
    func login(data: Data)-> LoginModel? {
        
        return data.getDecodedObject(from: LoginModel.self)
    }
    
    
    func resetPassword(data: Data)-> resetPasswordModel? {
        
        return data.getDecodedObject(from: resetPasswordModel.self)
    }
    
    
    func updateLocation(data: Data)-> updateLocationModelResponse?{
        
        return data.getDecodedObject(from: updateLocationModelResponse.self)
    }
    
    func  OnlineStatus(data: Data)-> OnlinestatusModelResponse? {
        
        return data.getDecodedObject(from: OnlinestatusModelResponse.self)
    }
    
    func AcceptStatus(data: Data)-> [AcceptModelReponse]? {
        
        return data.getDecodedObject(from: [AcceptModelReponse].self)
    }
    
    func UpdateTripStatus(data: Data)-> UpdateTripStatusModelResponse? {
        return data.getDecodedObject(from: UpdateTripStatusModelResponse.self)
    }
    
    func getRequestDetails(data: Data)-> GetRequestModelResponse? {
        
        return data.getDecodedObject(from: GetRequestModelResponse.self)
    }
    
    func getRejectAPI(data: Data)-> [RejectModelResponse]? {
        return data.getDecodedObject(from: [RejectModelResponse].self)
    }
    
    func getYourTrip(data: Data)-> [YourTripModelResponse]? {
        
        return data.getDecodedObject(from: [YourTripModelResponse].self)
    }
    
    func getUpcommingTripResponse(data: Data)-> YourTripModelResponse? {
        
        return data.getDecodedObject(from: YourTripModelResponse.self)
    }
    
    //MARK:- UserData
    
    func userData(data : Data)->ForgotResponse? {
        return data.getDecodedObject(from: ForgotResponse.self)
    }
    
    //MARK:- invoice
    
    func invoiceUpdateAPI(data: Data)-> InvoiceModelResponse? {
        return data.getDecodedObject(from: InvoiceModelResponse.self)
    }
    
    func profile(data : Data)->Profile? {
        
        return data.getDecodedObject(from: Profile.self)
    }
    
    func getSummaryAPI(data: Data)-> SummaryModelResponse?{
        return data.getDecodedObject(from: SummaryModelResponse.self)
    }

    func getEarningsAPI(data: Data)-> EarnigsModel?{
        return data.getDecodedObject(from: EarnigsModel.self)
    }
    
    
    func success(api : Base, response : Data)->String? {
        let messageObject = response.getDecodedObject(from: DefaultMessage.self)
        return messageObject?.message ?? messageObject?.success
    }
    
    func faceBookAPI(api: Base, response: Data)-> FacebookLoginModelResponse? {
        return response.getDecodedObject(from: FacebookLoginModelResponse.self)
    }
    
    func getWallet(api : Base, response : Data)->WalletEntity? {
        return response.getDecodedObject(from: WalletEntity.self)
    }
    
    func getDocumentEntity(api : Base, response :Data)->DocumentsEntity? {
        return response.getDecodedObject(from: DocumentsEntity.self)
    }
    
    // MARK:- Get Card
    
    func getCards(data : Data)->[CardEntity] {
        return data.getDecodedObject(from: [CardEntity].self) ?? []
    }
}







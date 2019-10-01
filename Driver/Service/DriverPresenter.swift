//
//  Presenter.swift
//  User
//
//  Created by imac on 12/19/17.
//  Copyright © 2017 Appoets. All rights reserved.
//

import Foundation


class Presenter  {

    var interactor: PostInteractorInputProtocol?
    var controller: PostViewProtocol?
}

//MARK:- Implementation PostPresenterInputProtocol

extension Presenter : PostPresenterInputProtocol {

    func put(api: Base, url: String, data: Data?) {
        interactor?.send(api: api, url: url, data: data, type: .PUT)
    }

    func delete(api: Base, url: String, data: Data?) {
        interactor?.send(api: api, url: url, data: data, type: .DELETE)
    }

    func patch(api: Base, url: String, data: Data?) {
        interactor?.send(api: api, url: url, data: data,type: .PATCH)
    }

    func post(api: Base, data: Data?) {
        interactor?.send(api: api, data: data, paramters: nil, type: .POST)
    }

    func get(api: Base, parameters: [String : Any]?) {
        interactor?.send(api: api, data: nil, paramters: parameters, type: .GET)
    }

    func get(api : Base, url : String){

        interactor?.send(api: api, url: url, data: nil, type: .GET)

    }

    func post(api: Base, imageData: [String : Data]?, parameters: [String : Any]?) {
        interactor?.send(api: api, imageData: imageData, parameters: parameters)
    }


    func post(api: Base, url: String, data: Data?) {
        interactor?.send(api: api, url: url, data: data,type: .POST)
    }

}


//MARK:- Implementation PostPresenterOutputProtocol

extension Presenter : PostPresenterOutputProtocol {
    func sendCardEntityList(api: Base, data: Data) {
        controller?.getCardEnities(api: api, data: PresenterProcessor.shared.getCards(data: data))
    }

    func sendUpcomingResponse(api: Base, data: Data) {
        controller?.getUpcomingtripResponse(api: api, data: PresenterProcessor.shared.getUpcommingTripResponse(data: data))
    }

    func sendFaceBookAPI(api: Base, data: Data) {
        controller?.getFaceBookAPI(api: api, data: PresenterProcessor.shared.faceBookAPI(api: api, response: data))
    }



    func sendSuccess(api: Base, data: Data) {
        controller?.getSucessMessage(api: api, data:  PresenterProcessor.shared.success(api: api, response: data))
    }



    func sendEaringsAPI(api: Base, data: Data) {
        controller?.getEarningsAPI(api: api, data: PresenterProcessor.shared.getEarningsAPI(data: data))
    }


    func sendProfile(api: Base, data: Data) {
        controller?.getProfile(api: api, data: PresenterProcessor.shared.profile(data: data))
    }


    func sendInvoiceData(api: Base, data: Data) {
        controller?.getInvoiceData(api: api, data: PresenterProcessor.shared.invoiceUpdateAPI(data: data))
    }



    func sendYourTripsAPI(api: Base, data: Data) {
        controller?.getYourTripAPI(api: api, data: PresenterProcessor.shared.getYourTrip(data: data))
    }


    func sendRejectAPI(api: Base, data: Data) {
        controller?.getRejectAPI(api: api, data: PresenterProcessor.shared.getRejectAPI(data: data))
    }

    func SendUpdateStatus(api: Base, data: Data) {
        controller?.getUpdateStatus(api: api, data: PresenterProcessor.shared.UpdateTripStatus(data: data))
    }

    func SendAcceptStatus(api: Base, data: Data) {
        controller?.GetAcceptStatus(api: .acceptRequest, data: PresenterProcessor.shared.AcceptStatus(data: data))
    }

    func sendOnlineStatus(api: Base, data: Data) {
        controller?.getOnlineStatus(api: api, data: PresenterProcessor.shared.OnlineStatus(data: data))
    }

    func sendLocationupadate(api: Base, date: Data) {
        controller?.getLoactionUpadate(api: api, data: PresenterProcessor.shared.updateLocation(data: date))
    }

    func sendResetPassword(api: Base, data: Data) {
        controller?.getResetpassword(api: api, data: PresenterProcessor.shared.resetPassword(data: data))
    }


    func sendlogin(api: Base, data: Data) {
        controller?.getLogin(api: api, data: PresenterProcessor.shared.login(data: data))
    }

    func SendAuth(api: Base, data: Data) {
        controller?.getAuth(api: api, data: PresenterProcessor.shared.signUpAuth(data: data))
    }

    func onError(api: Base, error: CustomError) {

        controller?.onError(api: api, message: error.localizedDescription , statusCode: error.statusCode)
    }

    func sendUserData(api: Base, data: Data) {
        controller?.getUserData(api: api, data: PresenterProcessor.shared.userData(data: data))
    }

    func sendSummary(api: Base, data: Data) {
        controller?.getSummary(api: api, data: PresenterProcessor.shared.getSummaryAPI(data: data))
    }

    func sendWalletEntity(api: Base, data: Data) {
        controller?.getWalletEntity(api: api, data: PresenterProcessor.shared.getWallet(api : api, response : data))
    }

    func sendDocumentsEntity(api: Base, data: Data) {
        controller?.getDocumentsEntity(api: api, data: PresenterProcessor.shared.getDocumentEntity(api: api, response: data))
    }



}



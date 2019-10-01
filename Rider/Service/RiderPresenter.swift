//
//  Presenter+Rider.swift
//  Rider
//
//  Created by Christopher Olsen on 9/30/19.
//

import Foundation

class RiderPresenter {
    var interactor: RiderPostInteractorInputProtocol?
    var controller: RiderPostViewProtocol?
}

//MARK:- Implementation PostPresenterInputProtocol
extension RiderPresenter: RiderPostPresenterInputProtocol {

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
extension RiderPresenter: RiderPostPresenterOutputProtocol {

    func sendPromocodeList(api: Base, data: Data) {
        controller?.getPromocodeList(api: api, data: PresenterProcessor.shared.getPromocodes(data: data))
    }

    func sendUserData(api: Base, data: Data) {
        controller?.getUserData(api: api, data: PresenterProcessor.shared.userData(data: data))
    }

    func onError(api: Base, error: CustomError) {

        controller?.onError(api: api, message: error.localizedDescription , statusCode: error.statusCode)
    }

    func sendOath(api: Base, data: Data) {

        controller?.getOath(api: api, data: PresenterProcessor.shared.loginRequest(data: data))
    }

    func sendProfile(api: Base, data: Data) {

        controller?.getProfile(api: api, data: PresenterProcessor.shared.profile(data: data))
    }

    func sendSuccess(api: Base, data: Data) {
        controller?.success(api: api, message: PresenterProcessor.shared.success(api: api, response: data))
    }

    func sendServicesList(api: Base, data: Data) {
        controller?.getServiceList(api: api, data: PresenterProcessor.shared.serviceList(data: data))
    }

    func sendEstimateFare(api: Base, data: Data) {
        controller?.getEstimateFare(api: api, data: PresenterProcessor.shared.estimateFare(data: data))
    }

    func sendRequest(api: Base, data: Data) {
        controller?.getRequest(api: api, data: PresenterProcessor.shared.request(data: data))
    }

    func sendRequestArray(api: Base, data: Data) {
        controller?.getRequestArray(api: api, data: PresenterProcessor.shared.requestArray(data: data))
    }

    func sendLocationService(api: Base, data: Data) {
        controller?.getLocationService(api: api, data: PresenterProcessor.shared.locationService(data: data))
    }

    func sendCouponWallet(api: Base, data: Data) {
        controller?.getCouponWallet(api: api, data: PresenterProcessor.shared.couponWallet(data: data))
    }

    func sendCardEntityList(api: Base, data: Data) {
        controller?.getCardEnities(api: api, data: PresenterProcessor.shared.getCards(data: data))
    }

    func sendWalletEntity(api: Base, data: Data) {
        controller?.getWalletEntity(api: api, data: PresenterProcessor.shared.getWalletEntity(data: data))
    }
}

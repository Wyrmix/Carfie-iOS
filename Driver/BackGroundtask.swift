//
//  BackGroundtask.swift
//  User
//
//  Created by CSS on 23/05/18.
//  Copyright © 2018 Appoets. All rights reserved.
//

import Foundation
import UIKit
import GooglePlaces

class BackGroundTask: NSObject {
    
    private var location : Bind<CLLocationCoordinate2D> = Bind<CLLocationCoordinate2D>(nil)
    static var backGroundInstance = BackGroundTask()
    var userStoredDetail = User()
    var accountStatus : AccountStatus = .none
    var queue = OperationQueue()
    var detailviewStatus  = Bool()
    
    var requestStatus = ""
    var requestStatusStarted = ""
    var requestArrived = ""
    var requestPickedUp = ""
    var requestDropped = ""
    var requesrArray : Int = 0
    var requestCompleted = ""
    var approvedStatus = ""
    var bannedStatus = ""
    var onlineStatus = ""
    var onbordingStatus = ""
    var serviceStatus : ServiceStatus = .NONE
    
    private var completion : ((GetRequestModelResponse)->())?
    //private var onlineStatusCompletion : ((GetRequestModelResponse)->())?
    
    var backGroundTimer = Timer()
    
    func backGround(with location : Bind<CLLocationCoordinate2D>, completion : @escaping ((GetRequestModelResponse)->())){
        self.location = location
        backGroundTimer = Timer.scheduledTimer(withTimeInterval: 5, repeats: true) {
            timer in
            self.completion = completion
            self.callBackGroundAPI()
        }
        
    }
    
    class func refresh(){
        BackGroundTask.backGroundInstance = BackGroundTask()
    }
    
    
}

extension BackGroundTask {
    
    private func getRequestAPI(){
      
        Webservice().retrieve(api: .tripStatus, url: nil, data: nil, imageData: nil, paramters: [Constants.string.latitude:location.value?.latitude ?? 0,Constants.string.longitude:location.value?.longitude ?? 0], type: .GET) { (err, data) in
            
           
            if data != nil, let detail = PresenterProcessor.shared.getRequestDetails(data: data!){
                self.accountStatus = detail.account_status ?? .none
                if detail.account_status == AccountStatus.banned && self.bannedStatus != AccountStatus.banned.rawValue{
                    self.approvedStatus = ""
                    self.onbordingStatus = ""
                    self.bannedStatus = AccountStatus.banned.rawValue
                    self.completion?(detail)
                }else if detail.service_status != self.serviceStatus {
                    self.serviceStatus = detail.service_status ?? .NONE
                    self.completion?(detail)
                }
                
                if detail.account_status == AccountStatus.approved && self.approvedStatus == "" {
                    self.bannedStatus = ""
                    self.approvedStatus = detail.account_status?.rawValue ?? ""
                    self.completion?(detail)

                }else if detail.account_status == AccountStatus.onboarding && self.onbordingStatus == ""{
                    self.bannedStatus = ""
                    self.approvedStatus = ""
                    self.onbordingStatus = detail.account_status?.rawValue ?? ""
                    self.completion?(detail)
                } else if detail.account_status == AccountStatus.pendingCard || detail.account_status == AccountStatus.pendingDocument {
                    self.completion?(detail)
                }
            
                if detail.requests?.count != 0 {
                    let requestDetail = detail.requests![0]
                
                    if requestDetail.request?.status == requestType.searching.rawValue && self.requestStatus != requestType.searching.rawValue{//"STARTED"
                        self.requestStatus = (requestDetail.request?.status)!
                        self.completion?(detail)
                    }else if requestDetail.request?.status == requestType.started.rawValue && self.requestStatusStarted != requestType.started.rawValue  { //"SEARCHING"
                    
                        self.requestStatusStarted = (requestDetail.request?.status)!
                        self.completion?(detail)
                    
                    }else if requestDetail.request?.status == requestType.arrived.rawValue && self.requestArrived != requestType.arrived.rawValue {
                    
                        self.requestArrived = (requestDetail.request?.status)!
                        self.completion?(detail)
                    
                    }else if requestDetail.request?.status == requestType.pickedUp.rawValue && self.requestPickedUp != requestType.pickedUp.rawValue  {
                    
                        self.requestPickedUp = (requestDetail.request?.status)!
                        self.completion?(detail)
                    
                    }else if requestDetail.request?.status == requestType.dropped.rawValue && self.requestDropped != requestType.dropped.rawValue {
                    
                        self.requestDropped = (requestDetail.request?.status)!
                        self.completion?(detail)
                    
                    }else if requestDetail.request?.status == requestType.completed.rawValue && self.requestCompleted != requestType.completed.rawValue {
                        self.requestCompleted = (requestDetail.request?.status)!
                        self.completion?(detail)
                }else {
                    
                }
                
            }else if detail.requests?.count == 0 && self.requesrArray != 0  {
                    
                self.requestStatus = ""
                self.requestStatusStarted = ""
                self.requestArrived = ""
                self.requestPickedUp = ""
                self.requestDropped = ""
                    self.requestCompleted = ""
                self.completion?(detail)
                print("request Array in empty")
                }else {
                   
                    self.requestStatus = ""
                    self.requestStatusStarted = ""
                    self.requestArrived = ""
                    self.requestPickedUp = ""
                    self.requestDropped = ""
                    self.requestCompleted = ""
                    
                }
                
             self.requesrArray = detail.requests?.count ?? 0
         
        }
            
        }
    }
    
    func callBackGroundAPI(){
        queue = OperationQueue()
        queue.qualityOfService = .background
        
        let operation = BlockOperation  {
            self.getRequestAPI()
            OperationQueue.main.addOperation {
                
            }
        }
        queue.addOperation(operation)
        
    }
    
    
    func stopBackGroundTimer(){
        DispatchQueue.main.async {
            self.backGroundTimer.invalidate()
        }
    }
}


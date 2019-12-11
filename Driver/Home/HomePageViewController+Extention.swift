//
//  HomePageViewController+Extention.swift
//  User
//
//  Created by CSS on 31/05/18.
//  Copyright © 2018 Appoets. All rights reserved.
//

import Foundation
import UIKit

//MARk:- All External XIB file are loaded here

extension HomepageViewController {

    //MARK:- load Offline View
     func loadOfflineNib(){
        
        if self.userOfflineView == nil,let userofflineView = Bundle.main.loadNibNamed(XIB.Names.offlineView, owner: self, options: nil)?.first as? offlineView{
            self.userOfflineView = userofflineView
        self.userOfflineView?.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height)
        //self.userOfflineView?.showAnimateView(self.userOfflineView!, isShow: true, direction: .Top)
         self.userOfflineView?.viewAutoScrollNotVerified.isHidden = true
            self.animateIn()
        self.view.addSubview(userOfflineView!)
        self.view.addSubview(backSimmerBtnView)
        self.view.addSubview(Simmer)
        self.view.addSubview(menuBackView)
        self.view.addSubview(Menuimage)
        }
        
    }
    
    // MARK:- Remove Offline View
    
    func removeOfflineView() {
        self.userOfflineView?.dismissView(onCompletion: {
            self.userOfflineView = nil
        })
    }
    
    func loadRatingView (){ //Laod Rating View XIB file
        self.loader.isHidden = true
        if self.inVoiceView != nil {
            self.inVoiceView?.showAnimateView(self.inVoiceView!, isShow: false, direction: .Bottom)
            self.inVoiceView?.dismissView(onCompletion: {
                self.inVoiceView = nil
            })
        }
    
        if self.ratingViewNib == nil, let ratingViewBundle =  Bundle.main.loadNibNamed(XIB.Names.ratingView, owner: self, options: nil)?.first as? RatingView {
            self.ratingViewNib = ratingViewBundle
            self.ratingViewNib?.frame = CGRect(x: 0, y: self.view.frame.height - (self.ratingViewNib?.frame.height)!, width: self.view.frame.width, height: 250)
            
            self.ratingViewNib?.onclickRating = { rating, comments in
                NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
                NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
                StoreReview.review()
                var commentStr = ""
                if comments != Constants.string.writeYourComments {
                    commentStr = comments
                }
                self.loadRatingAPI(comment: commentStr, Ratings: rating)
            }
            
            self.view.addSubview(self.ratingViewNib!)
            
            NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShowRateView(info:)), name: UIResponder.keyboardWillShowNotification, object: nil)
            NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHideRateView(info:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        }
        self.setValueForRatingView()
        
     
        
    }
    private func setValueForRatingView(){
        
        self.ratingViewNib?.labelRating.text = "\(Constants.string.rateyourtrip.localize()) \(self.requestDetail?.requests?.first?.request?.user?.first_name ?? "--")"
        
        Cache.image(forUrl: "\(baseUrl)/\(Constants.string.storage)/\(self.userProfile)" , completion: { (image) in
            if image != nil {
                DispatchQueue.main.async {
                    self.ratingViewNib?.imageViewProvider.image = image
                }
            }
        })
    }
    
    
    func loadAcceptNib(){ //Load Accept View XIB file
        
        self.loader.isHidden = true
        self.hideSimmerButton()
    
        //self.userOfflineView?.isHidden = true
        self.Simmer.isHidden = true
        self.backSimmerBtnView.isHidden = true
        
        if self.rideAcceptViewNib == nil, let rideAcceotBundle =  Bundle.main.loadNibNamed(XIB.Names.RideAcceptView, owner: self, options: nil)?.first as? RideAcceptView{
            self.rideAcceptViewNib = rideAcceotBundle
            self.rideAcceptViewNib?.showAnimateView(rideAcceptViewNib!, isShow: true, direction: Direction.Top)
            let yPosition = self.view.frame.height - (self.rideAcceptViewNib?.viewVisualEffect.frame.height)!
            
            self.rideAcceptViewNib?.frame = CGRect(x: 0, y: yPosition , width: self.view.frame.width, height: (self.rideAcceptViewNib?.viewVisualEffect.frame.height)!)
            
            self.view.addSubview(self.rideAcceptViewNib!)
            
            self.rideAcceptViewNib?.AcceptBtn.addTarget(self, action: #selector(acceptBtnTapped(sender:)), for: .touchUpInside)
            self.rideAcceptViewNib?.RejectBtn.addTarget(self, action: #selector(rejectBtnTapped(sendre:)), for: .touchUpInside)
        }
    }
    
   
    
    func loadAndShowArrivedNib(){ //Show arrived view
        
        self.loader.isHidden = true
        self.hideSimmerButton()
        if self.arrviedView == nil, let arrivedBundle = (Bundle.main.loadNibNamed(XIB.Names.rideArrivedView, owner: self, options: nil)?.first as? rideArrivedView) {
            
            self.arrviedView = arrivedBundle
            
            self.arrviedView?.viewMessage.tag = 1
            
            self.arrviedView?.frame = CGRect(x: 0, y:self.view.frame.height - arrivedBundle.viewVisualEffect.frame.height, width: self.view.frame.width, height: arrivedBundle.viewVisualEffect.frame.height)
            let messageGesture = UITapGestureRecognizer(target: self, action: #selector(callImageTapped(sender:)))
            self.arrviedView?.viewMessage.addGestureRecognizer(messageGesture)
           
            
            self.arrviedView?.showAnimateView(arrviedView!, isShow: true, direction: Direction.Top)
            self.view.addSubview(self.arrviedView!)
            timer = Timer.scheduledTimer(timeInterval: 0.005, target: self, selector: #selector(HomepageViewController.startprogressbar), userInfo: nil, repeats: true)
            self.arrviedView?.cancelBtn.addTarget(self, action: #selector(cancelBtnTapped(sender:)), for: .touchUpInside)
            self.arrviedView?.arrivedBtn.addTarget(self, action: #selector(arrivedButtontapped(sender:)), for: .touchUpInside)
            
        }
        
        setValueForArrivedView()
        
    }
    
    
    
    func loadAndInvoiceNib(){ //Show arrived view
        
        self.hideSimmerButton()
        self.arrviedView?.removeFromSuperview()
        self.loader.isHidden = true
        if self.inVoiceView == nil, let invoicebundle = (Bundle.main.loadNibNamed(XIB.Names.invoiceView, owner: self, options: nil)?.first as? invoiceView){
            self.inVoiceView = invoicebundle
            self.inVoiceView?.frame = CGRect(x: 0, y:self.view.frame.height - self.inVoiceView!.viewVisualEffect.frame.height, width: self.view.frame.width, height: self.inVoiceView!.viewVisualEffect.frame.height)
            self.arrviedView?.viewVisualEffectMain.showAnimateView((self.arrviedView?.viewVisualEffectMain)!, isShow: false, direction: .Bottom)
            self.inVoiceView?.viewVisualEffect.showAnimateView((self.inVoiceView?.viewVisualEffect)!, isShow: true, direction: .Top)
            self.inVoiceView?.buttonConfirm.addTarget(self, action: #selector(invoiceConfirmButtontapped(sender:)), for: .touchUpInside)
            self.view.addSubview(self.inVoiceView!)
        }
    }
    
    func hideSimmerButton(){
        self.Simmer.isHidden = true
        self.backSimmerBtnView.isHidden = true
    }
    
    func showSimmerButton(){
        if Simmer.isHidden == true{
            self.Simmer.showAnimateView(self.Simmer, isShow: true, direction: .Top)
            self.backSimmerBtnView.showAnimateView(self.backSimmerBtnView, isShow: true, direction: .Top)
        }

    }
    //MARK:- Keyboard will show
    
    @IBAction func keyboardWillShowRateView(info : NSNotification){
        
        guard let keyboard = (info.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else{
            return
        }
        self.ratingViewNib?.frame.origin.y =  keyboard.origin.y-(self.ratingViewNib?.frame.height ?? 0 )
    }
    
    
    //MARK:- Keyboard will hide
    
    @IBAction func keyboardWillHideRateView(info : NSNotification){
        
        guard let keyboard = (info.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else{
            return
        }
        self.ratingViewNib?.frame.origin.y += keyboard.size.height
        
    }

    
    @IBAction func callImageTapped(sender: UITapGestureRecognizer){
        if sender.view?.tag == 1 {
            if let vc = self.storyboard?.instantiateViewController(withIdentifier: Storyboard.Ids.SingleChatController) as? SingleChatController {
                vc.set(user: self.requestDetail!, requestId: self.requestID)
                let navigation = UINavigationController(rootViewController: vc)
                self.present(navigation, animated: true, completion: nil)
            }
        }else{
             makeCall(phoneNumber: String(userPhoneNumber))
        }
       
    }
    
    
    // MARK:- Share Items
    
    func share(items : [Any]) {
        
        let activityController = UIActivityViewController(activityItems: items, applicationActivities: nil)
        self.present(activityController, animated: true, completion: nil)
        
    }
    
    func setValueForGoogleRetractionView(address: String, tripState: requestType){
        self.labelPickupValue.text = address
        if tripState.rawValue == requestType.started.rawValue {
            self.labelPickUp.text = Constants.string.pickUpLocation.localize()
        }else {
            self.labelPickUp.text = Constants.string.dropLocation.localize()
            
        }
    }
}

////
//  HomepageViewController.swift
//  User
//
//  Created by CSS on 03/05/18.
//  Copyright © 2018 Appoets. All rights reserved.
//

import UIKit
import GoogleMaps
import KWDrawerController

class HomepageViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet var backSimmerBtnView: UIView!
    @IBOutlet var AcceptView: UIVisualEffectView!
    @IBOutlet var gMSmapView: GMSMapView!
    
    @IBOutlet var offlineView: UIView!
    @IBOutlet var viewCurrentLocation: UIView!
    @IBOutlet var viewGoogleRetraction: UIView!
    
    //MARK:- image outlets
    @IBOutlet var Menuimage: UIImageView!
    @IBOutlet var offlineImage: UIImageView!
    
    //MARK:- View outlets:
    @IBOutlet var menuBackView: UIView!
    
    
    //MARK:- button outlets:
    @IBOutlet var Simmer: ShimmerButton!
    
    @IBOutlet var viewGoogleNav: UIView!
    @IBOutlet var buttonGoogleMapRetraction: UIButton!
    //MARK:- lable outlets:
    @IBOutlet var labelPickupValue: UILabel!
    @IBOutlet var labelPickUp: UILabel!
    
    private var interactor: DriverHomeInteractor?
    
     var rideAcceptViewNib : RideAcceptView?
     var arrviedView : rideArrivedView?
     var userOfflineView : offlineView?
     var inVoiceView : invoiceView?
     var OTPScreen : OTPScreenView?
     var ratingViewNib : RatingView?
     var requestDetail: GetRequestModelResponse?
    private var sourceMarker = GMSMarker()
    private var destinationMarker = GMSMarker()
    var moveMarker = GMSMarker()
    private var isScheduled = false // Flag for Scheduled Ride
    var userPhoneNumber = Int()
    var userProfile = String()
    var mapViewHelper : GoogleMapsHelper?
    internal var timer : Timer?
    var locationManager:CLLocationManager!
    private var onlineStatus : ServiceStatus = .NONE {
        didSet {
                self.Simmer.setTitle({
                    if self.requestDetail?.account_status == .approved && (self.view.tag == 1){ // If not initially loaded
                        if onlineStatus == .OFFLINE {
                            self.loadOfflineNib()
                        } else {
                            self.removeOfflineView()
                        }
                        return onlineStatus.stringValue.localize()
                    } else {
                        return Constants.string.logout.localize()
                    }
                }(), for: .normal)
        }
    }
    
    var addCardVC : UINavigationController?
    
    private var accountStatus : AccountStatus = .none {
        didSet {
            DispatchQueue.main.async { // If Showing document page and
                if self.accountStatus == .pendingCard {
                    self.interactor?.showAddPayment()
                }else if self.accountStatus == .pendingDocument {
                    self.interactor?.showAddDocuments()
                } else {
                    self.dismiss(animated: true)
                }
                self.userOfflineView?.viewAutoScrollNotVerified.isHidden = (self.accountStatus == .approved)
            }
        }
    }
    
    
    
    
    private var location : Bind<CLLocationCoordinate2D> = Bind<CLLocationCoordinate2D>(nil)
    var currentBearing : ((CLLocationDirection)->Void)?
    var backGroundInstanse = BackGroundTask.backGroundInstance
    var storeReview = StoreReview()
    var userOtp : String?
    
    var requestID : Int = 0
    
    var timeSecond = 60
    var yourLocation : CLLocation? = nil
    var latestLocation : CLLocation? = nil
    var pickupLocation : String?
    var dropLocation : String?
    var slat : Double?
    var sLong : Double?
    var dLat : Double?
    var dLong: Double?
    
    var yourLocationBearing : CGFloat {
        guard self.yourLocation != nil, self.latestLocation != nil else {
            return .leastNonzeroMagnitude
        }
        return latestLocation!.bearingToLocationRadian(self.yourLocation!)
        
    }
    
    
    lazy var loader : UIView = {
        return createActivityIndicator(UIApplication.shared.keyWindow!)
    }()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        interactor = DriverHomeInteractor()
        interactor?.viewController = self
        
        self.loader.isHidden = false
        setGooglemap()
        self.initialLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = true
        userOfflineView?.setAutoScroll()
        self.Simmer.setTitle(onlineStatus.stringValue.localize(), for: .normal)
        self.presenter?.get(api: .getProfile, parameters: nil) // Getting Profile Details 
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setFont(TextField: nil, label: nil, Button: self.Simmer, size: 18, with: true)
        self.viewGoogleNav.makeRoundedCorner()
    }
    
    deinit {
        AVPlayerHelper.player.stop()
        self.timer?.invalidate()
        self.timer = nil
    }
    
    lazy var markerProviderLocation : GMSMarker = {  // Provider Location Marker
        
        let marker = GMSMarker()
        let imageView = UIImageView(frame: CGRect(origin: .zero, size: CGSize(width: 30, height: 30)))
        imageView.contentMode =  .scaleAspectFit
        imageView.image = #imageLiteral(resourceName: "mapvehicle")
        marker.iconView = imageView
        marker.map = self.gMSmapView
        return marker
        
    }()
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.navigationController?.isNavigationBarHidden = true
        print("Called ",#function)
        
    }
    
}


extension HomepageViewController {
    
    private func initialLoad(){
        self.navigationController?.isNavigationBarHidden = true
        setCommonFont()
        self.viewGoogleRetraction.isHidden = true
        self.getRequestValue()
        self.setSubView()
        self.addTapGusture()
        self.addBlurView()
        self.simmerBtnAction()
       // self.GetOnlineStatus(status: Constants.string.active)
        self.mapViewHelper = GoogleMapsHelper()
        self.getUserCurrentLocation()
        setMapStyle()
        setActionForGoogleMapRetraction()
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
        
    }
    
    func removeCardVC() {
        self.addCardVC?.dismiss(animated: true, completion: {
            self.addCardVC = nil
        })
    }
    
    private func setCommonFont(){
        setFont(TextField: nil, label: labelPickupValue, Button: nil, size: 14)
        setFont(TextField: nil, label: labelPickUp, Button: nil, size: 14)
    }
    
    func setActionForGoogleMapRetraction(){
        self.buttonGoogleMapRetraction.addTarget(self, action: #selector(setGoogleMapAction(button:)), for: .touchUpInside)
    }
    
    @IBAction func setGoogleMapAction(button: UIButton){
        openGoogleMap()
        
    }
    
    func drawPoly(s_latitude: Double?, s_longtitude : Double?, d_latitude: Double?, d_longtitude: Double?){
        
        let polyLineSource = CLLocationCoordinate2D(latitude: s_latitude! , longitude: s_longtitude!)
        let polyLineDestination = CLLocationCoordinate2D(latitude: d_latitude!, longitude: d_longtitude!)
        self.gMSmapView.drawPolygon(from: polyLineSource , to: polyLineDestination)
    }
    
    @IBAction func getUserCurrentLocation(){
    
        self.mapViewHelper?.getCurrentLocation(onReceivingLocation: { (location) in
            self.location.value = location.coordinate
            print("location Called")
            self.getCurrentLocation()
            if self.markerProviderLocation.map == nil {
                self.markerProviderLocation.map = self.gMSmapView
            }
            UIView.animate(withDuration: 0.5) {
                self.markerProviderLocation.position = location.coordinate
            }
            self.latestLocation = location
        })
        self.mapViewHelper?.currentBearing = { bearing in
            
            func computeNewAngle(with newAngle: CGFloat) -> CGFloat {
                let heading: CGFloat = {
                    let originalHeading = self.yourLocationBearing - newAngle.degreesToRadians
                    switch UIDevice.current.orientation {
                    case .faceDown: return -originalHeading
                    default: return originalHeading
                    }
                }()
                
                return CGFloat(self.orientationAdjustment().degreesToRadians + heading)
            }
            
            UIView.animate(withDuration: 1) {
                self.markerProviderLocation.rotation = bearing//CLLocationDegrees(angle)
            }
        }
    }
    // MARK:- orientationAdjustment
    private func orientationAdjustment() -> CGFloat {
        let isFaceDown: Bool = {
            switch UIDevice.current.orientation {
            case .faceDown: return true
            default: return false
            }
        }()
        
        let adjAngle: CGFloat = {
            switch UIApplication.shared.statusBarOrientation {
            case .landscapeLeft:  return 90
            case .landscapeRight: return -90
            case .portrait, .unknown: return 0
            case .portraitUpsideDown: return isFaceDown ? 180 : -180
            }
        }()
        return adjAngle
    }
    
    private func getRequestValue(){
        
        self.backGroundInstanse.backGround(with: self.location, completion: { (getRequestModel) in
          //  print("BackGround Value: \(getRequestModel.account_status?.rawValue)")
            if self.view.tag == 0 { // 
                self.loader.isHideInMainThread(true)
                self.view.tag = 1
            }
            self.requestDetail = getRequestModel
            self.onlineStatus = self.requestDetail?.service_status ?? .NONE
            self.accountStatus = ((self.requestDetail?.account_status) ?? .none)
            if self.requestDetail?.account_status == AccountStatus.approved {
                self.onlineStatus = self.requestDetail?.service_status ?? .NONE
                if self.view.tag == 0 {
                     self.GetOnlineStatus(status: ServiceStatus.ONLINE.rawValue)
                     self.view.tag = 1
                }
                if (self.requestDetail?.requests?.count)! > 0{
                   // self.checkServiceStatus()
                    let requestModel = self.requestDetail?.requests![0]
                    self.requestID = requestModel?.request?.id ?? 0
                    let requestStatus = requestModel?.request?.status
                    let bookingId = requestModel?.request?.booking_id
                    let totalAmount = requestModel?.request?.payment?.total
                    let payable = requestModel?.request?.payment?.payable
                    let paymentMode = requestModel?.request?.payment_mode?.lowercased().localize().uppercased()
                    let sourceLatitute   =  (requestModel?.request?.s_latitude)!
                    let sourceLongtitude = (requestModel?.request?.s_longitude)!
                    let destinationLatitde = (requestModel?.request?.d_latitude)!
                    let destinationLontitude = (requestModel?.request?.d_longitude)!
                    //user_rated
//                    let userRating : Float = Float((requestModel?.request?.user?.rating ?? "0")) ?? 0
                    //let paidStatus = requestModel?.request?.paid
                    let userRating : Float = Float((requestModel?.request?.user_rated ?? 0.0))
                    self.userProfile = requestModel?.request?.user?.picture ?? ""
                    self.userPhoneNumber = Int((requestModel?.request?.user?.mobile)!)!
                    self.userOtp = requestModel?.request?.otp
                    self.pickupLocation = requestModel?.request?.s_address
                    self.dropLocation = requestModel?.request?.d_address
                    self.slat = requestModel?.request?.s_latitude
                    self.sLong = requestModel?.request?.s_longitude
                    self.dLat = requestModel?.request?.d_latitude
                    self.dLong = requestModel?.request?.d_longitude
                    self.isScheduled = requestModel?.request?.is_scheduled == "YES"
                    

                    switch requestStatus {
                        
                    case requestType.searching.rawValue:
                        self.setSubView()
                        self.setMarker(sourceLat: sourceLatitute, sourceLong: sourceLongtitude, destinationLat: destinationLatitde, destinationLong: destinationLontitude)
                        self.drawPoly(s_latitude: sourceLatitute, s_longtitude: sourceLongtitude, d_latitude: destinationLatitde, d_longtitude: destinationLontitude)
                        self.loadAcceptNib()
                        if self.isScheduled, let dateObject = Formatter.shared.getDate(from: requestModel?.request?.schedule_at, format: DateFormat.list.yyyy_mm_dd_HH_MM_ss) {  // Set Date For  Scheduled Request
                            self.rideAcceptViewNib?.setSchedule(date: dateObject)
                        }
                        self.startTimer()
                        break
                    case requestType.started.rawValue:
                        AVPlayerHelper.player.stop()
                        //MARK:- set Marker for dource and destination
                        self.setMarker(sourceLat: sourceLatitute, sourceLong: sourceLongtitude, destinationLat: destinationLatitde, destinationLong: destinationLontitude)
                        
                        //self.setValueForGoogleRetractionView(address: requestModel?.request?.s_address ?? "", tripState: .started)
                        self.viewGoogleRetraction.showAnimateView(self.viewGoogleRetraction, isShow: true, direction: .Top)
                        self.pickupLocation = requestModel?.request?.s_address
                        self.dropLocation = requestModel?.request?.d_address
                        
                        self.userOtp = requestModel?.request?.otp
                        
                        //MARK:- draw ploy line
                        self.drawPoly(s_latitude: sourceLatitute, s_longtitude: sourceLongtitude, d_latitude: destinationLatitde, d_longtitude: destinationLontitude)
                        
                        self.getUserCurrentLocation()//MARK:- Here Update the current location and set "markerProviderLocation" marker.Once it will set it will update the current location.
                        
                        self.loadAndShowArrivedNib() //MARK:- here Arrived view XIB file loaded
                        
                
                        
                        
                          self.setValueForGoogleRetractionView(status: requestType.started.rawValue)
                        
                    case requestType.arrived.rawValue:
                        
                       // self.setValueForGoogleRetractionView(address: requestModel?.request?.d_address ?? "", tripState: .arrived)
                        
                        
                        self.viewGoogleRetraction.showAnimateView(self.viewGoogleRetraction, isShow: true, direction: .Top)
                        self.loader.isHidden = true
                        self.gMSmapView.clear()
                        print("map Clear")
                        self.drawPoly(s_latitude: sourceLatitute, s_longtitude: sourceLongtitude, d_latitude: destinationLatitde, d_longtitude: destinationLontitude)
                        
                        if self.location.value?.latitude != nil {
                            //let driverLocation = CLLocationCoordinate2D(latitude: (self.location.value?.latitude)!, longitude: (self.location.value?.longitude)!)
                            
                            
                        }
                        //MARK:- set Marker for dource and destination
                        self.setMarker(sourceLat: sourceLatitute, sourceLong: sourceLongtitude, destinationLat: destinationLatitde, destinationLong: destinationLontitude)
                        
                        self.loadAndShowArrivedNib() //MARK:- here Arrived view XIB file loaded
                        self.setTitleForButton(status: requestType.arrived.rawValue) //MARK:- here update the status
                        
                        self.getUserCurrentLocation()//MARK:- Here Update the current location and set "markerProviderLocation" marker.Once it will set it will update the current location.
                        
                        self.setValueForGoogleRetractionView(status: requestType.arrived.rawValue)
                        
                    case requestType.pickedUp.rawValue:
                       
                        
                        self.viewGoogleRetraction.showAnimateView(self.viewGoogleRetraction, isShow: true, direction: .Top)
                        self.loader.isHidden = true
                        self.gMSmapView.clear()
                        
                        //MARK:- set Marker for dource and destination
                        self.setMarker(sourceLat: sourceLatitute, sourceLong: sourceLongtitude, destinationLat: destinationLatitde, destinationLong: destinationLontitude)
                        
                        self.drawPoly(s_latitude: sourceLatitute, s_longtitude: sourceLongtitude, d_latitude: destinationLatitde, d_longtitude: destinationLontitude)
                        self.loadAndShowArrivedNib()
                        self.timer = Timer.scheduledTimer(timeInterval: 0.2, target: self, selector: #selector(HomepageViewController.startPickupToDropProgess), userInfo: nil, repeats: true)
                        self.setTitleForButton(status: requestType.pickedUp.rawValue)
                        self.getUserCurrentLocation()//MARK:- Here Update the current location and set "markerProviderLocation" marker.Once it will set it will update the current location.
                        
                        
                         self.arrviedView?.imagePickup.image = UIImage(named: "pickup-select")
                        
                           self.setValueForGoogleRetractionView(status: requestType.arrived.rawValue)
                    case requestType.dropped.rawValue:
                        
                        self.viewGoogleRetraction.isHidden = true
                        
                        self.loader.isHidden = true
                        //self.loadAndShowArrivedNib()
                        self.gMSmapView.clear()
                        //MARK:- set Marker for dource and destination
                        self.setMarker(sourceLat: sourceLatitute, sourceLong: sourceLongtitude, destinationLat: destinationLatitde, destinationLong: destinationLontitude)

                        self.drawPoly(s_latitude: sourceLatitute, s_longtitude: sourceLongtitude, d_latitude: destinationLatitde, d_longtitude: destinationLontitude)
                        self.getUserCurrentLocation()
                        self.loadAndInvoiceNib()
                        self.setValueForInvoiceView(bookingId: bookingId, total: totalAmount ?? 0.0, paymentMode: paymentMode, payable: payable)
                        
                    case requestType.completed.rawValue:
                        self.loader.isHidden = true
                        if self.requestDetail?.requests?[0].request?.paid == 0 && self.requestDetail?.requests?[0].request?.payment?.payment_mode == PaymentType.CASH.rawValue  {
                            self.loadAndInvoiceNib()
                            self.setValueForInvoiceView(bookingId: bookingId, total: totalAmount ?? 0.0, paymentMode: paymentMode, payable: payable)
                        }else{
                            self.inVoiceView?.dismissView(onCompletion: {
                                self.inVoiceView = nil
                            })
                            self.loadRatingView()
                        }
                        
                      
                    default:
                        self.gMSmapView.clear()
                        self.getUserCurrentLocation()
                        self.showSimmerButton()
                        self.inVoiceView?.dismissView(onCompletion: {
                            self.inVoiceView = nil
                        })
                        self.rideAcceptViewNib?.dismissView(onCompletion: {
                            self.rideAcceptViewNib = nil
                        })
                        self.arrviedView?.dismissView(onCompletion: {
                            self.arrviedView = nil
                        })
                        self.OTPScreen?.dismissView(onCompletion: {
                            self.OTPScreen = nil
                        })
                        self.ratingViewNib?.dismissView(onCompletion: {
                            self.ratingViewNib = nil
                        })
                        break
                        
                    }
                    
                    
                    //MARK:- Here Values are updated for Accept View
                    self.rideAcceptViewNib?.labelDropLocationValue.text = requestModel?.request?.d_address
                    self.rideAcceptViewNib?.pickUpLocation.text = requestModel?.request?.s_address
                    self.rideAcceptViewNib?.userName.text = requestModel?.request?.user?.first_name
                    self.rideAcceptViewNib?.viewRatings.value = CGFloat(userRating)
                }else {
                    AVPlayerHelper.player.stop()
                    self.view.removeBlurView()
                    self.viewGoogleRetraction.isHidden = true
                    self.loader.isHidden = true
                    print("Request Array is Empty")
                    
                    //self.removeOfflineView()
                    //self.Simmer.setTitle(Constants.string.goOffline, for: .normal)
                    self.gMSmapView.clear()
                    
                    self.showSimmerButton()
                    self.inVoiceView?.dismissView(onCompletion: {
                        self.inVoiceView = nil
                    })
                    self.rideAcceptViewNib?.dismissView(onCompletion: {
                        self.rideAcceptViewNib = nil
                    })
                    self.arrviedView?.dismissView(onCompletion: {
                        self.arrviedView = nil
                    })
                    self.OTPScreen?.dismissView(onCompletion: {
                        self.OTPScreen = nil
                    })
                    self.ratingViewNib?.dismissView(onCompletion: {
                        self.ratingViewNib = nil
                    })
                    self.viewGoogleRetraction.isHidden = true
                }
            }else if self.requestDetail?.account_status == AccountStatus.onboarding {
                self.backGroundInstanse.accountStatus = AccountStatus.onboarding
                self.Simmer.setTitle(Constants.string.logout.localize(), for: .normal)
                self.loadOfflineNib()
                 self.userOfflineView?.viewAutoScrollNotVerified.isHidden = false
                self.view.bringSubviewToFront(self.offlineView)
            }else {
                self.backGroundInstanse.accountStatus = AccountStatus.banned
                self.Simmer.setTitle(Constants.string.logout.localize(), for: .normal)
                self.loadOfflineNib()
                self.userOfflineView?.viewAutoScrollNotVerified.isHidden = false
                self.view.bringSubviewToFront(self.offlineView)
            }
            
        })
        
        
        
    }
    
    func checkServiceStatus(){
       // Simmer.setTitle(Constants.string.goOffline, for: .normal)
        self.userOfflineView?.isHidden = true
        self.removeOfflineView()
        
//        if [serviceStatus.active.rawValue, serviceStatus.riding.rawValue].contains(self.requestDetail?.service_status) {
//            self.onlineStatus = serviceStatus.active.rawValue
//        }else {
//            self.onlineStatus = serviceStatus.offline.rawValue
//        }
    }
    
    func setMarker(sourceLat: Double,sourceLong: Double,destinationLat: Double, destinationLong: Double){
    
        let source_CoOrdinate = CLLocationCoordinate2D(latitude: sourceLat, longitude: sourceLong)
        let destination_CoOrdinate = CLLocationCoordinate2D(latitude: destinationLat, longitude: destinationLong)
        self.plotMarker(marker: self.sourceMarker, with: source_CoOrdinate)
        self.plotMarker(marker: self.destinationMarker, with: destination_CoOrdinate)
    }
    
    func LoadUpdateStatusAPI(status: String){
        //self.loader.isHidden = false
        self.presenter?.post(api: .updateStatus, url: "\(Base.updateStatus.rawValue)/\(requestID)", data: MakeJson.UpdateTripStatus(tripStatus: status))
    }
    
    func setValueForInvoiceView(bookingId : String?, total : Float?,paymentMode : String?, payable : Float?){
        let currency = UserDefaults.standard.value(forKey: Keys.list.currency)
        self.inVoiceView?.labeltotalValue.text = "\(currency ?? "$") \(total ?? 0)"
        self.inVoiceView?.labelBookingIDValue.text = bookingId
        self.inVoiceView?.labelCash.text = paymentMode
        self.inVoiceView?.labelAmountTobePaid.text = "\(currency ?? "$") \((payable ?? 0))"
        self.inVoiceView?.buttonConfirm.setTitle(Constants.string.confirmPayment.localize(), for: .normal)
        
    }
    private func plotMarker(marker : GMSMarker, with coordinate : CLLocationCoordinate2D){
        
        marker.position = coordinate
        marker.appearAnimation = .pop
        marker.icon = marker == self.sourceMarker ? #imageLiteral(resourceName: "Source").resizeImage(newWidth: 30) : #imageLiteral(resourceName: "destination").resizeImage(newWidth: 30)
        marker.map = self.gMSmapView//self.mapViewHelper?.mapView
        marker.map?.center = gMSmapView.center
        self.mapViewHelper?.mapView?.animate(toLocation: coordinate)
    }
    
    func plotMoveMarker(marker: GMSMarker, with coordinate: CLLocationCoordinate2D, degree: CLLocationDegrees){
        marker.position = coordinate
        marker.appearAnimation = .pop
        marker.icon = #imageLiteral(resourceName: "pickup-select").resizeImage(newWidth: 30) // #imageLiteral(resourceName: "mapvehicle").resizeImage(newWidth: 30)
        marker.map = self.gMSmapView
        marker.rotation = degree
        marker.map?.center = self.gMSmapView.center
        self.mapViewHelper?.mapView?.animate(toLocation: coordinate)
        
    }
    private func loadAcceptAPI(){
        self.loader.isHidden = false
        presenter?.post(api: .acceptRequest, url: "\(Base.acceptRequest.rawValue)\(requestID)", data: nil)
        
    }
    
    func setValueForArrivedView(){
        self.arrviedView?.userName.text = self.requestDetail?.requests?.first?.request?.user?.first_name
        rideAcceptViewNib?.showAnimateView(rideAcceptViewNib!, isShow: false, direction: Direction.Bottom)
        self.arrviedView?.labelAddress.text = self.requestDetail?.requests?.first?.request?.s_address
       // setValueForGoogleRetractionView(address: self.requestDetail?.requests?.first?.request?.d_address ?? "", tripState: .arrived)
       
        self.arrviedView?.lablelPickup.text = Constants.string.pickUp.localize()
        Cache.image(forUrl: "\(baseUrl)/\(Constants.string.storage)/\(self.userProfile)" , completion: { (image) in
            if image != nil {
                DispatchQueue.main.async {
                    self.arrviedView?.userProfile.image = image
                }
            }
        })
        
        self.arrviedView?.labelDrop.text = Constants.string.dropLocation.localize()
        self.arrviedView?.labelDropValue.text = self.requestDetail?.requests?.first?.request?.d_address
        
        let rating = self.requestDetail?.requests?.first?.request?.user_rated
        let ratingInt = Double(rating ?? 0)
       // let swe = Double(rating!)
       // print("UserRaying: .\(ratingInt)")
        self.arrviedView?.ratingView.value = CGFloat(ratingInt)
        self.arrviedView?.ratingView.maximumValue = 5
    }
    
    private func  setValueForGoogleRetractionView(status: String?){
        if status == requestType.started.rawValue {
            self.labelPickUp.text = Constants.string.pickUpLocation.localize()
            self.labelPickupValue.text = self.requestDetail?.requests?.first?.request?.s_address
        }else if  status == requestType.arrived.rawValue{
            self.labelPickUp.text = Constants.string.dropLocation.localize()
            self.labelPickupValue.text = self.requestDetail?.requests?.first?.request?.d_address
        }else{
            
        }
        
    }
    
    private func loadLocationAPI(){
        
        let user = User()
        
        self.presenter?.post(api: .updateLocation, data: MakeJson.updateLoaction(latitute: user.latitude , lontitute: user.lontitude))
        
    }
    
    private func GetOnlineStatus(status: String){
        
        self.presenter?.post(api: .onlineStatus, data: MakeJson.OnlineStatus(status: status))
    }
    
    
    
    private func setGooglemap(){
        
        self.viewCurrentLocation.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.getCurrentLocation)))
        print(BackGroundTask.backGroundInstance.userStoredDetail.lontitude ?? 91.00)
        let coOrdinates = CLLocationCoordinate2D(latitude: BackGroundTask.backGroundInstance.userStoredDetail.latitude ?? 13.0827, longitude: BackGroundTask.backGroundInstance.userStoredDetail.lontitude ?? 80.2707)
        gMSmapView.camera = GMSCameraPosition(target: coOrdinates, zoom: 15, bearing: 10.00, viewingAngle: 10.00)
        
        gMSmapView.delegate = self
        Simmer.tintColor = UIColor.white
        Simmer.backgroundColor = UIColor.black
    }
    
    @IBAction private func getCurrentLocation(){
        if BackGroundTask.backGroundInstance.userStoredDetail.latitude != nil {
            
            UIView.animate(withDuration: 1) {
                let coOrdinates = CLLocationCoordinate2D(latitude: BackGroundTask.backGroundInstance.userStoredDetail.latitude!, longitude: BackGroundTask.backGroundInstance.userStoredDetail.lontitude!)
                self.gMSmapView.isMyLocationEnabled = true
               // self.gMSmapView.camera = GMSCameraPosition(target: coOrdinates, zoom: 15, bearing: 10.00, viewingAngle: 10.00)
                self.gMSmapView.animate(to: GMSCameraPosition(target: coOrdinates, zoom: 15, bearing: 10.00, viewingAngle: 10.00))
                
//                let camera = GMSCameraPosition(target: coOrdinates, zoom: 15, bearing: 10.00, viewingAngle: 10.00)
//                self.gMSmapView.animate(to: camera)
            }
        }
        
    }
    
    private func simmerBtnAction(){ //MARK:- set Action for Go Online and offline view
        self.Simmer.addTarget(self, action: #selector(simmerBtnTapped(sender:)), for: .touchUpInside)
    }
    
    @objc func simmerBtnTapped(sender: UIButton){
        
        
        if requestDetail?.account_status == AccountStatus.approved {
             self.initimateServiceStatusBackend()
        }else {
            self.logout()
        }
      
        
//        if self.Simmer.currentTitle == Constants.string.goOffline{
//            self.Simmer.setTitle(Constants.string.goOnline, for: .normal)
//            self.loader.isHidden = false
//            self.GetOnlineStatus(status: Constants.string.offline) //MARK:- Here update the offline status to server
//        }else {
//           // avPlayerHelper.play(file: "Driveronline.mav")
//            self.mapViewHelper?.getTavelDuration(from: "sd", on: { (locationDurationValue) in
//                print("location>>>>: \(locationDurationValue)")
//            })
//            self.loader.isHidden = false
//            self.GetOnlineStatus(status: Constants.string.active) //MARK:- Here update the online  status to server
//            self.Simmer.setTitle(Constants.string.goOffline, for: .normal)
//        }
    }
    
    // Intitmating Backend on service status
    
    private func initimateServiceStatusBackend() {
    
    self.loader.isHidden = false
    let status : ServiceStatus = self.onlineStatus == .ONLINE ? .OFFLINE : .ONLINE
    self.GetOnlineStatus(status: status.rawValue)
    self.onlineStatus = status
//
//    if self.onlineStatus == serviceStatus.offline.rawValue {
//       // self.Simmer.setTitle(Constants.string.goOnline, for: .normal)
//
//        self.GetOnlineStatus(status: ServiceStatus.ONLINE.rawValue) //MARK:- Here update the offline
//    }else{
//
//        self.GetOnlineStatus(status: ServiceStatus.OFFLINE.rawValue) //MARK:- Here update the online  status to server
//        self.Simmer.setTitle(Constants.string.goOffline, for: .normal)
//        }
    }
    
    func logout() {
        
        let alert = UIAlertController(title: nil, message: Constants.string.logoutMessage.localize(), preferredStyle: .actionSheet)
        let logoutAction = UIAlertAction(title: Constants.string.logout.localize(), style: .destructive) { (_) in
            //self.loader.isHidden = false
            self.presenter?.post(api: .logout, data: nil)
            BackGroundTask.backGroundInstance.stopBackGroundTimer()
            BackGroundTask.backGroundInstance.backGroundTimer.invalidate()
            
            BackGroundTask.backGroundInstance.onbordingStatus = ""
            BackGroundTask.backGroundInstance.approvedStatus = ""
            BackGroundTask.backGroundInstance.bannedStatus = ""
            
        }
        let cancelAction = UIAlertAction(title: Constants.string.Cancel.localize(), style: .cancel, handler: nil)
        alert.addAction(logoutAction)
        alert.view.tintColor = .primary
        
        alert.addAction(cancelAction)
        self.present(alert, animated: true, completion: nil)
    }
    
    
    private func addBlurView(){
        let blurView  = UIBlurEffect(style: UIBlurEffect.Style.extraLight)
        let blurEffedView = UIVisualEffectView(effect: blurView)
        blurEffedView.frame = view.bounds
        self.offlineView.backgroundColor = UIColor.clear
        self.offlineView.addSubview(blurEffedView)
        self.offlineView.addSubview(offlineImage)
        
    }
    
    func animateIn() {
        
 
        
        rideAcceptViewNib?.transform = CGAffineTransform.init(scaleX: 1.3, y: 1.3)
        rideAcceptViewNib?.alpha = 0
        
        UIView.animate(withDuration: 2) {
            
            self.rideAcceptViewNib?.alpha = 1
            
            self.rideAcceptViewNib?.transform = CGAffineTransform.identity
            self.rideAcceptViewNib?.isHidden = false
        }
        
        
    }
    
    func animateOut () {
        UIView.animate(withDuration: 0.3, animations: {
            self.offlineView.transform = CGAffineTransform.init(scaleX: 1.3, y: 1.3)
            self.offlineView.alpha = 0
            
        }) { (success:Bool) in
            self.offlineView.isHidden = true
            
        }
    }
    
    private func addTapGusture(){ //MARK:- tapGusture added for left Menu
        let menuTapGusture = UITapGestureRecognizer(target: self, action: #selector(menuTapped(sender:)))
        self.menuBackView.addGestureRecognizer(menuTapGusture)
    }
    
    @objc private func menuTapped(sender: UITapGestureRecognizer){
        //sender.view?.addPressAnimation()
        vibrate(sound: .pop)
        self.drawerController?.openSide(selectedLanguage == .arabic ? .right : .left)

    }
    
    
    func startTimer(){ //MARK:- Here set the timer value for accept request counter
        
        AVPlayerHelper.player.play()
        
        print("Called",#function)
        self.timer?.invalidate()
        self.timer = nil
        self.timeSecond = 60
        self.timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { ( timer ) in
            
            self.timeSecond -= 1
            print("Timer Value ",self.timeSecond)
            if self.timeSecond == 0 {
                DispatchQueue.main.async {
                    self.timer?.invalidate()
                    AVPlayerHelper.player.stop()
                    self.rideAcceptViewNib?.dismissView(onCompletion: {
                        self.rideAcceptViewNib = nil
                        self.Simmer.showAnimateView(self.Simmer, isShow: true, direction: .Top)
                        self.backSimmerBtnView.showAnimateView(self.backSimmerBtnView, isShow: true, direction: .Top)
                    })
                    
                }
                print("Invalidated")
                
            }
            self.rideAcceptViewNib?.labelTime.text = "\(self.timeSecond)"
        })
        
        
        
    }
    
    @objc func acceptBtnTapped(sender: UIButton){
        AVPlayerHelper.player.stop()
        self.viewGoogleRetraction.showAnimateView(self.viewGoogleRetraction, isShow: true, direction: .Top)
       // self.rideAcceptViewNib?.viewRequest.isHidden = true
        self.timer?.invalidate()
        self.timer = nil
        self.loadAcceptAPI()//MARK:- here load the accept API
        if self.isScheduled {
            if let yourTripsVC = Router.user.instantiateViewController(withIdentifier: Storyboard.Ids.yourTripsPassbookViewController) as? YourTripsPassbookViewController {
                yourTripsVC.isYourTripsSelected = true
                yourTripsVC.isFirstBlockSelected = false
                self.navigationController?.pushViewController(yourTripsVC, animated: true)
            }
         }
    }
    
    @objc func rejectBtnTapped(sendre: UIButton){
        AVPlayerHelper.player.stop()
        self.loader.isHidden = false
        rejectAPI()
        self.timer?.invalidate()
        self.timer = nil
        self.rideAcceptViewNib?.showAnimateView(self.rideAcceptViewNib!, isShow: false, direction: Direction.Bottom)
    }
    
    private func rejectAPI(){
        //        self.presenter?.post(api: .reject, url: "\(Base.reject.rawValue)\(String(describing: self.requestID!))", data: nil)
        self.presenter?.delete(api: .reject, url: "\(Base.reject.rawValue)\(self.requestID)", data: nil)
    }
    
    @IBAction func invoiceConfirmButtontapped(sender: UIButton){
        if self.requestDetail?.requests?[0].request?.paid == 0 {
            self.LoadUpdateStatusAPI(status: Constants.string.completed)
             self.loadRatingView()
        }else{
            //self.inVoiceView?.removeFromSuperview()
             self.loader.isHidden = false
            self.loadRatingView()
           self.LoadUpdateStatusAPI(status: Constants.string.completed)
        }
       
        
    }
    
    func loadRatingAPI(comment: String?, Ratings: Int){ //MARK:- here set load the rating API
        self.loader.isHidden = false
        self.presenter?.post(api: .invoiceAPI, url: "\(Base.invoiceAPI.rawValue)\(self.requestID)/rate", data: MakeJson.invoiceUpdate(rating: Ratings, comment: comment))
    }
    
    @objc  func startprogressbar(){
        
        self.arrviedView?.progressBarArrivedToPickUp.progress += 0.2
        
    }
    
    @objc func startPickupToDropProgess(){
        //self.arrviedView?.progressBarPickupToFinished.progress = 1
//        if arrviedView?.progressBarPickupToFinished.progress == 1 {
//            self.arrviedView?.progressBarPickupToFinished.progress = 0
//        }else {
//            UIView.animate(withDuration: 0.2) {
//                // self.arrviedView?.progressBarPickupToFinished.alpha = 0
//                self.arrviedView?.progressBarPickupToFinished.progress += 0.2
//            }
        
        //}
        
    }
    
    
    
    @objc  func cancelBtnTapped(sender: UIButton){
        
        var cancelModel = UpcomingCancelModel()
        cancelModel.id = requestID
        self.presenter?.post(api: .UpcommingCancel, data: cancelModel.toData())
    }
    
    @objc  func arrivedButtontapped(sender: UIButton){
        
        let requestModel = self.requestDetail?.requests![0]
        let requestStatus = requestModel?.request?.status
        
        if requestStatus == requestType.arrived.rawValue {
            self.loader.isHidden = true
            self.loadOtpScreen()
        }else if requestStatus == requestType.pickedUp.rawValue {
            self.loader.isHidden = false
            self.statusChanged(status: requestType.dropped.rawValue)
        }else {
            self.loader.isHidden = false
            self.statusChanged(status: requestType.arrived.rawValue)
        }
        
//
//        if self.arrviedView?.arrivedBtn.currentTitle == Constants.string.pickedUp {
//            self.loader.isHidden = false
//            self.loadOtpScreen()
//
//
//            //self.statusChanged(status: requestType.pickedUp.rawValue)
//
//        }else if self.arrviedView?.arrivedBtn.currentTitle == Constants.string.tapWhenDropped{
//            self.loader.isHidden = false
//            self.LoadUpdateStatusAPI(status: Constants.string.dropped)
//
//
//            self.statusChanged(status: requestType.dropped.rawValue)
//
//        }else {
//            self.loader.isHidden = false
//            self.statusChanged(status: requestType.arrived.rawValue)
//
//
//
//        }
        
    }
    
    func statusChanged(status : String){ //MARK:- changing the button name occurding to the request status
        switch status {
        case requestType.arrived.rawValue:
            self.LoadUpdateStatusAPI(status: Constants.string.arrived)
            self.view.removeBlurView()
            //  self.OTPScreen?.removeFromSuperview()
            self.arrviedView?.arrivedBtn.setTitle( Constants.string.pickedUp.localize().uppercased(), for: .normal)
            
        case requestType.pickedUp.rawValue:
            self.OTPScreen?.removeFromSuperview()
            self.view.removeBlurView()
            self.LoadUpdateStatusAPI(status: Constants.string.pickedUp)
            self.arrviedView?.arrivedBtn.setTitle(Constants.string.tapWhenDropped.localize(), for: .normal)
            self.arrviedView?.cancelBtn.alpha = 1.0
            
            UIView.animate(withDuration: 0.5, animations: {
                self.arrviedView?.cancelBtn.alpha = 0.0
                self.arrviedView?.cancelBtn.isHidden = true
            }) { (_) in
            }
        case requestType.dropped.rawValue:
            self.LoadUpdateStatusAPI(status: Constants.string.dropped)
            
        default:
            print("default")
        }
        
    }
    
    private func setTitleForButton(status : String){
        switch status {
        case requestType.arrived.rawValue:
            self.view.removeBlurView()
            self.arrviedView?.arrivedBtn.setTitle( Constants.string.pickedUp.localize().uppercased(), for: .normal)
            
            break
        case requestType.pickedUp.rawValue:
            self.view.removeBlurView()
            self.arrviedView?.arrivedBtn.setTitle(Constants.string.tapWhenDropped.localize(), for: .normal)
            self.arrviedView?.cancelBtn.alpha = 1.0
            
            UIView.animate(withDuration: 0.5, animations: {
                self.arrviedView?.cancelBtn.alpha = 0.0
                self.arrviedView?.cancelBtn.isHidden = true
            }) { (_) in
            }
            break
        case requestType.dropped.rawValue:
            break
            
            
        default:
            print("default")
        }
    }
    
    private func setSubView(){ //MARK:- here set the "viewGoogleRetraction" subView for google Map view
        self.gMSmapView.addSubview(viewGoogleRetraction)
        
    }
}



extension HomepageViewController : PostViewProtocol {
    
    func onError(api: Base, message: String, statusCode code: Int) { //MARK:-error state
        print(message)
        self.loader.isHideInMainThread(true)
    }
    
    func getLoactionUpadate(api: Base, data: updateLocationModelResponse?) { //MARK:-update location of the provider
        print("location update: \(String(describing: data?.message))")
    }
    
    func getOnlineStatus(api: Base, data: OnlinestatusModelResponse?) { //MARK:-Update Online ,Offline Status of provider
        self.loader.isHidden = true
        if data?.error == ErrorMessage.list.yourAccountNotVerified {
            self.onlineStatus = ServiceStatus.OFFLINE
            self.loadOfflineNib()
            self.userOfflineView?.viewAutoScrollNotVerified.isHidden = false
    
        }else if data?.service?.status == .ONLINE {
            //MARK:-self.userOfflineView?.showAnimateView(self.userOfflineView!, isShow: false, direction: .Bottom)
            self.onlineStatus = .ONLINE
            AVPlayerHelper.player.stop()
            self.mapViewHelper?.getCurrentLocation(onReceivingLocation: { (locationCoordinate) in
                self.location.value = locationCoordinate.coordinate
                self.latestLocation = locationCoordinate
            })
           self.removeOfflineView()
        }else {
            self.onlineStatus = .OFFLINE
            self.loadOfflineNib()
        }
        self.getUserCurrentLocation()
    }
    
    func GetAcceptStatus(api: Base, data: [AcceptModelReponse]?) { //MARK:-Ride accept function
        
        // loadAndShowArrivedNib()
        //print("AcceptViewResponse>>  \(data?.last?.id)")
    }
    
    func getUpdateStatus(api: Base, data: UpdateTripStatusModelResponse?) { //MARK:-Ride Upadte function. here getting the response for updateStatus API
        
        print(data as Any)
    }
    
    func getRejectAPI(api: Base, data: [RejectModelResponse]?) { //MARK:-Ride reject Function
        self.loader.isHidden = true
        self.arrviedView?.showAnimateView(self.arrviedView!, isShow: false, direction: Direction.Bottom)
        print(data as Any)
    }
    
    func getInvoiceData(api: Base, data: InvoiceModelResponse?) { //MARK:-Invoice API response function
        self.loader.isHidden = true
        self.ratingViewNib?.showAnimateView(self.ratingViewNib!, isShow: false, direction: .Bottom)
        self.Simmer.showAnimateView(self.Simmer, isShow: true, direction: .Top)
        self.backSimmerBtnView.showAnimateView(self.backSimmerBtnView, isShow: true, direction: .Top)
        print(data?.message as Any)
    }
    
    func getSucessMessage(api: Base, data: String?) {
        if api == .logout {
            forceLogout()
        }
    }
    
    func getProfile(api: Base, data: Profile?) {
        Common.storeUserData(from: data)
        storeInUserDefaults()
    }
}


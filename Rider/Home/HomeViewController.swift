    //
    //  HomeViewController.swift
    //  User
    //
    //  Created by CSS on 02/05/18.
    //  Copyright © 2018 Appoets. All rights reserved.
    //

    import UIKit
    import KWDrawerController
    import GoogleMaps
    import GooglePlaces
    import DateTimePicker
    //import IQKeyboardManagerSwift
    
    var riderStatus : RideStatus = .none // Provider Current Status
    
    class HomeViewController: UIViewController {
        
        @IBOutlet private var viewSideMenu : UIView!
        @IBOutlet private var viewCurrentLocation : UIView!
        @IBOutlet weak var viewMapOuter : UIView!
        @IBOutlet weak private var viewFavouriteSource : UIView!
        @IBOutlet weak private var viewFavouriteDestination : UIView!
        @IBOutlet weak private var imageViewFavouriteSource : ImageView!
        @IBOutlet weak private var imageViewFavouriteDestination : ImageView!
        @IBOutlet weak private var viewSourceLocation : UIView!
        @IBOutlet weak private var viewDestinationLocation : UIView!
        @IBOutlet weak private var viewAddress : UIView!
        @IBOutlet weak var viewAddressOuter : UIView!
        @IBOutlet weak private var textFieldSourceLocation : UITextField!
        @IBOutlet weak private var textFieldDestinationLocation : UITextField!
        @IBOutlet weak private var imageViewMarkerCenter : UIImageView!
        @IBOutlet weak private var imageViewSideBar : UIImageView!
        @IBOutlet weak var buttonSOS : UIButton!
        @IBOutlet weak private var viewHomeLocation : UIView!
        @IBOutlet weak private var viewWorkLocation : UIView!
        @IBOutlet weak var viewLocationButtons : UIStackView!
        
        @IBOutlet var constraint : NSLayoutConstraint!
        
        var providerLastLocation = LocationCoordinate()
        lazy var markerProviderLocation : GMSMarker = {  // Provider Location Marker
            let marker = GMSMarker()
            let imageView = UIImageView(frame: CGRect(origin: .zero, size: CGSize(width: 30, height: 30)))
            imageView.contentMode =  .scaleAspectFit
            imageView.image = #imageLiteral(resourceName: "map-vehicle-icon-black")
            marker.iconView = imageView
            marker.groundAnchor = CGPoint(x: 0.5, y: 0.5)
            marker.map = self.mapViewHelper?.mapView
            return marker
        }()
        
        private var selectedLocationView = UIView() // View to change the location pinpoint
        {
            didSet{
                if !([viewSourceLocation, viewDestinationLocation].contains(selectedLocationView)) {
                    [viewSourceLocation, viewDestinationLocation].forEach({ $0?.transform = .identity })
                }
            }
        }
        
        var isOnBooking = false {  // Boolean to handle back using side menu button
            didSet {
                self.imageViewSideBar.image = isOnBooking ? #imageLiteral(resourceName: "back-icon") : #imageLiteral(resourceName: "menu_icon")
            }
        }
        
        private var isUserInteractingWithMap = false // Boolean to handle Mapview User interaction
        // private let transition = CircularTransition()  // Translation to for location Tap
        var mapViewHelper : GoogleMapsHelper?
//        private var favouriteViewSource : LottieView?
//        private var favouriteViewDestination : LottieView?
        
        private var isSourceFavourited = false {  // Boolean to handle favourite source location
            didSet{
                self.isAddFavouriteLocation(in: self.viewFavouriteSource, isAdd: isSourceFavourited)
            }
        }
        
        private var isDestinationFavourited = false { // Boolean to handle favourite destination location
            didSet{
                self.isAddFavouriteLocation(in: self.viewFavouriteDestination, isAdd: isDestinationFavourited)
            }
        }
        
        
        var sourceLocationDetail : Bind<LocationDetail>? = Bind<LocationDetail>(nil)
        
        var destinationLocationDetail : LocationDetail? {  // Destination Location Detail
            didSet{
                DispatchQueue.main.async {
                    self.isDestinationFavourited = false // reset favourite location on change
                    if self.destinationLocationDetail == nil {
                        self.isDestinationFavourited = false
                    }
                    self.textFieldDestinationLocation.text = (self.destinationLocationDetail?.address.removingWhitespaces().isEmpty ?? true) ? nil : self.destinationLocationDetail?.address
                }
            }
        }
        
        //  private var favouriteLocations : LocationService? //[(type : String,address: [LocationDetail])]() // Favourite Locations of User
        
        var currentLocation = Bind<LocationCoordinate>(defaultMapLocation)
        var isRateViewShowed:Bool = false
        var isInvoiceShowed:Bool = false
        //var serviceSelectionView : ServiceSelectionView?
        var estimationFareView : RequestSelectionView?
        var couponView : CouponView?
        var locationSelectionView : LocationSelectionView?
        var requestLoaderView : LoaderView?
        var rideStatusView : RideStatusView? {
            didSet {
                if self.rideStatusView == nil {
                    self.floatyButton?.removeFromSuperview()
                }
            }
        }
        var invoiceView : InvoiceView?
        var ratingView : RatingView?
        var rideNowView : RideNowView?
        var floatyButton : Floaty?
        var reasonView : ReasonView?
        
        lazy var loader  : UIView = {
            return createActivityIndicator(self.view)
        }()
        
        var currentRequestId = 0
        var timerETA : Timer?
        private var isScheduled = false // Flag For Schedule
        
        //MARKERS
        
        var sourceMarker : GMSMarker = {
            let marker = GMSMarker()
            marker.title = Constants.string.ETA.localize()
            marker.appearAnimation = .pop
            marker.icon =  #imageLiteral(resourceName: "sourcePin").resizeImage(newWidth: 30)
            return marker
        }()
        
        private var destinationMarker : GMSMarker = {
            let marker = GMSMarker()
            marker.appearAnimation = .pop
            marker.icon =  #imageLiteral(resourceName: "destinationPin").resizeImage(newWidth: 30)
            return marker
        }()
        
        var markersProviders = [GMSMarker]()
        
        override func viewDidLoad() {
            super.viewDidLoad()
            self.initialLoads()
            self.localize()
        }
        
        override func viewWillAppear(_ animated: Bool) {
            super.viewWillAppear(animated)
            self.viewWillAppearCustom()
            //IQKeyboardManager.shared.enable = true
        }
        
        override func didReceiveMemoryWarning() {
            super.didReceiveMemoryWarning()
            // Dispose of any resources that can be recreated.
        }
        
        override func viewWillLayoutSubviews() {
            super.viewWillLayoutSubviews()
            self.viewLayouts()
        }
        
        
    }
    
    // MARK:- Methods
    
extension HomeViewController {
   
    private func initialLoads() {
            
            self.addMapView()
            self.getFavouriteLocations()
            self.viewSideMenu.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.sideMenuAction)))
            self.navigationController?.isNavigationBarHidden = true
            self.viewFavouriteDestination.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.favouriteLocationAction(sender:))))
            self.viewFavouriteSource.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.favouriteLocationAction(sender:))))
            [self.viewSourceLocation, self.viewDestinationLocation].forEach({ $0.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.locationTapAction(sender:))))})
            self.currentLocation.bind(listener: { (locationCoordinate) in
                // TODO:- Handle Current Location
                if locationCoordinate != nil {
                    self.mapViewHelper?.moveTo(location: locationCoordinate!, with: self.viewMapOuter.center)
                }
            })
            self.viewCurrentLocation.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.getCurrentLocation)))
            self.sourceLocationDetail?.bind(listener: { (locationDetail) in
//                if locationDetail == nil {
//                    self.isSourceFavourited = false
//                }
                DispatchQueue.main.async {
                    self.isSourceFavourited = false // reset favourite location on change
                    self.textFieldSourceLocation.text = locationDetail?.address
                }
            })
            self.viewDestinationLocation.transform = CGAffineTransform(scaleX: 1.05, y: 1.05)
            self.checkForProviderStatus()
            self.buttonSOS.isHidden = true
            self.buttonSOS.addTarget(self, action: #selector(self.buttonSOSAction), for: .touchUpInside)
            self.setDesign()
            NotificationCenter.default.addObserver(self, selector: #selector(self.observer(notification:)), name: .providers, object: nil)
            NotificationCenter.default.addObserver(self, selector: #selector(self.networkChanged(notification:)), name: NSNotification.Name.reachabilityChanged, object: nil)
        
//            NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShowRateView(info:)), name: .UIKeyboardWillShow, object: nil)
//            NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHideRateView(info:)), name: .UIKeyboardWillHide, object: nil)      }
            self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
            self.presenter?.get(api: .getProfile, parameters: nil)
        }
    
    // MARK:- View Will appear
    
    private func viewWillAppearCustom() {
        isRateViewShowed = false
        isInvoiceShowed = false
        self.navigationController?.isNavigationBarHidden = true
        self.localize()
        self.getFavouriteLocationsFromLocal()
        
    }
        
        // MARK:- View Will Layouts
        
        private func viewLayouts() {
            
            self.viewCurrentLocation.makeRoundedCorner()
            self.mapViewHelper?.mapView?.frame = viewMapOuter.bounds
            self.viewSideMenu.makeRoundedCorner()
            self.navigationController?.isNavigationBarHidden = true            
        }
        
        @IBAction private func getCurrentLocation(){
            
            self.viewCurrentLocation.addPressAnimation()
            if currentLocation.value != nil {
                self.mapViewHelper?.getPlaceAddress(from: currentLocation.value!, on: { (locationDetail) in  // On Tapping current location, set
                    if self.selectedLocationView == self.viewSourceLocation {
                        self.sourceLocationDetail?.value = locationDetail
                    } else if self.selectedLocationView == self.viewDestinationLocation {
                        self.destinationLocationDetail = locationDetail
                    }
                })
                self.mapViewHelper?.moveTo(location: self.currentLocation.value!, with: self.viewMapOuter.center)
            }
        }
    
        // MARK:- Localize
        
        private func localize(){
            
            self.textFieldSourceLocation.placeholder = Constants.string.source.localize()
            self.textFieldDestinationLocation.placeholder = Constants.string.destination.localize()
            
        }
        
        // MARK:- Set Design
        
        private func setDesign() {
            
            Common.setFont(to: textFieldSourceLocation)
            Common.setFont(to: textFieldDestinationLocation)
        }
        
        // MARK:- Add Mapview
        
        private func addMapView(){
           
            self.mapViewHelper = GoogleMapsHelper()
            self.mapViewHelper?.getMapView(withDelegate: self, in: self.viewMapOuter)
            self.getCurrentLocationDetails()
        }
    //Getting current location detail
    private func getCurrentLocationDetails() {
        self.mapViewHelper?.getCurrentLocation(onReceivingLocation: { (location) in
            if self.sourceLocationDetail?.value == nil {
                self.mapViewHelper?.getPlaceAddress(from: location.coordinate, on: { (locationDetail) in
                    self.sourceLocationDetail?.value = locationDetail
                })
            }
            self.currentLocation.value = location.coordinate
        })
    }
        
        // MARK:- Observer
        
       @objc private func observer(notification : Notification) {
            
            if notification.name == .providers, let serviceArray = notification.userInfo?[Notification.Name.providers.rawValue] as? [Service] {
                showProviderInCurrentLocation(with: serviceArray)
            }
            
        }
        
        
        // MARK:- Get Favourite Location From Local
        
        private func getFavouriteLocationsFromLocal() {
            
            let favouriteLocationFromLocal = CoreDataHelper().favouriteLocations()
            [self.viewHomeLocation, self.viewWorkLocation].forEach({
                 $0?.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.viewLocationButtonAction(sender:))))
                 $0?.isHidden = true
            })
            for location in favouriteLocationFromLocal
            {
                switch location.key {
                    case CoreDataEntity.work.rawValue where location.value is Work:
                        if let workObject = location.value as? Work, let address = workObject.address {
                            if let index = favouriteLocations.firstIndex(where: { $0.address == Constants.string.work}) {
                                favouriteLocations[index] = (location.key, (address, LocationCoordinate(latitude: workObject.latitude, longitude: workObject.longitude)))
                            } else {
                                favouriteLocations.append((location.key, (address, LocationCoordinate(latitude: workObject.latitude, longitude: workObject.longitude))))
                            }
                            self.viewWorkLocation.isHidden = false
                        }
                   case CoreDataEntity.home.rawValue where location.value is Home:
                        if let homeObject = location.value as? Home, let address = homeObject.address {
                            if let index = favouriteLocations.firstIndex(where: { $0.address == Constants.string.home}) {
                                favouriteLocations[index] = (location.key, (address, LocationCoordinate(latitude: homeObject.latitude, longitude: homeObject.longitude)))
                            } else {
                                favouriteLocations.append((location.key, (address, LocationCoordinate(latitude: homeObject.latitude, longitude: homeObject.longitude))))
                            }
                            self.viewHomeLocation.isHidden = false
                        }
                default:
                    break
                    
                }
            }
        }
        
        // MARK:- View Location Action
        
        @IBAction private func viewLocationButtonAction(sender : UITapGestureRecognizer) {
            
            guard let senderView = sender.view else { return }
            if senderView == viewHomeLocation, let location = CoreDataHelper().favouriteLocations()[CoreDataEntity.home.rawValue] as? Home, let addressString = location.address {
                self.destinationLocationDetail = (addressString, LocationCoordinate(latitude: location.latitude, longitude: location.longitude))
            } else if senderView == viewWorkLocation, let location = CoreDataHelper().favouriteLocations()[CoreDataEntity.work.rawValue] as? Work, let addressString = location.address {
                self.destinationLocationDetail = (addressString, LocationCoordinate(latitude: location.latitude, longitude: location.longitude))
            }
            
            if destinationLocationDetail == nil { // No Previous Location Avaliable
                self.showLocationView()
            } else {
                self.drawPolyline() // Draw polyline between source and destination
                self.getServicesList() // get Services
            }
            
        }
        
        
        // MARK:- Favourite Location Action
        
        @IBAction private func favouriteLocationAction(sender : UITapGestureRecognizer) {
            
            guard let senderView = sender.view else { return }
            senderView.addPressAnimation()
            if senderView == viewFavouriteSource {
                self.isSourceFavourited = self.sourceLocationDetail?.value != nil ? !self.isSourceFavourited : false
            } else if senderView == viewFavouriteDestination {
                self.isDestinationFavourited = self.destinationLocationDetail != nil ? !self.isDestinationFavourited : false
            }
        }
        
        // MARK:- Favourite Location Action
        
        private func isAddFavouriteLocation(in viewFavourite : UIView, isAdd : Bool) {
            
            if viewFavourite == viewFavouriteSource {
                self.imageViewFavouriteSource.image = (isAdd ? #imageLiteral(resourceName: "like") : #imageLiteral(resourceName: "unlike")).withRenderingMode(.alwaysTemplate)
            } else {
                self.imageViewFavouriteDestination.image = (isAdd ? #imageLiteral(resourceName: "like") : #imageLiteral(resourceName: "unlike")).withRenderingMode(.alwaysTemplate)
            }
            self.favouriteLocationApi(in: viewFavourite, isAdd: isAdd) // Send to Api Call

        }
        
        // MARK:- Favourite Location Action
        
        @IBAction private func locationTapAction(sender : UITapGestureRecognizer) {
            
            guard let senderView = sender.view  else { return }
            if riderStatus != .none, senderView == viewSourceLocation { // Ignore if user is onRide and trying to change source location 
                return
            }
            self.selectedLocationView.transform = CGAffineTransform.identity
            
            if self.selectedLocationView == senderView {
                self.showLocationView()
            } else {
                self.selectedLocationView = senderView
                self.selectionViewAction(in: senderView)
            }
            self.selectedLocationView.transform = CGAffineTransform(scaleX: 1.05, y: 1.05)
            self.viewAddress.bringSubviewToFront(self.selectedLocationView)
            // self.showLocationView()
        }
        
        
        // MARK:- Show Marker on Location
        
        private func selectionViewAction(in currentSelectionView : UIView){
            
            if currentSelectionView == self.viewSourceLocation {
                
                if let coordinate = self.sourceLocationDetail?.value?.coordinate{
                    self.plotMarker(marker: &sourceMarker, with: coordinate)
                    print("Source Marker - ", coordinate.latitude, " ",coordinate.longitude)
                } else {
                    self.showLocationView()
                }
            } else if currentSelectionView == self.viewDestinationLocation {
                
                if let coordinate = self.destinationLocationDetail?.coordinate{
                    self.plotMarker( marker: &destinationMarker, with: coordinate)
                    print("Destination Marker - ", coordinate.latitude, " ",coordinate.longitude)
                } else {
                    self.showLocationView()
                }
            }
            
        }
        
        private func plotMarker(marker : inout GMSMarker, with coordinate : CLLocationCoordinate2D){
           
            marker.position = coordinate
            marker.map = self.mapViewHelper?.mapView
            self.mapViewHelper?.mapView?.animate(toLocation: coordinate)
        }
        
        
        // MARK:- Show Location View
        
        @IBAction private func showLocationView() {
            
            if let locationView = Bundle.main.loadNibNamed(XIB.Names.LocationSelectionView, owner: self, options: [:])?.first as? LocationSelectionView {
                locationView.frame = self.view.bounds
                locationView.setValues(address: (sourceLocationDetail,destinationLocationDetail)) { [weak self] (address) in
                    guard let self = self else {return}
                    self.sourceLocationDetail = address.source
                    self.destinationLocationDetail = address.destination
                   // print("\nselected-->>>>>",self.sourceLocationDetail?.value?.coordinate, self.destinationLocationDetail?.coordinate)
                    self.drawPolyline() // Draw polyline between source and destination
                    if [RideStatus.accepted, .arrived, .pickedup, .started].contains(riderStatus) {
                        if let dAddress = address.destination?.address, let coordinate = address.destination?.coordinate {
                              self.updateLocation(with: (dAddress,coordinate))
                        }
                    } else {
                        self.removeUnnecessaryView(with: .cancelled) // Remove services or ride now if previously open
                        self.getServicesList() // get Services
                    }
                }
                self.view.addSubview(locationView)
                if selectedLocationView == self.viewSourceLocation {
                    locationView.textFieldSource.becomeFirstResponder()
                } else {
                    locationView.textFieldDestination.becomeFirstResponder()
                }
                self.selectedLocationView.transform = .identity
                self.selectedLocationView = UIView()
                self.locationSelectionView = locationView
            }
            
        }
        
        // MARK:- Remove Location VIew
        
        func removeLocationView() {
            
            UIView.animate(withDuration: 0.3, animations: {
                self.locationSelectionView?.tableViewBottom.frame.origin.y = (self.locationSelectionView?.tableViewBottom.frame.height) ?? 0
                self.locationSelectionView?.viewTop.frame.origin.y = -(self.locationSelectionView?.viewTop.frame.height ?? 0)
            }) { (_) in
                self.locationSelectionView?.isHidden = true
                self.locationSelectionView?.removeFromSuperview()
                self.locationSelectionView = nil
            }
            
        }
        
        
        //MARK:- Draw Polyline
        
        func drawPolyline() {
            
            self.imageViewMarkerCenter.isHidden = true
            if let sourceCoordinate = self.sourceLocationDetail?.value?.coordinate,
                let destinationCoordinate = self.destinationLocationDetail?.coordinate {  // Draw polyline from source to destination
                self.mapViewHelper?.mapView?.clear()
                self.sourceMarker.map = self.mapViewHelper?.mapView
                self.destinationMarker.map = self.mapViewHelper?.mapView
                self.sourceMarker.position = sourceCoordinate
                self.destinationMarker.position = destinationCoordinate
                //self.selectionViewAction(in: self.viewSourceLocation)
                //self.selectionViewAction(in: self.viewDestinationLocation)
                self.mapViewHelper?.mapView?.drawPolygon(from: sourceCoordinate, to: destinationCoordinate)
                self.selectedLocationView = UIView()
            }
            
        }
        
        // MARK:- Get Favourite Locations
        
        private func getFavouriteLocations(){
            
            favouriteLocations.append((Constants.string.home,nil))
            favouriteLocations.append((Constants.string.work,nil))
            self.presenter?.get(api: .locationService, parameters: nil)
            
        }
        
    // MARK:- Cancel Request if it exceeds a certain interval
    
        @IBAction func validateRequest() {
            
            if riderStatus == .searching {
                UIApplication.shared.keyWindow?.makeToast(Constants.string.noDriversFound.localize())
                self.cancelRequest()
                
            }
        }
        
        
        // MARK:- SideMenu Button Action
        
        @IBAction private func sideMenuAction(){
            if self.isOnBooking { // If User is on Ride Selection remove all view and make it to default
               self.clearAllView()
                print("ViewAddressOuter ", #function)
            } else {
                self.drawerController?.openSide(selectedLanguage == .arabic ? .right : .left)
                self.viewSideMenu.addPressAnimation()
            }
            
        }
    
      // Clear Map
    
     func clearAllView() {
        self.removeLoaderView()
        self.removeUnnecessaryView(with: .cancelled)
        self.clearMapview()
        self.viewAddressOuter.isHidden = false
        self.viewLocationButtons.isHidden = false
    }
    

        // MARK:- Show DateTimePicker
        
        func schedulePickerView(on completion : @escaping ((Date)->())){
            
            var dateComponents = DateComponents()
            dateComponents.day = 7
            let now = Date()
            let maximumDate = Calendar.current.date(byAdding: dateComponents, to: now)
            dateComponents.minute = 5
            dateComponents.day = nil
            let minimumDate = Calendar.current.date(byAdding: dateComponents, to: now)
            let datePicker = DateTimePicker.create(minimumDate: minimumDate, maximumDate: maximumDate)
            datePicker.includeMonth = true
            datePicker.is12HourFormat = true
            datePicker.dateFormat = DateFormat.list.hhmmddMMMyyyy
            datePicker.highlightColor = .primary
            datePicker.doneBackgroundColor = .secondary
            datePicker.completionHandler = { date in
                completion(date)
                print(date)
            }
            datePicker.show()
        }
    
    
    // MARK:- Observe Network Changes
    @objc private func networkChanged(notification : Notification) {
        if let reachability = notification.object as? Reachability, ([Reachability.Connection.cellular, .wifi].contains(reachability.connection)) {
            self.getCurrentLocationDetails()
        }
      }

    }
    
    // MARK:- MapView
    
    extension HomeViewController : GMSMapViewDelegate {
        
        func mapView(_ mapView: GMSMapView, idleAt position: GMSCameraPosition) {
            
            if self.isUserInteractingWithMap {
                
                func getUpdate(on location : CLLocationCoordinate2D, completion :@escaping ((LocationDetail)->Void)) {
                    self.drawPolyline()
                    self.getServicesList()
                    self.mapViewHelper?.getPlaceAddress(from: location, on: { (locationDetail) in
                        completion(locationDetail)
                    })
                }
                
                if self.selectedLocationView == self.viewSourceLocation, self.sourceLocationDetail != nil {
    
                    if let location = mapViewHelper?.mapView?.projection.coordinate(for: viewMapOuter.center) {
                        self.sourceLocationDetail?.value?.coordinate = location
                        getUpdate(on: location) { (locationDetail) in
                            self.sourceLocationDetail?.value = locationDetail
                        }
                    }
                } else if self.selectedLocationView == self.viewDestinationLocation, self.destinationLocationDetail != nil {
                    
                    if let location = mapViewHelper?.mapView?.projection.coordinate(for: viewMapOuter.center) {
                        self.destinationLocationDetail?.coordinate = location
                        getUpdate(on: location) { (locationDetail) in
                            self.destinationLocationDetail = locationDetail
                            self.updateLocation(with: locationDetail) // Update Request Destination Location
                        }
                    }
                }
                
            }
            self.isMapInteracted(false)
            
          
            
        }
        
        func mapView(_ mapView: GMSMapView, willMove gesture: Bool) {
            
            print("Gesture ",gesture)
            self.isUserInteractingWithMap = gesture
            
            if self.isUserInteractingWithMap {
                self.isMapInteracted(true)
            }
            
        }
        
        func mapView(_ mapView: GMSMapView, didChange position: GMSCameraPosition) {
            
            // return
            
            if isUserInteractingWithMap {
                
                if self.selectedLocationView == self.viewSourceLocation, self.sourceLocationDetail != nil {
                    
                    self.sourceMarker.map = nil
                    self.imageViewMarkerCenter.tintColor = .secondary
                    self.imageViewMarkerCenter.image = #imageLiteral(resourceName: "sourcePin").withRenderingMode(.alwaysTemplate)
                    self.imageViewMarkerCenter.isHidden = false
                    //                if let location = mapViewHelper?.mapView?.projection.coordinate(for: viewMapOuter.center) {
                    //                    self.sourceLocationDetail?.value?.coordinate = location
                    //                    self.mapViewHelper?.getPlaceAddress(from: location, on: { (locationDetail) in
                    //                        print(locationDetail)
                    //                        self.sourceLocationDetail?.value = locationDetail
                    ////                        let sLocation = self.sourceLocationDetail
                    ////                        self.sourceLocationDetail = sLocation
                    //                    })
                    //                }
                    
                    
                } else if self.selectedLocationView == self.viewDestinationLocation, self.destinationLocationDetail != nil {
                    
                    self.destinationMarker.map = nil
                    self.imageViewMarkerCenter.tintColor = .primary
                    self.imageViewMarkerCenter.image = #imageLiteral(resourceName: "destinationPin").withRenderingMode(.alwaysTemplate)
                    self.imageViewMarkerCenter.isHidden = false
                    //                if let location = mapViewHelper?.mapView?.projection.coordinate(for: viewMapOuter.center) {
                    //                    self.destinationLocationDetail?.coordinate = location
                    //                    self.mapViewHelper?.getPlaceAddress(from: location, on: { (locationDetail) in
                    //                        print(locationDetail)
                    //                        self.destinationLocationDetail = locationDetail
                    //                    })
                    //                }
                }
                
            }
            //        else {
            //            self.destinationMarker.map = self.mapViewHelper?.mapView
            //            self.sourceMarker.map = self.mapViewHelper?.mapView
            //            self.imageViewMarkerCenter.isHidden = true
            //        }
            
        }
        
    }
    
    // MARK:- Service Calls
    
    extension HomeViewController  {
        
        // Check For Service Status
        
        private func checkForProviderStatus() {
          
            HomePageHelper.shared.startListening(on: { (error, request) in
                
                if error != nil {
                    riderStatus = .none
    //                    DispatchQueue.main.async {
    //                        showAlert(message: error?.localizedDescription, okHandler: nil, fromView: self)
    //                    }
                } else if request != nil {
                    if let requestId = request?.id {
                        self.currentRequestId = requestId
                    }
                    if let pLatitude = request?.provider?.latitude, let pLongitude = request?.provider?.longitude {
                        DispatchQueue.main.async {
                            self.moveProviderMarker(to: LocationCoordinate(latitude: pLatitude, longitude: pLongitude))
                            // MARK:- Showing Provider ETA
                            let currentStatus = request?.status ?? .none
                            if [RideStatus.accepted, .started, .arrived].contains(currentStatus) {
                                self.showETA(with: LocationCoordinate(latitude: pLatitude, longitude: pLongitude))
                            }
                        }
                    }
                    guard riderStatus != request?.status else {
                        return
                    }
                    riderStatus = request?.status ?? .none
                    self.isScheduled = ((request?.is_scheduled ?? false) && riderStatus == .searching)
                    self.handle(request: request!)
                } else {
                    
                    let previousStatus = riderStatus
                    riderStatus = request?.status ?? .none
                    if riderStatus != previousStatus {
                         self.clearMapview()
                    }
                    if self.isScheduled {
                        self.isScheduled = false
//                        if let yourtripsVC = Router.main.instantiateViewController(withIdentifier: Storyboard.Ids.YourTripsPassbookViewController) as? YourTripsPassbookViewController {
//                            yourtripsVC.isYourTripsSelected = true
//                            yourtripsVC.isFirstBlockSelected = false
//                            self.navigationController?.pushViewController(yourtripsVC, animated: true)
//                        }
                        self.removeUnnecessaryView(with: .cancelled)
                    } else {
                        self.removeUnnecessaryView(with: .none)
                    }
                    
                }
            })
        }
        
        
        // Get Services provided by Provider
        
        private func getServicesList() {
            if self.sourceLocationDetail?.value != nil, self.destinationLocationDetail != nil, riderStatus == .none || riderStatus == .searching { // Get Services only if location Available
                self.presenter?.get(api: .servicesList, parameters: nil)
            }
        }
        
        // Get Estimate Fare
        
        func getEstimateFareFor(serviceId : Int) {
            
            DispatchQueue.global(qos: .userInteractive).async {
                
                
                guard let sourceLocation = self.sourceLocationDetail?.value?.coordinate, let destinationLocation = self.destinationLocationDetail?.coordinate, sourceLocation.latitude>0, sourceLocation.longitude>0, destinationLocation.latitude>0, destinationLocation.longitude>0 else {
                    return
                }
                var estimateFare = EstimateFareRequest()
                estimateFare.s_latitude = sourceLocation.latitude
                estimateFare.s_longitude = sourceLocation.longitude
                estimateFare.d_latitude = destinationLocation.latitude
                estimateFare.d_longitude = destinationLocation.longitude
                estimateFare.service_type = serviceId
                
                self.presenter?.get(api: .estimateFare, parameters: estimateFare.JSONRepresentation)
                
            }
        }
        
      
        
        // Cancel Request
        
        func cancelRequest(reason : String? = nil) {
            
            if self.currentRequestId>0 {
                let request = Request()
                request.request_id = self.currentRequestId
                request.cancel_reason = reason
                self.presenter?.post(api: .cancelRequest, data: request.toData())
            }
        }
        
        
        // Create Request
        
        func createRequest(for service : Service, isScheduled : Bool, scheduleDate : Date?, cardEntity entity : CardEntity?, paymentType : PaymentType) {
            // Validate whether the card entity has valid data
            if paymentType == .CARD && entity == nil {
                UIApplication.shared.keyWindow?.make(toast: Constants.string.selectCardToContinue.localize())
                return
            }
            
            self.showLoaderView()
            DispatchQueue.global(qos: .background).async {
                let request = Request()
                request.s_address = self.sourceLocationDetail?.value?.address
                request.s_latitude = self.sourceLocationDetail?.value?.coordinate.latitude
                request.s_longitude = self.sourceLocationDetail?.value?.coordinate.longitude
                request.d_address = self.destinationLocationDetail?.address
                request.d_latitude = self.destinationLocationDetail?.coordinate.latitude
                request.d_longitude = self.destinationLocationDetail?.coordinate.longitude
                request.service_type = service.id
                request.payment_mode = paymentType
                request.distance = "\(service.pricing?.distance ?? 0)"
                request.use_wallet = service.pricing?.useWallet
                request.card_id = entity?.card_id
                if isScheduled {
                    if let dateString = Formatter.shared.getString(from: scheduleDate, format: DateFormat.list.ddMMyyyyhhmma) {
                        let dateArray = dateString.components(separatedBy: " ")
                        request.schedule_date = dateArray.first
                        request.schedule_time = dateArray.last
                    }
                }
                if let couponId = service.promocode?.id {
                    request.promocode_id = couponId
                }
                self.presenter?.post(api: .sendRequest, data: request.toData())
                
            }
        }
        
        // MARK:- Update Location for Existing Request
        
        func updateLocation(with detail : LocationDetail) {
            
            guard [RideStatus.accepted, .arrived, .pickedup, .started].contains(riderStatus) else { return } // Update Location only if status falls under certain category
            
            let request = Request()
            request.request_id = self.currentRequestId
            request.address = detail.address
            request.latitude = detail.coordinate.latitude
            request.longitude = detail.coordinate.longitude
            self.presenter?.post(api: .updateRequest, data: request.toData())
            
        }
        
        // MARK:- Change Payment Type For existing Request
        func updatePaymentType(with cardDetail : CardEntity) {
            
            let request = Request()
            request.request_id = self.currentRequestId
            request.payment_mode = .CARD
            request.card_id = cardDetail.card_id
            self.loader.isHideInMainThread(false)
            self.presenter?.post(api: .updateRequest, data: request.toData())
            
        }
        
        // MARK:- Favourite Location on Other Category
        func favouriteLocationApi(in view : UIView, isAdd : Bool) {
            
            guard isAdd else { return }
            
            let service = Service() // Save Favourite location in Server
            service.type = CoreDataEntity.other.rawValue.lowercased()
            if view == self.viewFavouriteSource, let address = self.sourceLocationDetail?.value {
                service.address = address.address
                service.latitude = address.coordinate.latitude
                service.longitude = address.coordinate.longitude
            } else if view == self.viewFavouriteDestination, self.destinationLocationDetail != nil {
                service.address = self.destinationLocationDetail!.address
                service.latitude = self.destinationLocationDetail!.coordinate.latitude
                service.longitude = self.destinationLocationDetail!.coordinate.longitude
            } else { return }
            
            self.presenter?.post(api: .locationServicePostDelete, data: service.toData())
            
        }
    }
    
    // MARK:- PostViewProtocol
    
    extension HomeViewController : RiderPostViewProtocol {
        
        func onError(api: Base, message: String, statusCode code: Int) {
            
            DispatchQueue.main.async {
                self.loader.isHidden = true
                if api == .locationServicePostDelete {
                    UIApplication.shared.keyWindow?.make(toast: message)
                } else {
                    if code != StatusCode.notreachable.rawValue && api != .checkRequest && api != .cancelRequest{
                        showAlert(message: message, okHandler: nil, fromView: self)
                    }
                    
                    
                }
                if api == .sendRequest {
                    self.removeLoaderView()
                }
            }
        }
        
        func getServiceList(api: Base, data: [Service]) {
            
            if api == .servicesList {
                DispatchQueue.main.async {  // Show Services
                    self.showRideNowView(with: data)
                }
            }
            
        }
        

        func getRequest(api: Base, data: Request?) {
            
            print(data?.request_id ?? 0)
            if api == .sendRequest {
                self.success(api: api, message: data?.message)
                self.currentRequestId = data?.request_id ?? 0
                self.checkForProviderStatus()
                DispatchQueue.main.async {
                    self.showLoaderView(with: self.currentRequestId)
                }
            }
        }
        
        func success(api: Base, message: String?) {
            
            self.loader.isHideInMainThread(true)
            if api == .updateRequest {
                riderStatus = .none
                return
            }
            
            if api == .locationServicePostDelete {
                self.presenter?.get(api: .locationService, parameters: nil)
            }else if api == .rateProvider  {
                isRateViewShowed = false
                riderStatus = .none
                return
            }
            if api != .payNow || api == .cancelRequest{
                if api == .cancelRequest {
                    riderStatus = .none
                }
//                DispatchQueue.main.async {
//                    self.view.makeToast(message)
//                }
            } else {
                riderStatus = .none // Make Ride Status to Default
                if api == .payNow { // Remove PayNow if Card Payment is Success
                    self.removeInvoiceView()
                }
            }
        }
        
        func getLocationService(api: Base, data: LocationService?) {
            
            self.loader.isHideInMainThread(true)
            storeFavouriteLocations(from: data)
            
        }
        func getProfile(api: Base, data: Profile?) {
            Common.storeUserData(from: data)
            storeInUserDefaults()
        }
        
    }
    
    
    

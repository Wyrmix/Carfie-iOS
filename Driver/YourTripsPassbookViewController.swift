//
//  yourTripViewController.swift
//  User
//
//  Created by CSS on 09/05/18.
//  Copyright © 2018 Appoets. All rights reserved.
//

import UIKit

class YourTripsPassbookViewController: UIViewController {
    
    @IBOutlet var pastBtn: UIButton!
    
    //@IBOutlet var pastUnderLineView: UIView!
    @IBOutlet var upCommingBtn: UIButton!
    
    //@IBOutlet var upCommingUnderLineView: UIView!
    @IBOutlet var labelFindDetails: UILabel!
    //@IBOutlet var tripTabelView: UITableView!
    @IBOutlet private var underLineView: UIView!
    @IBOutlet private var tableViewList : UITableView!
    
    @IBOutlet var labelhavenotBookRide: UILabel!
    @IBOutlet var viewNoData: UIView!
    var isYourTripsSelected = true // Boolean Handle Passbook and Yourtrips list
    let backgroundImage = UIImage(named: "nodata")
    var backGoriundImageView = UIImageView()
    var isFirstBlockSelected = true {
        didSet {
            self.animateUnderLine()
        }
    }
    
    private lazy var loader  : UIView = {
        return createActivityIndicator(UIScreen.main.focusedView ?? self.view)
    }()
    
    
    private var datasourceYourTripsUpcoming = [YourTripModelResponse]()
    private var datasourceYourTripsPast = [YourTripModelResponse]()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.backGoriundImageView.isHidden = true
        self.initalLoads()
        self.viewNoData.isHidden = true
        
        navigationController?.isNavigationBarHidden = false
        navigationController?.navigationBar.backItem?.title = ""
        navigationItem.title = (isYourTripsSelected ? Constants.string.yourTrips : Constants.string.passbook).localize()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //self.getData()
        self.switchViewAction()
        self.animateUnderLine()

    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        self.animateUnderLine()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.navigationController?.isNavigationBarHidden = false
    }
    
}

extension YourTripsPassbookViewController {
    
    private func initalLoads() {
        underLineView.backgroundColor = AppTheme.driver.primaryColor
       // setBackFroundImageForTableView()
        self.registerCell()
        setCommonFont()
        self.switchViewAction()
        self.localize()
        self.loader.isHidden = true
       // self.getData()
    }
    
    private func getData() {
        if isYourTripsSelected {
            self.presenter?.get(api: .upComming, parameters: nil)
            self.presenter?.get(api: .yourtrip, parameters: nil)
        }
    }
    
    private func setCommonFont(){
        setFont(TextField: nil, label: labelFindDetails, Button: nil, size: 20)
        setFont(TextField: nil, label: labelhavenotBookRide, Button: nil, size: 20)
        setFont(TextField: nil, label: nil, Button: upCommingBtn, size: nil)
        setFont(TextField: nil, label: nil, Button: pastBtn, size: nil)
    }
    
    
    private func setBackFroundImageForTableView(){
        
        backGoriundImageView = UIImageView(image: backgroundImage)
        backGoriundImageView.contentMode = .scaleAspectFit
        self.tableViewList.backgroundView = backGoriundImageView
    }
 
    private func localize(){
        
        self.pastBtn.setTitle(Constants.string.past.localize(), for: .normal)
        self.upCommingBtn.setTitle(Constants.string.upcomming.localize(), for: .normal)
        
    }
    
    private func registerCell(){
        
        tableViewList.register(UINib(nibName: XIB.Names.yourTripCell, bundle: nil), forCellReuseIdentifier: XIB.Names.yourTripCell)
       
    }
    
    
    // Animate under Line
    
    private func animateUnderLine() {
        UIView.animate(withDuration: 0.5) { //CGPoint((self.view.bounds.width/2)
            
            let viewFrame = self.isFirstBlockSelected ? self.pastBtn : self.upCommingBtn
            if viewFrame != nil {
                let frame = viewFrame!.convert(viewFrame!.center, to: self.view)
                self.underLineView.center.x = frame.x
            }
            //convert(viewFrame!.bounds, to: self.view)
            
            //self.isFirstBlockSelected ? self.pastBtn.center.x : self.upCommingBtn.center.x
        }
    }
    
    private func switchViewAction(){
       // self.pastUnderLineView.isHidden = false
        //self.isFirstBlockSelected = true
        self.pastBtn.tag = 1
        self.upCommingBtn.tag = 2
        self.pastBtn.addTarget(self, action: #selector(ButtonTapped(sender:)), for: .touchUpInside)
        self.upCommingBtn.addTarget(self, action: #selector(ButtonTapped(sender:)), for: .touchUpInside)
        self.getData()
    }
    
    @IBAction func ButtonTapped(sender: UIButton){
        self.loader.isHidden = false
        self.isFirstBlockSelected = sender.tag == 1
        
        if sender.tag == 1 {
            self.presenter?.get(api: .yourtrip, parameters: nil)
        }else{
            self.presenter?.get(api: .upComming, parameters: nil)
        }
        tableViewList.reloadData()
    }
    
    private func reloadTable() {
        DispatchQueue.main.async {
            self.loader.isHidden = true
            self.tableViewList.reloadData()
        }
    }
    
}

// MARK:- UITableViewDelegate

extension YourTripsPassbookViewController : UITableViewDelegate,UITableViewDataSource {
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return getCount().count
       
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        return self.getCell(for: indexPath, in: tableView)
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return (isYourTripsSelected ? (200.0-(isFirstBlockSelected ? 20 : 0)) : 120)*(UIScreen.main.bounds.height/568)
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        UIView.animate(withDuration: 0.5) {
            tableView.deselectRow(at: indexPath, animated: true)
        }
        
        guard isYourTripsSelected else { return }
        
        if let vc = self.storyboard?.instantiateViewController(withIdentifier: Storyboard.Ids.YourTripsDetailViewController) as? YourTripsDetailViewController, self.getCount().count>indexPath.row, let idValue = self.getCount()[indexPath.row].id {
            vc.isUpcomingTrips = !isFirstBlockSelected
            vc.setId(id: idValue)
            self.navigationController?.pushViewController(vc, animated: true)
        }
        
    }
    
    
    private func getCell(for indexPath : IndexPath, in tableView : UITableView)->UITableViewCell {
        
        if isYourTripsSelected {
            if let cell = tableView.dequeueReusableCell(withIdentifier: XIB.Names.yourTripCell, for: indexPath) as? YourTripCell {
                cell.isPastButton = isFirstBlockSelected
                let datasource = (self.isFirstBlockSelected ? self.datasourceYourTripsPast : self.datasourceYourTripsUpcoming)
                if datasource.count>indexPath.row{
                    cell.set(values: datasource[indexPath.row])
                }
                cell.onclickCancel = { [weak self] requestId in
                    guard let object = self else {return}
                    showAlert(message: Constants.string.cancelRequest.localize(), okHandler: { (isCancelClicked) in
                        guard isCancelClicked else {return}
                        object.loader.isHidden = false
                        var cancelModel = UpcomingCancelModel()
                        cancelModel.id = requestId
                        object.presenter?.post(api: .UpcommingCancel, data: cancelModel.toData())
                    }, fromView: object, isShowCancel: true, okTitle: Constants.string.cancelRide.localize(), cancelTitle: Constants.string.ignore.localize())
                }
                return cell
            }
        } else {
            
          
        }
        return UITableViewCell()
        
    }
    
    private func getCount()->[YourTripModelResponse] {
        
        if isYourTripsSelected {
            return (isFirstBlockSelected ? self.datasourceYourTripsPast : self.datasourceYourTripsUpcoming )
        } else {
            return (isFirstBlockSelected ? self.datasourceYourTripsPast : self.datasourceYourTripsUpcoming)
        }
        
    }
    
    
}

// MARK:- PostviewProtocol

extension YourTripsPassbookViewController : PostViewProtocol  {
    
    func onError(api: Base, message: String, statusCode code: Int) {
        print("Called", #function)
        DispatchQueue.main.async {
            self.loader.isHidden = true
            showAlert(message: message, okHandler: nil, fromView: self)
        }
    }
    
    func getRequestArray(api: Base, data: [YourTripModelResponse]?) {
        //print("Called", #function,data)
        if api == .yourtrip {
            self.datasourceYourTripsPast = data!
        } else if api == .upComming {
            self.datasourceYourTripsUpcoming = data!
        }
        reloadTable()
    }
    
    
    func getYourTripAPI(api: Base, data: [YourTripModelResponse]?) {
        if api == .yourtrip {
            self.datasourceYourTripsPast = data ?? []
            if isFirstBlockSelected {
                self.loader.isHidden = true
                if self.datasourceYourTripsPast.count == 0 {
                    self.viewNoData.isHidden = false
                    self.labelhavenotBookRide.text = Constants.string.bookedAnyRides.localize()
                    self.labelFindDetails.text = Constants.string.findBookingDetails.localize()
                }else {
                    self.viewNoData.isHidden = true
                }
            }
            
        }else if api == .upComming {
            self.datasourceYourTripsUpcoming = data ?? []
            if !isFirstBlockSelected {
                self.loader.isHidden = true
                if self.datasourceYourTripsUpcoming.count == 0 {
                    self.viewNoData.isHidden = false
                    self.labelhavenotBookRide.text = Constants.string.upcomingNorides.localize()
                    self.labelFindDetails.text = Constants.string.upcomingBookingDetails.localize()
                }else {
                    self.viewNoData.isHidden = true
                }
            }
        }
        reloadTable()
    }
    
    func getUpdateStatus(api: Base, data: UpdateTripStatusModelResponse?) {
        self.getData()
    }
}



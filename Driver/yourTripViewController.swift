//////
//////  yourTripViewController.swift
//////  User
//////
//////  Created by CSS on 09/05/18.
//////  Copyright © 2018 Appoets. All rights reserved.
//////
////
////import UIKit
////
////class yourTripViewController: UIViewController {
////
////    @IBOutlet var navBar: UINavigationBar!
////    @IBOutlet var navBackBtn: UIBarButtonItem!
////    @IBOutlet var navYourtrip: UIBarButtonItem!
////
////    @IBOutlet var pastBtn: UIButton!
////
////    @IBOutlet var pastUnderLineView: UIView!
////    @IBOutlet var upCommingBtn: UIButton!
////
////    @IBOutlet var upCommingUnderLineView: UIView!
////    @IBOutlet var tripTabelView: UITableView!
////
////    var yourTripData : [YourTripModelResponse]?
////
////
////    private var isFirstBlockSelected = true {
////        didSet {
////            UIView.animate(withDuration: 0.5) {
////                self.pastUnderLineView.frame.origin.x = self.isFirstBlockSelected ? 0 : (self.view.bounds.width/2)
////            }
////        }
////    }
////
////    override func viewDidLoad() {
////        super.viewDidLoad()
////
////    }
////
////    override func viewWillAppear(_ animated: Bool) {
////        removeBottomLine()
////        registerCell()
////        SetNavigationcontroller()
////        switchViewAction()
////        loadAPI()
////    }
////
////
////
////
////}
////
////extension yourTripViewController {
////
////    private func loadAPI(){
////       // self.presenter?.get(api: .yourtrip , url: "")
////        self.presenter?.get(api: .yourtrip, parameters: nil)
////    }
////
////
////
////    func SetNavigationcontroller(){
////        if #available(iOS 11.0, *) {
////            self.navigationController?.isNavigationBarHidden = false
////            // self.navigationController?.navigationBar.prefersLargeTitles = true
////            self.navigationController?.navigationBar.barTintColor = UIColor.white
////        } else {
////            // Fallback on earlier versions
////        }
////        title = Constants.string.inviteReferral
////
////        // self.navigationController?.navigationBar.tintColor = UIColor.white
////        // self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "back-icon"), style: .plain, target: self, action: #selector(summarytTableViewController.backBarButtonTapped(sender:)))
////    }
////
////
////
////    private func removeBottomLine(){ //MARK:- remove bottom line in navigation Bar
////        self.navBar.setBackgroundImage(UIImage(named: ""), for: UIBarMetrics.default)
////       self.navBar.shadowImage = UIImage(named: "")
////
////
////
////    }
////    private func setCommonFont(){
////
////        setFont(TextField: nil, label: nil, Button: pastBtn, size: nil)
////        setFont(TextField: nil, label: nil, Button: upCommingBtn, size: nil)
////
////    }
////
////    private func localize(){
////
////        self.pastBtn.setTitle(Constants.string.past, for: .normal)
////        self.upCommingBtn.setTitle(Constants.string.upcomming, for: .normal)
////
////    }
////
////    private func registerCell(){
////
////        tripTabelView.register(UINib(nibName: XIB.Names.yourTripCell, bundle: nil), forCellReuseIdentifier: XIB.Names.yourTripCell)
////
////    }
////
////
////    private func switchViewAction(){
////        self.pastUnderLineView.isHidden = false
////        self.upCommingUnderLineView.isHidden = true
////        self.pastBtn.tag = 1
////        self.upCommingBtn.tag = 2
////        self.pastBtn.addTarget(self, action: #selector(ButtonTapped(sender:)), for: .touchUpInside)
////        self.upCommingBtn.addTarget(self, action: #selector(ButtonTapped(sender:)), for: .touchUpInside)
////    }
////
////    @IBAction func ButtonTapped(sender: UIButton){
////        self.isFirstBlockSelected = sender.tag == 1
////        if sender.tag == 1 {
////            isFirstBlockSelected = true
////            //pastUnderLineView.showAnimateView(pastUnderLineView, isShow: true, direction: .Right, duration: 0.5)
////            self.presenter?.get(api: .yourtrip, parameters: nil)
////           // pastUnderLineView.isHidden = false
////           // upCommingUnderLineView.isHidden = true
////
////        }else if sender.tag == 2 {
////            isFirstBlockSelected = false
////            pastUnderLineView.isHidden = true
////            self.presenter?.get(api: .upComming, parameters: nil)
////            //upCommingUnderLineView.isHidden = false
////            //upCommingUnderLineView.showAnimateView(upCommingUnderLineView, isShow: true, direction: .Left)
////
////        }else {
////
////        }
////
////
////    }
////}
////
////extension yourTripViewController : UITableViewDelegate,UITableViewDataSource {
////
////
////    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
////        if (yourTripData?.count) != nil {
////            return (yourTripData?.count)!
////        }else{
////            return 0
////        }
////
////    }
////
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: XIB.Names.yourTripCell, for: indexPath) as! YourTripCell
//        let dateStr = yourTripData?[indexPath.row].finished_at
//        let date = Formatter.shared.getDate(from: dateStr, format: DateFormat.list.yyyy_mm_dd_HH_MM_ss)
//        let dateString = Formatter.shared.getString(from: date, format: DateFormat.list.ddmmmmyyyy)
//
//       // let imageUrl = String(contentsOf: yourTripData?[indexPath.row].static_map)
//        Cache.image(forUrl: "\(baseUrl)/\(Constants.string.storage)/\(String(describing: yourTripData?[indexPath.row].static_map!))") { (image) in
//            DispatchQueue.main.async {
//
//                cell.mapImageView?.image = image == nil ? #imageLiteral(resourceName: "young-male-avatar-image") : image
//            }
//        }
//
//        cell.dateLabel.text = dateString
//        cell.bookingIdLabel.text = yourTripData?[indexPath.row].booking_id
//        cell.upComingView.isHidden = true
//
//
//        return cell
//
//    }
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return 230.0
//    }
////
////}
////
////
////extension yourTripViewController : PostViewProtocol {
////    func onError(api: Base, message: String, statusCode code: Int) {
////        print(message)
////    }
////
////    func getYourTripAPI(api: Base, data: [YourTripModelResponse]?) {
////
////        self.yourTripData = data
////        self.tripTabelView.reloadData()
////       // print(self.yourTripData?[0].id!)
////
////    }
////
////
////}

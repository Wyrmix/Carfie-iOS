//
//  SideBarTableViewController.swift
//  User
//
//  Created by CSS on 02/05/18.
//  Copyright © 2018 Appoets. All rights reserved.
//

import UIKit

class SideBarTableViewController: UITableViewController {
    
    @IBOutlet weak var sideBarHeaderView: UIView! {
        didSet {
            sideBarHeaderView.backgroundColor = AppTheme.rider.primaryColor
        }
    }
    
    @IBOutlet private var imageViewProfile : UIImageView!
    
    @IBOutlet private var labelName: UILabel! {
        didSet {
            labelName.textAlignment = .left
            labelName.font = .carfieBodyBold
            labelName.textColor = .white
        }
    }
    
    @IBOutlet private var labelEmail: UILabel! {
        didSet {
            labelEmail.textAlignment = .left
            labelEmail.font = .carfieMicrocopy
            labelEmail.textColor = .white
        }
    }
    
    @IBOutlet private var viewShadow : UIView!
    @IBOutlet private weak var profileImageCenterContraint : NSLayoutConstraint!
    
    // private let sideBarList = [Constants.string.payment,Constants.string.yourTrips,Constants.string.coupon,Constants.string.wallet,Constants.string.passbook,Constants.string.settings,Constants.string.help,Constants.string.share,Constants.string.inviteReferral,Constants.string.faqSupport,Constants.string.termsAndConditions,Constants.string.privacyPolicy,Constants.string.logout]
    
    private let sideBarList = [Constants.string.payment,
                               Constants.string.yourTrips,
                               Constants.string.offer,
                               Constants.string.wallet,
                               Constants.string.passbook,
                               Constants.string.settings,
                               Constants.string.help,
                               Constants.string.share,
                               Constants.string.becomeADriver,
                               Constants.string.logout]
    
    private let cellId = "cellId"
    
    private lazy var loader : UIView = {
        
        return createActivityIndicator(self.view)
        
    }()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        self.initialLoads()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.localize()
        self.setValues()
        self.navigationController?.isNavigationBarHidden = true
        //self.prefersStatusBarHidden = true
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        self.setLayers()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
       // self.prefersStatusBarHidden = false
    }
    
}

// MARK:- Methods

extension SideBarTableViewController {
    
    private func initialLoads() {
        tableView.backgroundColor = AppTheme.rider.tintColor

        self.drawerController?.shadowOpacity = 0.2
        let fadeWidth = self.view.frame.width*(0.2)
        self.drawerController?.drawerWidth = Float(self.view.frame.width - fadeWidth)
        self.viewShadow.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.imageViewAction)))
    }
    
    // MARK:- Set Designs
    
    private func setLayers(){
        
        //self.viewShadow.addShadow()
        self.imageViewProfile.makeRoundedCorner()
        
    }
    
    
    //MARK:- SetValues
    
    private func setValues(){
        
        let url = (User.main.picture?.contains(WebConstants.string.http) ?? false) ? User.main.picture : Common.getImageUrl(for: User.main.picture)
        
        Cache.image(forUrl: url) { (image) in
            DispatchQueue.main.async {
                self.imageViewProfile.image = image == nil ? #imageLiteral(resourceName: "userPlaceholder") : image
            }
        }
        self.labelName.text = String.removeNil(User.main.firstName)+" "+String.removeNil(User.main.lastName)
        self.labelEmail.text = User.main.email
    }
    
    
    
    // MARK:- Localize
    private func localize(){
        
        self.tableView.reloadData()
        
    }
    
    // MARK:- ImageView Action
    
    @IBAction private func imageViewAction() {
        
        let homeVC = Router.user.instantiateViewController(withIdentifier: Storyboard.Ids.ProfileViewController)
        (self.drawerController?.getViewController(for: .none) as? UINavigationController)?.pushViewController(homeVC, animated: true)
        self.drawerController?.closeSide()
        
    }
    
    
    // MARK:- Selection Action For TableView
    
    private func select(at indexPath : IndexPath) {
        
        switch (indexPath.section,indexPath.row) {
            
        case (0,0):
            push(to: ListPaymentViewController.viewController(for: .rider))
        case (0,1):
            fallthrough
        case (0,4):
            if let vc = self.drawerController?.getViewController(for: .none)?.storyboard?.instantiateViewController(withIdentifier: Storyboard.Ids.YourTripsPassbookViewController) as? YourTripsPassbookViewController {
                vc.isYourTripsSelected = indexPath.row == 1
                if indexPath.row == 1{
                    vc.isFromTrips = true
                }
                (self.drawerController?.getViewController(for: .none) as? UINavigationController)?.pushViewController(vc, animated: true)
            }
        case (0,2):
            self.push(to: CouponCollectionViewController())
        case (0,3):
            self.push(to: Storyboard.Ids.WalletViewController)
        case (0,5):
            self.push(to: Storyboard.Ids.SettingTableViewController)
        case (0,6):
            push(to: HelpViewController.viewController())
        case (0,7):
            (self.drawerController?.getViewController(for: .none)?.children.first as? HomeViewController)?.share(items: [baseUrl])
        case (0,8):
            Common.open(url: baseUrl)
        case (0,9):
            self.logout()
            
        default:
            break
        }
        
    }
    
    private func push(to identifier : String) {
         let viewController = self.storyboard!.instantiateViewController(withIdentifier: identifier)
        (self.drawerController?.getViewController(for: .none) as? UINavigationController)?.pushViewController(viewController, animated: true)
        
    }
    
    private func push(to viewController: UIViewController) {
        guard let navigationController = drawerController?.getViewController(for: .none) as? UINavigationController else {
            fatalError("KWDrawerController has no UINavigationController")
        }

        navigationController.pushViewController(viewController, animated: true)
    }
    
    // MARK:- Logout
    
    private func logout() {
        
        let alert = UIAlertController(title: nil, message: Constants.string.areYouSureWantToLogout.localize(), preferredStyle: .actionSheet)
        let logoutAction = UIAlertAction(title: Constants.string.logout.localize(), style: .destructive) { (_) in
            self.loader.isHidden = false
            self.presenter?.post(api: .logout, data: nil)
        }
        
        let cancelAction = UIAlertAction(title: Constants.string.Cancel.localize(), style: .cancel, handler: nil)
        
        alert.view.tintColor = .primary
        alert.addAction(logoutAction)
        alert.addAction(cancelAction)
        
        self.present(alert, animated: true, completion: nil)
    }
    
}


// MARK:- TableView

extension SideBarTableViewController {
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let tableCell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath)
        tableCell.textLabel?.textColor = AppTheme.rider.tintColor
        tableCell.textLabel?.text = sideBarList[indexPath.row].localize().capitalizingFirstLetter()
        tableCell.textLabel?.textAlignment = .left
        Common.setFont(to: tableCell.textLabel!, isTitle: true)
        return tableCell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sideBarList.count
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.select(at: indexPath)
        self.drawerController?.closeSide()
    }
    
}


// MARK:- PostViewProtocol

extension SideBarTableViewController : RiderPostViewProtocol {
    
    func onError(api: Base, message: String, statusCode code: Int) {
        
        DispatchQueue.main.async {
            self.loader.isHidden = true
            showAlert(message: message, okHandler: nil, fromView: self)
        }
    }
    
    func success(api: Base, message: String?) {
        DispatchQueue.main.async {
            self.loader.isHidden = true
            forceLogout()
        }
    }
}


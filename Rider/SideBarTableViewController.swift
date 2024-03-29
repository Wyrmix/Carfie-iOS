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
    
    @IBOutlet weak var appVersionLabel: UILabel! {
        didSet {
            appVersionLabel.text = "App Version: 1.3"
        }
    }
    
    private let sideBarList = [Constants.string.payment,
                               Constants.string.yourTrips,
                               Constants.string.offer,
                               Constants.string.wallet,
                               Constants.string.passbook,
                               Constants.string.settings,
                               Constants.string.help,
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.localize()
        self.setValues()
        self.navigationController?.isNavigationBarHidden = true
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        self.setLayers()
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
        let profileViewController = NewProfileViewController.viewController()
        (drawerController?.getViewController(for: .none) as? UINavigationController)?.pushViewController(profileViewController, animated: true)
        drawerController?.closeSide()
    }
    
    
    // MARK:- Selection Action For TableView
    
    private func select(at indexPath : IndexPath) {
        
        switch (indexPath.section, indexPath.row) {
            
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
            openDriverLink()
        case (0,8):
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
    
    private func openDriverLink() {
        guard let navigationController = drawerController?.getViewController(for: .none) as? UINavigationController else {
            fatalError("KWDrawerController has no UINavigationController")
        }
        
        SafariIntent(url: WebPage.carfieHomePage)?.execute(via: navigationController)
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
    
    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return AppVersionView()
    }
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 44
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


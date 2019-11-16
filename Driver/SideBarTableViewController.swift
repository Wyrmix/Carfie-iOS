//
//  SideBarTableViewController.swift
//  User
//
//  Created by CSS on 02/05/18.
//  Copyright © 2018 Appoets. All rights reserved.
//

import UIKit

class SideBarTableViewController: UITableViewController {
    
    @IBOutlet var imageAccountStatus: UIImageView!
    @IBOutlet private var imageViewProfile : UIImageView!
    @IBOutlet private var labelName : UILabel!
    @IBOutlet private var viewShadow : UIView!
    @IBOutlet var labelEmail: UILabel!
    private let sideBarList = [Constants.string.yourTrips,Constants.string.Earnings,Constants.string.Summary,Constants.string.wallet,Constants.string.card, Constants.string.help,Constants.string.settings,Constants.string.logout]
    
    private let cellId = "cellId"
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initialLoads()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.localize()
        self.setValues()
        self.setAccountStatus()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        self.setDesigns()
    }
}

// MARK:- Methods

extension SideBarTableViewController {
    
    private func initialLoads() {
        
        // self.drawerController?.fadeColor = UIColor
        self.drawerController?.shadowOpacity = 0.2
        let fadeWidth = self.view.frame.width*(1/5)
        //self.profileImageCenterContraint.constant = -(fadeWidth/2)
        self.drawerController?.drawerWidth = Float(self.view.frame.width - fadeWidth)
        self.viewShadow.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.imageViewAction)))
        
    }
    
    private func setAccountStatus(){
        if BackGroundTask.backGroundInstance.accountStatus == AccountStatus.banned {
            self.imageAccountStatus.image = selectedLanguage == .arabic ? #imageLiteral(resourceName: "Badge_Red_arabic") : #imageLiteral(resourceName: "Badge_Red")
        }else if BackGroundTask.backGroundInstance.accountStatus == AccountStatus.approved {
            self.imageAccountStatus.image = selectedLanguage == .arabic ? #imageLiteral(resourceName: "Badge_Green_arabic") : #imageLiteral(resourceName: "Badge_Green")
        }else {
            self.imageAccountStatus.image = selectedLanguage == .arabic ? #imageLiteral(resourceName: "Badge_Orange_arabic") : #imageLiteral(resourceName: "Badge_Orange")
        }
//        let transform = CGAffineTransform(scaleX: -1, y: 1)
//        self.imageAccountStatus.transform = selectedLanguage == .arabic ? transform : .identity
    }
    
    // MARK:- Set Designs
    
    private func setDesigns(){
        
       // self.viewShadow.addShadow()
        self.imageViewProfile.makeRoundedCorner()
        
        
    }
    
    
    //MARK:- SetValues
    
    private func setValues(){
        
            Cache.image(forUrl: "\(baseUrl)/\(Constants.string.storage)/\(String(describing: User.main.picture ?? "0"))") { (image) in
                DispatchQueue.main.async {
                    self.imageViewProfile.image = image == nil ? #imageLiteral(resourceName: "young-male-avatar-image") : image
                }
            }
            
            self.labelName.text = String.removeNil(User.main.firstName)+" "+String.removeNil(User.main.lastName)
            self.labelEmail.text = String.removeNil(User.main.email)
        
        
    }
    
    
    private func logout() {
       
        let alert = UIAlertController(title: nil, message: Constants.string.logoutMessage.localize(), preferredStyle: .actionSheet)
        let logoutAction = UIAlertAction(title: Constants.string.logout.localize(), style: .destructive) { (_) in
            //self.loader.isHidden = false
            let user = User()
            user.id = User.main.id
            self.presenter?.post(api: .logout, data: user.toData())
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
    // MARK:- ImageView Action
    
    @IBAction private func imageViewAction() {
        
        let profileVC = Router.user.instantiateViewController(withIdentifier: Storyboard.Ids.ProfileViewController)
            let baseVC = self.drawerController?.getViewController(for: .none) as! UINavigationController
            baseVC.pushViewController(profileVC, animated: true)
        self.drawerController?.closeSide()
        
    }
    
    // MARK:- Localize
    private func localize(){
        Common.setFont(to: labelName)
        Common.setFont(to: labelEmail, size : 10)
        self.tableView.reloadData()
        self.tableView.separatorStyle = .none
    }
    

}



// MARK:- TableView

extension SideBarTableViewController {
    
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if !User.main.isCardAllowed && indexPath.row == 4 { // If not is allowed hide it
            return 0
        }
        return 44.0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let tableCell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath)
        tableCell.textLabel?.textColor = .secondary
        //tableCell.textLabel?.font = UIFont(name: FontCustom.clanPro_Book.rawValue, size: 10)
        tableCell.textLabel?.text = sideBarList[indexPath.row].localize().capitalizingFirstLetter()
        tableCell.textLabel?.textAlignment = .left
        setFont(TextField: nil, label: tableCell.textLabel, Button: nil, size: nil)
        
        return tableCell
    }
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sideBarList.count
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let baseVC = self.drawerController?.getViewController(for: .none) as? UINavigationController
        
        if indexPath.row == 0 {//yourtrips
            let yourTripVC = Router.user.instantiateViewController(withIdentifier: Storyboard.Ids.yourTripsPassbookViewController)
            baseVC?.pushViewController(yourTripVC, animated: true)
            
        }else if indexPath.row == 1 {//earnings
            
            let earningVC = Router.main.instantiateViewController(withIdentifier: Storyboard.Ids.EarningsViewController)
            
            baseVC?.pushViewController(earningVC, animated: true)
        }else if indexPath.row == 2 {//summary
            
            let summaryVC = Router.main.instantiateViewController(withIdentifier: Storyboard.Ids.summarytTableViewController)
            
            baseVC?.pushViewController(summaryVC, animated: true)
            
        }else if indexPath.row == 3{ //Wallet
            let walletVC = Router.main.instantiateViewController(withIdentifier: Storyboard.Ids.WalletViewController)
            baseVC?.pushViewController(walletVC, animated: true)
            
        }else if indexPath.row == 4 {//Card
            baseVC?.pushViewController(ListPaymentViewController.viewController(for: .driver), animated: true)
            
        } else if indexPath.row == 5 {
            baseVC?.pushViewController(HelpViewController.viewController(), animated: true)
        }else if indexPath.row == 6 {
            let helpVC = Router.user.instantiateViewController(withIdentifier: Storyboard.Ids.SettingTableViewController)
            baseVC?.pushViewController(helpVC, animated: true)
        }else {
            self.logout()
        }
        
        self.drawerController?.closeSide()
    }
}



extension SideBarTableViewController : PostViewProtocol {
    
    func onError(api: Base, message: String, statusCode code: Int) {
        print(message)
    }
    
    func getSucessMessage(api: Base, data: String?) {
        print(data!)
        forceLogout()
    }

}

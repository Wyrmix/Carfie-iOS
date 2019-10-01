//
//  inviteReferralViewController.swift
//  User
//
//  Created by CSS on 11/05/18.
//  Copyright © 2018 Appoets. All rights reserved.
//

import UIKit

class inviteReferralViewController: UIViewController {
    
    
    //MARK:- Label outlets
    @IBOutlet var labelReferYourFriend: UILabel!
    @IBOutlet var labelGivenFreeRide: UILabel!
    @IBOutlet var labelShareYourCode: UILabel!
    @IBOutlet var labelInviteCode: UILabel!
    @IBOutlet var labelRefferalEarning: UILabel!
    @IBOutlet var labelReferralEarningCode: UILabel!
    @IBOutlet var labelTotalmember: UILabel!
    
    //MARk:- button outslets:
    @IBOutlet var buttonInvitreFriends: UIButton!
    
    //MARK:- imageView outlets:
    @IBOutlet var imageShare: UIImageView!
    
    //MARK:- stackView outLets:
    @IBOutlet var labelTotalMemberValue: UIStackView!
    
    //MARK:- UIbarbutton outlets:
    @IBOutlet var barTitle: UIBarButtonItem!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.localize()
        setCommonFont()
        SetNavigationcontroller()
    }
    
    
    
}

extension inviteReferralViewController {
    
    func SetNavigationcontroller(){
        if #available(iOS 11.0, *) {
            self.navigationController?.isNavigationBarHidden = false
            // self.navigationController?.navigationBar.prefersLargeTitles = true
            self.navigationController?.navigationBar.barTintColor = UIColor.white
        } else {
            // Fallback on earlier versions
        }
        title = Constants.string.inviteReferral
        
        // self.navigationController?.navigationBar.tintColor = UIColor.white
        // self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "back-icon"), style: .plain, target: self, action: #selector(summarytTableViewController.backBarButtonTapped(sender:)))
    }
    private func setCommonFont(){
        
        setFont(TextField: nil, label: labelInviteCode, Button: buttonInvitreFriends, size: nil)
        setFont(TextField: nil, label: labelTotalmember, Button: nil, size: nil)
        setFont(TextField: nil, label: labelGivenFreeRide, Button: nil, size: nil)
        setFont(TextField: nil, label: labelShareYourCode, Button: nil
            , size: nil)
        setFont(TextField: nil, label: labelReferYourFriend, Button: nil, size: 20)
        setFont(TextField: nil, label: labelReferralEarningCode, Button: nil, size: nil)
        
        setFont(TextField: nil, label: labelRefferalEarning, Button: nil, size: nil)
    }
    
    private func localize(){
        self.barTitle.title = Constants.string.title
        self.labelReferYourFriend.text = Constants.string.referYourFriend
        self.labelGivenFreeRide.text = Constants.string.givenFreeRide
        self.labelShareYourCode.text = Constants.string.shareYourCode
        self.labelRefferalEarning.text = Constants.string.refferalEarning
        self.labelTotalmember.text = Constants.string.totalMembers
        self.buttonInvitreFriends.setTitle(Constants.string.invideFriends, for: .normal)
    }
    
}

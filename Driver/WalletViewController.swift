//
//  WalletViewController.swift
//  Provider
//
//  Created by CSS on 12/09/18.
//  Copyright © 2018 Appoets. All rights reserved.
//

import UIKit

class WalletViewController: UIViewController {
    
    @IBOutlet private weak var labelWalletString : UILabel! {
        didSet {
            labelWalletString.font = .carfieBodyBold
            labelWalletString.text = "Your wallet amount is"
        }
    }
    
    @IBOutlet private weak var labelWalletAmount : UILabel! {
        didSet {
            labelWalletAmount.font = .carfieHeroHeading
            labelWalletAmount.textColor = AppTheme.driver.primaryColor
        }
    }
    
    @IBOutlet private weak var tableViewWallet : UITableView!
    @IBOutlet private weak var viewHeader : UIView!
    
    private var barbuttonTransfer : UIBarButtonItem!
    private var datasource = [WalletTransaction]()
    
    private var balance : Float = 0 {
        didSet {
            DispatchQueue.main.async {
                self.labelWalletAmount.text = "\(User.main.currency ?? .Empty)\(Formatter.shared.limit(string: "\(self.balance)", maximumDecimal: 2))"
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.initialLoads()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewWillAppearCustom()
        navigationController?.navigationBar.backItem?.title = ""
        navigationController?.isNavigationBarHidden = false
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        UIApplication.shared.keyWindow?.hideAllToasts(includeActivity: true, clearQueue: true)
    }
    
}

// MARK:- Methods
extension WalletViewController {
    
    private func initialLoads() {
        
        self.tableViewWallet.tableHeaderView = viewHeader
        self.tableViewWallet.delegate = self
        self.tableViewWallet.dataSource = self
        self.tableViewWallet.register(UINib(nibName: XIB.Names.WalletListTableViewCell, bundle: nil), forCellReuseIdentifier: XIB.Names.WalletListTableViewCell)
        self.tableViewWallet.register(UINib(nibName: XIB.Names.WalletHeader, bundle: nil), forHeaderFooterViewReuseIdentifier: XIB.Names.WalletHeader)
        self.labelWalletAmount.text = "\(User.main.currency ?? .Empty)\(2222)"
        
        self.navigationItem.title = Constants.string.wallet.localize()
        self.barbuttonTransfer = UIBarButtonItem(image: #imageLiteral(resourceName: "transfer").withRenderingMode(.alwaysTemplate), style: .plain, target: self, action: #selector(self.buttonTransferAction))
        self.navigationItem.rightBarButtonItem = self.barbuttonTransfer
        self.balance = User.main.walletBalance ?? 0
    }
    
    private func viewWillAppearCustom() {
        self.balance = User.main.walletBalance ?? 0
        self.presenter?.get(api: .getWalletHistory, parameters: nil)
    }
    
    @IBAction private func buttonTransferAction() {
        
        if self.balance <= 0 {
            UIApplication.shared.keyWindow?.make(toast: Constants.string.minimumBalance.localize())
        }else if let vc = self.storyboard?.instantiateViewController(withIdentifier: Storyboard.Ids.WalletTransferViewController) as? WalletTransferViewController {
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    // MARK:- Empty View
    
    private func checkEmptyView() {
        
        self.tableViewWallet.backgroundView = {
            
            if (self.datasource.count) == 0 {
                let label = Label(frame: UIScreen.main.bounds)
                label.numberOfLines = 0
                Common.setFont(to: label, isTitle: true)
                label.center = UIApplication.shared.keyWindow?.center ?? .zero
                label.backgroundColor = .clear
                label.textColor = AppTheme.driver.primaryColor
                label.textAlignment = .center
                label.text = Constants.string.noTransactionsYet.localize()
                return label
            } else {
                return nil
            }
        }()
    }
    
    private func reloadTable() {
        DispatchQueue.main.async {
            self.checkEmptyView()
            self.tableViewWallet.reloadData()
        }
    }
    
}


extension WalletViewController : UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let tableCell = tableView.dequeueReusableCell(withIdentifier: XIB.Names.WalletListTableViewCell, for: indexPath) as? WalletListTableViewCell {
            if self.datasource.count > indexPath.row {
                tableCell.set(values : self.datasource[indexPath.row])
            }
            return tableCell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.datasource.count
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let walletHeader = Bundle.main.loadNibNamed(XIB.Names.WalletHeader, owner: self, options: [:])?.first as? WalletHeader
        walletHeader?.backgroundColor = AppTheme.driver.primaryColor
        return walletHeader
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 60
    }
    
}

extension WalletViewController :PostViewProtocol {
   
    func onError(api: Base, message: String, statusCode code: Int) {
        print(message)
    }
    
    func getWalletEntity(api: Base, data: WalletEntity?) {
        if let balance = data?.wallet_balance, let datasource = data?.wallet_transation {
            self.balance = balance
            User.main.walletBalance = balance
            storeInUserDefaults()
            self.datasource = datasource
        }
        self.reloadTable()
    }
    
}

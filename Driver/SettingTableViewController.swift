//
//  SettingTableViewController.swift
//  User
//
//  Created by CSS on 03/08/18.
//  Copyright © 2018 Appoets. All rights reserved.
//

import UIKit

class SettingTableViewController: UITableViewController {
    @IBOutlet var settingTableview: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        SetNavigationcontroller()
    }

    func SetNavigationcontroller(){
        navigationController?.isNavigationBarHidden = false
        navigationController?.navigationBar.prefersLargeTitles = false
        navigationController?.navigationBar.backItem?.title = ""
        title = "Settings"
    }

    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "settingPageCell", for: indexPath) as! settingPageCell
        cell.textLabel?.textAlignment = .left
        cell.textLabel?.font = .carfieBody
        cell.textLabel?.text = Constants.string.documents.localize()
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        navigationController?.pushViewController(DocumentsViewController.viewController(), animated: true)
    }
}

class settingPageCell : UITableViewCell {}

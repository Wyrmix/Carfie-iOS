//
//  SettingTableViewController.swift
//  User
//
//  Created by CSS on 25/05/18.
//  Copyright © 2018 Appoets. All rights reserved.
//

import UIKit
import PopupDialog

class SettingTableViewController: UITableViewController {
    
    private let tableCellId = "tableCellid"
    private let languageCellId = "LanguageSelection"
    private var numberOfRows = 2
    
    private let header = ["Favorites", .Empty]
    
    private let favouriteLocation = 0
    private let otherLocations = 1
    
    lazy var loader  : UIView = {
        return createActivityIndicator(UIApplication.shared.keyWindow ?? self.view)
    }()
    
    private var locationService : LocationService?
    private var mapHelper : GoogleMapsHelper?
    private var placesHelper : GooglePlacesHelper?
    private var serviceObject : Service?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initalLoads()
    }
}

//MARK:- Methods
extension SettingTableViewController {
    
    private func initalLoads() {
        navigationController?.isNavigationBarHidden = false
        navigationController?.navigationBar.backItem?.title = ""
        navigationItem.title = Constants.string.settings.localize()
        loader.isHidden = false
        presenter?.get(api: .locationService, parameters: nil)
    }
    
    private func initMaps() {
        
        if self.mapHelper == nil {
            self.mapHelper = GoogleMapsHelper()
        }
        if self.placesHelper == nil {
            self.placesHelper = GooglePlacesHelper()
        }
        
    }
    
    private func delete(at indexPath : IndexPath, completion : (()->Void)) {
        
        var idValue : Int?
        
        if indexPath.section == self.favouriteLocation {
            idValue = indexPath.row == 0 ? self.locationService?.home?.first?.id : self.locationService?.work?.first?.id
        } else if indexPath.section == self.otherLocations, Int.removeNil(self.locationService?.others?.count) > indexPath.row {
            idValue = self.locationService?.others?[indexPath.row].id
        }
        
        guard idValue != nil else
        { completion()
            return }
        
        self.loader.isHideInMainThread(false)
        self.presenter?.delete(api: .locationServicePostDelete, url: Base.locationServicePostDelete.rawValue+"/\(idValue!)", data: nil)
        
    }
    
}

extension SettingTableViewController {
    
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return self.header.count
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return self.header[section]
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return self.getCell(for:tableView,at:indexPath)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return section == self.favouriteLocation ? numberOfRows : Int.removeNil(self.locationService?.others?.count)
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            
            let popDialog = PopupDialog(title: Constants.string.areYouSure.localize(), message: nil)
            let cancelButton =  PopupDialogButton(title: Constants.string.Cancel.localize(), action: {
                popDialog.dismiss()
            })
            cancelButton.titleColor = .primary
            let sureButton = PopupDialogButton(title: Constants.string.delete.localize()) {
                self.delete(at: indexPath, completion: { })
            }
            sureButton.titleColor = .red
            popDialog.addButtons([sureButton,cancelButton])
            self.present(popDialog, animated: true, completion: nil)
            
        }
        
    }
    
    override func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        
        if indexPath.section == self.favouriteLocation  || indexPath.section == self.otherLocations{
            if (indexPath.row == 0 && (locationService?.home?.first?.address) != nil) || (indexPath.row == 1 && (locationService?.work?.first?.address) != nil) || indexPath.section == self.otherLocations {
                return .delete
            }
        }
        return .none
    }
    
    
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return (indexPath.section == self.favouriteLocation ? 80 : 60)*(UIScreen.main.bounds.height/568)
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        self.didSelect(at: indexPath)
    }
    
    
    private func didSelect(at indexPath : IndexPath) {
        if indexPath.section ==  self.favouriteLocation {
            self.loader.isHidden = false
            self.initMaps()
            self.loader.isHidden = true
            self.placesHelper?.getGoogleAutoComplete { (place) in
                self.mapHelper?.getPlaceAddress(from: place.coordinate, on: { (locationDetail) in
                    let service = Service() // Save Favourite location in Server
                    service.address = place.formattedAddress
                    service.latitude = place.coordinate.latitude
                    service.longitude = place.coordinate.longitude
                    service.type = (indexPath.row == 0 ? CoreDataEntity.home.rawValue : CoreDataEntity.work.rawValue).lowercased()
                    self.serviceObject = service
                    self.delete(at: indexPath, completion: {
                        self.presenter?.post(api: .locationServicePostDelete, data: self.serviceObject?.toData())
                        self.serviceObject = nil
                    })
                })
            }
        }
    }
    
    private func switchSettingPage() {
        self.navigationController?.isNavigationBarHidden = true // For Changing backbutton direction on RTL Changes
        guard let transitionView = self.navigationController?.view else {return}
        let settingVc = Router.main.instantiateViewController(withIdentifier: Storyboard.Ids.SettingTableViewController)
        UIView.beginAnimations("anim", context: nil)
        UIView.setAnimationDuration(0.8)
        UIView.setAnimationCurve(.easeInOut)
        UIView.setAnimationTransition(selectedLanguage == .arabic ? .flipFromLeft : .flipFromRight, for: transitionView, cache: false)
        self.navigationController?.pushViewController(settingVc, animated: true)
        self.navigationController?.isNavigationBarHidden = false
        UIView.commitAnimations()
        if Int.removeNil(navigationController?.viewControllers.count) > 2 {
            self.navigationController?.viewControllers.remove(at: 1)
        }
    }
    
    // Get Cell
    
    private func getCell(for tableView : UITableView,at indexPath : IndexPath) -> UITableViewCell {
        
        if indexPath.section == self.favouriteLocation, let tableCell = tableView.dequeueReusableCell(withIdentifier: tableCellId, for: indexPath) as? SettingTableCell {
            
            tableCell.imageViewIcon?.image = indexPath.row == 0 ? #imageLiteral(resourceName: "home") : #imageLiteral(resourceName: "work")
            tableCell.labelTitle.text = (indexPath.row == 0 ? Constants.string.home : Constants.string.work).localize()
            tableCell.labelAddress.text = {
                
                if indexPath.row == 0 {
                    return (locationService?.home?.first?.address) != nil ? (locationService?.home?.first?.address) : Constants.string.addLocation.localize()
                } else {
                    return (locationService?.work?.first?.address) != nil ? (locationService?.work?.first?.address) : Constants.string.addLocation.localize()
                }
                
            }()
            tableCell.selectionStyle = .none
            return tableCell
        } else if indexPath.section == self.otherLocations, Int.removeNil(self.locationService?.others?.count) > indexPath.row{
            let tableCell = UITableViewCell(style: .default, reuseIdentifier: nil)
            Common.setFont(to: tableCell.textLabel!)
            tableCell.textLabel?.numberOfLines = 0
            tableCell.textLabel?.text = self.locationService?.others?[indexPath.row].address
            tableCell.selectionStyle = .none
            return tableCell
        }
        
        return UITableViewCell()
    }
    
}

// MARK:- PostViewProtocol

extension SettingTableViewController : RiderPostViewProtocol {
    
    func onError(api: Base, message: String, statusCode code: Int) {
        DispatchQueue.main.async {
            self.loader.isHidden = true
            showAlert(message: message, okHandler: nil, fromView: self)
        }
    }
    
    func getLocationService(api: Base, data: LocationService?) {
    
        storeFavouriteLocations(from: data)
        self.locationService = data
        DispatchQueue.main.async {
            self.loader.isHidden = true
            self.tableView.reloadData()
        }
        
    }
    
    func success(api: Base, message: String?) {
        
        if api == .locationServicePostDelete {
            if serviceObject != nil {
                self.presenter?.post(api: .locationServicePostDelete, data: serviceObject?.toData())
            } else {
                self.presenter?.get(api: .locationService, parameters: nil)
            }
            self.serviceObject = nil
        }
    }
    
}

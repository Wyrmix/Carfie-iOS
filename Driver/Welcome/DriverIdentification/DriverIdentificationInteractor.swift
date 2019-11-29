//
//  DriverIdentificationInteractor.swift
//  Driver
//
//  Created by Christopher Olsen on 11/18/19.
//  Copyright © 2019 Carfie. All rights reserved.
//

import UIKit

class DriverIdentificationInteractor: NSObject {
    weak var viewController: DriverIdentificationViewController?
    
    /// Text field that is currently being edited by the use
    private var activeTextInputView: CarfieTextInputView?
    
    private var selectedVehicleType: Int?
    
    let profileController: ProfileController
    
    init(profileController: ProfileController = CarfieProfileController()) {
        self.profileController = profileController
        super.init()
        addObservers()
    }
    
    private func addObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: UIResponder.keyboardDidShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    func saveDriverInformation(ssn: String?, dateOfBirth: String?, model: String?, number: String?) {
        do {
            let ssn = try SSNValidator().validate(ssn).resolve()
            let dateOfBirth = try EmptyFieldValidator().validate(dateOfBirth).resolve()
            let model = try EmptyFieldValidator().validate(model).resolve()
            let number = try EmptyFieldValidator().validate(number).resolve()
            updateProfile(withSSN: ssn, dateOfBirth: dateOfBirth, model: model, number: number)
        } catch {
            return
        }
    }
    
    func updateProfile(withSSN ssn: String, dateOfBirth: String, model: String, number: String) {
        viewController?.animateNetworkActivity(true)
        
        guard let typeIndex = selectedVehicleType, let vehicleType = VehicleType(rawValue: typeIndex) else { return }
        
        let vehicleIdentification = VehicleIdentification(model: model, number: number, type: vehicleType)
        let info = DriverIdentification(ssn: ssn, dateOfBirth: dateOfBirth, vehicleIdentification: vehicleIdentification)
        
        profileController.updateDriverIdentification(info) { result in
            self.viewController?.animateNetworkActivity(false)
            
            switch result {
            case .success:
                self.viewController?.onboardingDelegate?.onboardingScreenComplete()
            case .failure:
                UserFacingErrorIntent(title: "Something went wrong", message: "Please try again.").execute(via: self.viewController)
            }
        }
    }
}

extension DriverIdentificationInteractor: CarfieTextInputViewDelegate {
    func textInputViewDidBeginEditing(_ textInputView: CarfieTextInputView) {
        activeTextInputView = textInputView
    }
    
    func textInputViewDidEndEditing(_ textInputView: CarfieTextInputView) {
        _ = textInputView.validate()
        activeTextInputView = nil
    }
    
    func textInputViewShouldReturn(_ textInputView: CarfieTextInputView) -> Bool {
        _ = textInputView.validate()
        return true
    }
}

// MARK: - Keyboard Management
extension DriverIdentificationInteractor {
    @objc private func keyboardWillShow(notification: NSNotification) {
        guard let userInfo = notification.userInfo,
              let keyboardSize = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }
        
        let keyboardFrame = keyboardSize.cgRectValue
        let contentInsets = UIEdgeInsets(top: 0, left: 0, bottom: keyboardFrame.height, right: 0)
        viewController?.adjustScrollViewForKeyboard((insets: contentInsets, frame: keyboardFrame), and: activeTextInputView)
    }
    
    @objc private func keyboardWillHide(notification: NSNotification) {
        viewController?.adjustScrollViewForKeyboard((insets: .zero, frame: .zero), and: nil)
    }
}

extension DriverIdentificationInteractor: UIPickerViewDataSource, UIPickerViewDelegate {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return VehicleType.allCases.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return VehicleType.allCases[row].description
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedVehicleType = VehicleType.allCases[row].rawValue
        viewController?.presentVehicleType(VehicleType.allCases[row].description)
    }
}

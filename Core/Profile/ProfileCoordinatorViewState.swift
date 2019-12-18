//
//  ProfileCoordinatorViewState.swift
//  Carfie
//
//  Created by Christopher Olsen on 12/17/19.
//  Copyright © 2019 Carfie. All rights reserved.
//

import UIKit

struct ProfileCoordinatorViewState {
    var profilePhoto: UIImage? = UIImage(named: "EmptyUserImage") {
        didSet {
            profilePhotoWasUpdated = true
        }
    }
    
    var profile: CarfieProfile?
    var updateProfileRequestInProgress: Bool = false
    var profilePhotoWasUpdated: Bool = false
}

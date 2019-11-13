//
//  SettingTableViewCell.swift
//  Rider
//
//  Created by Christopher Olsen on 11/12/19.
//  Copyright © 2019 Carfie. All rights reserved.
//

import UIKit

class SettingTableCell: UITableViewCell {
    @IBOutlet var labelTitle : UILabel! {
        didSet {
            labelTitle.font = .carfieBodyBold
        }
    }
    
    @IBOutlet var labelAddress : UILabel! {
        didSet {
            labelAddress.font = .carfieBody
        }
    }
    
    @IBOutlet var imageViewIcon : UIImageView! {
        didSet {
            imageViewIcon.contentMode = .scaleAspectFit
        }
    }
}

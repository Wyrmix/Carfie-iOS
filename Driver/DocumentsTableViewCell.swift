//
//  DocumentsTableViewCell.swift
//  Provider
//
//  Created by CSS on 24/09/18.
//  Copyright © 2018 Appoets. All rights reserved.
//

import UIKit

class DocumentsTableViewCell: UITableViewCell {
    
    @IBOutlet private weak var imageViewPreview : UIImageView!
    @IBOutlet private weak var viewImagePreview : UIView!
    @IBOutlet private weak var buttonAddEdit : UIButton!
    @IBOutlet private weak var buttonDelete : UIButton!
    
    private var isImageAdded : Bool = false {
        didSet {
            self.buttonAddEdit.setTitle({
                return (isImageAdded ? Constants.string.edit : Constants.string.add).localize()
            }(), for: .normal)
            self.buttonDelete.isHidden = true
        }
    }
    
    var onclickAdd : (( _ id:Int,_ completion : @escaping((UIImage?)->()))->Void)?
    var onclickDelete : ((Int)->Void)?
    
    private var id = 0
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.initialLoads()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
    }
    
}

// MARK:- Methods
extension DocumentsTableViewCell {
    
    
    private func initialLoads() {
        self.isImageAdded = false
        self.localize()
        self.setDesign()
        self.buttonAddEdit.addTarget(self, action: #selector(self.buttonActionEditAdd), for: .touchUpInside)
        self.buttonDelete.addTarget(self, action: #selector(self.buttonDeleteAction), for: .touchUpInside)
    }
    
    private func setDesign() {
        Common.setFont(to: self.buttonDelete,isTitle: true)
        Common.setFont(to: self.buttonAddEdit,isTitle: true)
    }
    
    private func localize() {
        self.buttonDelete.setTitle(Constants.string.delete.localize(), for: .normal)
    }
    
    func set(values : DocumentsModel, modifiedDocuments documents : [Int:(image : UIImage, data : Data)]){
        if let docId = values.id, let imageObject = documents[docId] {
            self.imageViewPreview.image = imageObject.image
            self.isImageAdded = true
        } else {
           self.imageViewPreview.setImage(with: Common.getImageUrl(for: values.providerdocuments?.url), placeHolder: #imageLiteral(resourceName: "backgroundImage"))
           self.isImageAdded = values.providerdocuments != nil
        }
        self.id = values.id ?? 0
        
    }
    
    //  Initimate superview about image the id to which it is added
    @IBAction private func buttonActionEditAdd() {
            self.onclickAdd?(self.id, { image in
                if image != nil {
                    self.imageViewPreview.image = image
                }
                self.isImageAdded = image != nil
            })
    }
    
    // Delete Current image 
    @IBAction private func buttonDeleteAction() {
        if id>0 {
            self.imageViewPreview.setImage(with: nil, placeHolder: #imageLiteral(resourceName: "backgroundImage"))
            self.onclickDelete?(self.id)
        }
    }
}


    //
//  RatingView.swift
//  User
//
//  Created by CSS on 24/05/18.
//  Copyright © 2018 Appoets. All rights reserved.
//

import UIKit

class RatingView: UIView {

    @IBOutlet  weak var labelRating:UILabel!
    @IBOutlet  weak var imageViewProvider : UIImageView!
    @IBOutlet  weak var viewRating : FloatRatingView!
    @IBOutlet  weak var textViewComments : UITextView!
    @IBOutlet  weak var buttonSubmit : UIButton!

    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.initialLoads()
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        self.imageViewProvider.makeRoundedCorner()
    }
    
    var onclickRating : ((_ rating : Int,_ comments : String)->Void)?
    
}

extension RatingView {
    
    func initialLoads() {
       
        self.textViewComments.delegate = self
        textViewDidEndEditing(textViewComments)
        self.localize()
        self.buttonSubmit.addTarget(self, action: #selector(self.buttonActionRating), for: .touchUpInside)
        self.viewRating.minRating = 1
        self.viewRating.maxRating = 5
        self.viewRating.rating = 1
        self.viewRating.emptyImage = #imageLiteral(resourceName: "StarEmpty")
        self.viewRating.fullImage = #imageLiteral(resourceName: "StarFull")
        self.setDesign()
    }
    
    // MARK:- Set Designs
    
    private func setDesign() {
        
//        Common.setFont(to: labelRating, isTitle: true)
//        Common.setFont(to: textViewComments)
//        Common.setFont(to: buttonSubmit, isTitle: true)
        setFont(TextField: nil, label: labelRating, Button: nil, size: nil)
        setFont(TextField: nil, label: nil, Button: buttonSubmit, size: nil)
        
    }
    
    
    //MARK:- Localize
    
    private func localize() {
        
        self.labelRating.text = Constants.string.rateyourtrip.localize()
        self.buttonSubmit.setTitle(Constants.string.submit.localize(), for: .normal)
    }
    
    @IBAction private func buttonActionRating() {
        self.onclickRating?(Int(viewRating.rating), textViewComments.text)
    }
    
    
    
//    func set(request : Request) {
//        
//        self.labelRating.text = "\(Constants.string.rateyourtrip.localize()) \(String.removeNil(request.provider?.first_name)) \(String.removeNil(request.provider?.last_name))"
//        
//        Cache.image(forUrl:Common.getImageUrl(for: request.provider?.avatar)) { (image) in
//            if image != nil {
//                DispatchQueue.main.async {
//                    self.imageViewProvider.image = image
//                }
//            }
//        }
//    }
    
    
    
}

    //MARK:- UITextViewDelegate
 extension RatingView : UITextViewDelegate {
        
        func textViewDidBeginEditing(_ textView: UITextView) {
            
            if textView.text == Constants.string.writeYourComments.localize() {
                textView.text = .Empty
                textView.textColor = .black
            }
        }
        
        func textViewDidEndEditing(_ textView: UITextView) {
            
            if textView.text == .Empty {
                textView.text = Constants.string.writeYourComments.localize()
                textView.textColor = .lightGray
            }
            
        }
        
        func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
            
            if(text == "\n") {
                textView.resignFirstResponder()
                return false
            }
            
            return true
        }}

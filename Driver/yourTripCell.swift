//
//  YourTripCell.swift
//  User
//
//  Created by CSS on 09/05/18.
//  Copyright © 2018 Appoets. All rights reserved.
//

import UIKit

class YourTripCell: UITableViewCell {

    //MARK:- view outlets
    @IBOutlet var mainView: UIView!
    //@IBOutlet var pastView: UIView!
    @IBOutlet var upComingView: UIView!
    
    //MARK:- UIimageView outLets
    @IBOutlet var upCommingCarImage: UIImageView!
    @IBOutlet var mapImageView: UIImageView!

    
    //MARK:- label outlets
    @IBOutlet var upCommingDateLabel: UILabel!
    @IBOutlet var upCommingBookingIDLlabel: UILabel!
    @IBOutlet var upCommingCarName: UILabel!
    /*@IBOutlet var bookingIdLabel: UILabel!
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var dateLabel: UILabel! */
    
    //MARK:- button outlets
    @IBOutlet var upCommingCancelBtn: UIButton!
    @IBOutlet private var labelPrice : UILabel!
    @IBOutlet private var labelModel : UILabel!
    @IBOutlet private var stackViewPrice : UIStackView!
    var requestId : Int?
    @IBOutlet var viewCarBack: UIView!
    var isPastButton = false {
        didSet {
            self.stackViewPrice.isHidden = !isPastButton
            self.upCommingCancelBtn.isHidden = isPastButton
        }
    }
    
    lazy var loader : UIView = {
       return createActivityIndicator(UIApplication.shared.keyWindow!)
    }()
    
    var onclickCancel:((Int)->())?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setCommonFont()
        self.upCommingCancelBtn.setTitle(Constants.string.cancelRide.localize(), for: .normal)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
         self.viewCarBack.makeRoundedCorner()
    }
    
    // MARK:- Set Font
    
    @IBAction func ActionCancelButton(_ sender: Any) {
        
        if self.requestId != nil {
            self.onclickCancel?(self.requestId!)
        }
        
    }
    private func setDesign() {
        
//        Common.setFont(to: upCommingDateLabel)
//        Common.setFont(to: upCommingBookingIDLlabel)
//        Common.setFont(to: upCommingCarName)
//        Common.setFont(to: labelModel)
//        Common.setFont(to: labelPrice)
        
        
        
        
        
    }
    
    // MARK:- Set Values
    
    func set(values : YourTripModelResponse?) {
        print(isPastButton)
        
        self.requestId = values?.id
        Cache.image(forUrl: values?.static_map) { (image) in
            if image != nil {
                self.upCommingCarImage.image = image
            }else{
                DispatchQueue.main.async {
                     self.upCommingCarImage.image = #imageLiteral(resourceName: "CarplaceHolder")
                }
               
            }
        }
        
        let mapImage = values?.static_map?.replacingOccurrences(of: "%7C", with: "|").addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        
        Cache.image(forUrl: mapImage) { (image) in
            if image != nil {
                DispatchQueue.main.async {
                    self.mapImageView.image = image
                }
            }
        }
        
        self.upCommingBookingIDLlabel.text = Constants.string.bookingId.localize()+": "+String.removeNil(values?.booking_id)
       // self.upCommingCarName.text = values.service?.name
        self.upCommingCarName.isHidden = isPastButton
        
        if let dateObject = Formatter.shared.getDate(from: isPastButton ? values?.assigned_at : values?.schedule_at, format: DateFormat.list.yyyy_mm_dd_HH_MM_ss)
        {
            let dateString = Formatter.shared.getString(from: dateObject, format: DateFormat.list.ddMMMyyyy)
            let timeString = Formatter.shared.getString(from: dateObject, format: DateFormat.list.hhMMTTA)
            self.upCommingDateLabel.text = dateString+" \(Constants.string.at.localize()) "+timeString
        }
       // self.labelModel.text = values?.provider.
        if self.isPastButton {
            //self.labelModel.text = values
            self.labelPrice.text = "\(String.removeNil(User.main.currency ?? "$")) \(values?.payment?.total ?? 0)"
            self.labelModel.text = values?.service_type?.name
            
        }
        
        Cache.image(forUrl: values?.service_type?.image) { (image) in
            
            DispatchQueue.main.async {
                self.upCommingCarImage.image = image == nil ? #imageLiteral(resourceName: "CarplaceHolder") : image
            }
            
        }
       
        
    }
    
    
    
    private func setCommonFont(){
      
        setFont(TextField: nil, label: upCommingBookingIDLlabel, Button: nil, size: 12)
        setFont(TextField: nil, label: upCommingDateLabel, Button: upCommingCancelBtn, size: 12)
        setFont(TextField: nil, label: upCommingCarName, Button: nil, size: 12)
        //setFont(TextField: nil, label: labelModel, Button: nil, size: 12)
        setFont(TextField: nil, label: labelModel, Button: nil, size: 12, with: true)
        setFont(TextField: nil, label: labelPrice, Button: nil, size: 12)
//        setFont(TextField: nil, label: bookingIdLabel, Button: nil, size: nil )
//        setFont(TextField: nil, label:nameLabel , Button: nil, size: nil)
//        setFont(TextField: nil, label: dateLabel , Button: nil, size: nil)
        
        
    
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}



extension YourTripCell : PostViewProtocol{
    func onError(api: Base, message: String, statusCode code: Int) {
        print(message)
        self.loader.isHidden = true
        UIApplication.shared.keyWindow?.makeToast(message)
    }
    
    
    func getUpdateStatus(api: Base, data: UpdateTripStatusModelResponse?) {
        self.loader.isHidden = true
        if data != nil {
            
        }
        UIApplication.shared.keyWindow?.makeToast(Constants.string.rideCancel.localize())
        //print(data)
    }
    
    
    
}

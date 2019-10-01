//
//  User.swift
//  User
//
//  Created by CSS on 17/01/18.
//  Copyright © 2018 Appoets. All rights reserved.
//


import Foundation

class User : NSObject, NSCoding, JSONSerializable {
    
    static var main = User()
        
    var id : Int?
    var name : String?
    var accessToken : String?
    var latitude : Double?
    var lontitude : Double?
    var firstName : String?
    var lastName :String?
    var picture : String?
    var email : String?
    var mobile : String?
    var currency : String?
    var serviceType : String?
    var serviceId : Int?
    var loginType : String?
    var walletBalance : Float?
    var measurement : String?
    var isCardAllowed : Bool
    var stripeKey : String?
    
    init(id : Int?, name : String?, accessToken: String?, latitude: Double?, lontitude: Double?, firstName: String?, lastName : String?, email : String?, phoneNumber: String?,serviceType: String?,serviceId: Int?,loginType : String?,picture: String?, currency : String?, walletBalance : Float?, measurement : String?, isCardAllowed : Bool, stripeKey : String?){
                
        self.id = id
        self.name = name
        self.accessToken = accessToken
        self.latitude = latitude
        self.lontitude = lontitude
        self.firstName = firstName
        self.lastName = lastName
        self.mobile = phoneNumber
        self.email = email
        self.serviceType = serviceType
        self.serviceId = serviceId
        self.loginType = loginType
        self.picture = picture
        self.currency = currency
        self.walletBalance = walletBalance
        self.measurement = measurement
        self.isCardAllowed = isCardAllowed
        self.stripeKey = stripeKey
    }
    
    convenience
    override init(){
       
        self.init(id: nil, name: nil, accessToken: nil, latitude: nil, lontitude: nil, firstName: nil, lastName: nil, email: nil, phoneNumber:  nil, serviceType: nil,serviceId: nil,loginType : nil, picture: nil, currency: nil, walletBalance : nil,measurement : "km", isCardAllowed:true, stripeKey: nil)
    }
    
    
    required convenience init?(coder aDecoder: NSCoder) {
        
        let id = aDecoder.decodeObject(forKey: Keys.list.id) as? Int
        let name = aDecoder.decodeObject(forKey: Keys.list.name) as? String
        let accessToken = aDecoder.decodeObject(forKey: Keys.list.accessToken) as? String
        let latitude = aDecoder.decodeObject(forKey: Keys.list.latitude) as? Double
        let lontitude = aDecoder.decodeObject(forKey: Keys.list.lontitude) as? Double
        let firstNmae = aDecoder.decodeObject(forKey: Keys.list.firstName) as? String
        let lastName = aDecoder.decodeObject(forKey: Keys.list.lastName) as? String
        let email = aDecoder.decodeObject(forKey: Keys.list.email) as? String
        let phoneNumber = aDecoder.decodeObject(forKey: Keys.list.mobile) as? String
        let serviceType = aDecoder.decodeObject(forKey: Keys.list.serviceType) as? String
        let serviceId = aDecoder.decodeObject(forKey: Keys.list.seriviceId) as? Int
         let loginType = aDecoder.decodeObject(forKey: Keys.list.loginType) as? String
        let picture = aDecoder.decodeObject(forKey: Keys.list.picture) as? String
        let currency = aDecoder.decodeObject(forKey: Keys.list.currency) as? String
        let walletBalance = aDecoder.decodeObject(forKey: Keys.list.walletBalance) as? Float
        let measurement = aDecoder.decodeObject(forKey: Keys.list.measurement) as? String
        let isCardAllowed = aDecoder.decodeInteger(forKey: Keys.list.card) == 1
        let stripeKey = aDecoder.decodeObject(forKey: Keys.list.stripe) as? String
        
        self.init(id: id, name: name, accessToken: accessToken, latitude: latitude, lontitude: lontitude, firstName: firstNmae, lastName: lastName, email: email, phoneNumber: phoneNumber, serviceType: serviceType, serviceId : serviceId,loginType : loginType, picture: picture, currency: currency, walletBalance : walletBalance, measurement : measurement, isCardAllowed : isCardAllowed, stripeKey : stripeKey)
    }
    
    
    func encode(with aCoder: NSCoder) {
        
        aCoder.encode(self.id, forKey: Keys.list.id)
        aCoder.encode(self.name, forKey: Keys.list.name)
        aCoder.encode(self.accessToken, forKey: Keys.list.accessToken)
        aCoder.encode(self.lontitude, forKey: Keys.list.lontitude)
        aCoder.encode(self.latitude, forKey: Keys.list.latitude)
        aCoder.encode(self.firstName, forKey: Keys.list.firstName)
        aCoder.encode(self.lastName, forKey: Keys.list.lastName)
        aCoder.encode(self.email, forKey: Keys.list.email)
        aCoder.encode(self.mobile, forKey: Keys.list.mobile)
        aCoder.encode(self.serviceType, forKey: Keys.list.serviceType)
        aCoder.encode(self.serviceId, forKey: Keys.list.seriviceId)
        aCoder.encode(self.loginType, forKey: Keys.list.loginType)
        aCoder.encode(self.picture, forKey: Keys.list.picture)
        aCoder.encode(self.currency, forKey: Keys.list.currency)
        aCoder.encode(self.walletBalance, forKey: Keys.list.walletBalance)
        aCoder.encode(self.measurement, forKey: Keys.list.measurement)
        aCoder.encode(self.isCardAllowed ? 1 : 0 , forKey: Keys.list.card)
        aCoder.encode(self.stripeKey , forKey: Keys.list.stripe)
        
    }
    
    
  
   
}










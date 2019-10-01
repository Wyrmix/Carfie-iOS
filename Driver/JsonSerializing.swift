
//
//  jsonSerializing.swift
//  Appoets
//
//  Created by Developer on 13/07/17.
//  Copyright © 2017 Developer. All rights reserved.
//

import Foundation


protocol JSONSerializable : Codable {
    var JSONRepresentation : [String : Any] { get }
}

extension JSONSerializable {
    
    
    var JSONRepresentation : [String : Any] {
        
        var representation = [String:Any]()
        
        for case let (label?, value) in Mirror(reflecting: self).children {
            
            switch value {
            case let value as Dictionary<String,Any>:
                
                representation[label] = value as AnyObject
                
            case let value as Array<Any>:
                
                if let val = value as? [JSONSerializable]{
                    representation[label] = val.map({ $0.JSONRepresentation as AnyObject}) as AnyObject
                } else {
                    representation[label] = value as AnyObject
                }
                
            case let value as JSONSerializable:
                
                representation[label] = value.JSONRepresentation
                
            case let value as AnyObject :
                
                representation[label] = value
                
            default: break
            }
        }
        return representation
    }
    
    // Convert to data by Encoding
    
    func toData()->Data? {
        
        do {
            
           return try JSONEncoder().encode(self)
            
        } catch let err {
            print("Error in Encoding ", self.JSONRepresentation, err.localizedDescription)
            return nil
        }
        
    }
    
    
    
//    func toData()->Data?{  // Convert struct directly into json request
//
//        let representation = JSONRepresentation
//
//        return getData(representation)
//
//
//    }
    
}

// MARK:- For Data

extension Data {
    
     func getDecodedObject<T>(from object : T.Type)->T? where T : Decodable {
        
        do {
            
            return try JSONDecoder().decode(object, from: self)
            
        } catch let error {
             print("Manually parsing \n\n")
            if let dict = try? JSONSerialization.jsonObject(with: self, options: .allowFragments) {
                print(dict)
            }
            
//            func loop(dict : NSDictionary) {
//                for dictt in dict {
//                    print("\(dictt.key) = \(dictt.value)  : Type  : \(type(of: dictt.value))")
//                }
//            }
//
//            print("Manually parsing \n\n")
//            if let dict = try? JSONSerialization.jsonObject(with: self, options: .allowFragments) {
//                if dict is [NSDictionary] {
//                    for value in dict as! [NSDictionary] {
//                       loop(dict: value)
//                    }
//                } else if dict is NSDictionary {
//                    loop(dict: dict as! NSDictionary)
//                } else {
//                    print(dict)
//                }
//            }
            
            print("Error in Decoding OBject ", error.localizedDescription)
            return nil
        }
        
    }
    
}



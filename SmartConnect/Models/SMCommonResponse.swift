//
//  ABSCustomer.swift
//  Model Generated using http://www.jsoncafe.com/
//  Created on May 29, 2019

import Foundation
import Gloss

//MARK: - ABSCustomer
public struct SMCommonResponse: Glossy {
    
    public var result : String!
    public var error : Error!
    var errorMessage : String!
    
    //MARK: Decodable
    public init?(json: JSON){
        result = "result" <~~ json
        errorMessage = "error" <~~ json
        
        error = NetworkError.error(json: json)
    }
    
    
    //MARK: Encodable
    public func toJSON() -> JSON? {
        return jsonify([
            "error" ~~> errorMessage,
            "result" ~~> result
            ])
    }
    
}

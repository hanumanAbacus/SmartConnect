//
//  Configurations.swift
//  AbacusSync
//
//  Created by Hanuman on 28/5/19.
//  Copyright © 2019 Hanuman. All rights reserved.
//

import Foundation

public enum Environment: String {
    case Staging = "staging"
    case Production = "production"
    case StubLocal = "stubLocal"
    
    public func baseURL(businessEnvironment: Environment) -> String {
        switch businessEnvironment {
        case .Staging: return "https://api-dev.smart-connect.cloud"
        case .Production, .StubLocal: return "https://api.smart-connect.cloud"
        }
    }
}

class SMConfiguration {
    var registerName: String? = nil
    var registerId: String? = nil
    var businessName: String? = nil
    var vendorName: String? = nil
    var businessEnvironment: String? = nil
    
    static let apiVersion = "POS"
    static var shared: SMConfiguration = SMConfiguration()
    
    static var environment: Environment = {
        
        if let configuration = Bundle.main.object(forInfoDictionaryKey: "Configuration") as? String {
            switch configuration {
            case "StubLocal":
                return Environment.StubLocal
            case "Debug":
                return Environment.Staging
            default:
                return Environment.Production
            }
        }
        return Environment.Production
    }()
    
    public func update(registerId: String,registerName: String, businessName: String, vendorName: String, businessEnvironment: String){
        self.registerId = registerId
        self.registerName = registerName
        self.businessName = businessName
        self.vendorName = vendorName
        self.businessEnvironment = businessEnvironment
    }
    
    public func defaultParameters() -> [String: Any] {
        return ["POSRegisterID": self.registerId as Any ,
                "POSRegisterName": self.registerName as Any,
               "POSBusinessName": self.businessName as Any,
               "POSVendorName": self.vendorName as Any,
               "POSBusinessEnvironment": self.businessEnvironment as Any]
    }
}


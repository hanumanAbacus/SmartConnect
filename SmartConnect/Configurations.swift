//
//  Configurations.swift
//  AbacusSync
//
//  Created by Hanuman on 28/5/19.
//  Copyright © 2019 Hanuman. All rights reserved.
//

import Foundation

let registerId = "6bd3bf1c-11cb-42ae-92c7-46ac39680166"
let registerName = "Register 1"
let businessName = "Demo Shop"
let vendorName = "Test POS"

enum Environment: String {
    case Staging = "staging"
    case Production = "production"
    case StubLocal = "stubLocal"
    
    var baseURL: String {
        switch self {
        case .Staging: return "https://api-dev.smart-connect.cloud"
        case .Production, .StubLocal: return "https://api-dev.smart-connect.cloud"
        }
    }
}

struct SMConfiguration {
    static let apiVersion = "POS"

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
    
    static func defaultParameters() -> [String: Any] {
        return ["POSRegisterID": registerId,
                "POSRegisterName": registerName,
               "POSBusinessName": businessName,
               "POSVendorName": vendorName]
    }
}

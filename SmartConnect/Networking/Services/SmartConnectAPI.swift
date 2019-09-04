//
//  AbacusAPI.swift
//  AbacusSync
//
//  Created by Hanuman on 28/5/19.
//  Copyright © 2019 Hanuman. All rights reserved.
//

import Foundation
import Moya

enum TransactionType: String {
    case defaultType = ""
    
    enum QR: String {
        case merchantPurchase = "QR.Merchant.Purchase"
        case consumerPurchase = "QR.Consumer.Purchase"
        case refund = "QR.Refund"
    }
    
    enum Journal: String {
        case reprintReceipt = "Journal.ReprintReceipt"
    }

    enum Terminal: String {
        case getStatus = "Terminal.GetStatus"
        case readCard = "Terminal.ReadCard"
    }

    enum Acquirer: String {
        case logon = "Acquirer.Logon"
        case settlementInquiry = "Acquirer.Settlement.Inquiry"
        case settlementCutover = "Acquirer.Settlement.Cutover"
    }

    enum Card: String {
        case purchase = "Card.Purchase"
        case refund = "Card.Refund"
        case purchasePlusCash = "Card.PurchasePlusCash"
        case cashAdvance = "Card.CashAdvance"
        case authorise = "Card.Authorise"
        case finalise = "Card.Finalise"
    }
}

enum TransactionMode: String {
    case ASYNC = "ASYNC"
    case SYNC = "" // need to send empty
}

enum SmartConnectAPI {    
    case pairing(pairingCode: String, address: SMAddress?)
    case transaction(type: TransactionType, saleData: String?, posNotificationCallbackUrl: String?)
}

extension SmartConnectAPI: TargetType, AccessTokenAuthorizable {
    var headers: [String: String]? {
        var header = [String: String]()
        return header
    }

    var authorizationType: AuthorizationType {
        switch self {
        case .pairing,
             .transaction:
            return .none
        default:
            return .bearer
        }
    }

    var parameterEncoding: Moya.ParameterEncoding {
        return URLEncoding.default
    }
    
    var task: Task {
        let encoding = URLEncoding.default
        if let requestParameters = parameters {
            return .requestParameters(parameters: requestParameters, encoding: encoding)
        }
        return .requestPlain
    }
    
    ///
    var requiresRefererHeader: Bool {
        switch self.method {
        case .post, .put:
            return true
        default:
            return false
        }
    }
    
    ///
    var baseURL: URL {
        let url: String = SMConfiguration.environment.baseURL
        return URL(string: url)!
    }
    
    ///
    var path: String {
        switch self {
        case .pairing(let pairingCode, _):
            return "/\(SMConfiguration.apiVersion)/Pairing/\(pairingCode)"
        case .transaction(_, _, _):
            return "/\(SMConfiguration.apiVersion)/Transaction/"
        }
    }
    
    ///
    var method: Moya.Method {
        switch self {
        case .pairing(_, _):
            return .put
        case .transaction(_, _, _):
             return .post
        default:
            // All requests are GET unless specified otherwise
            return .get
        }
        
    }
    
    ///
    var parameters: [String: Any]? {
        var defaultParameters: [String : Any] = SMConfiguration.defaultParameters()

        switch self {
        case .pairing(_, _):
            print("pairing")
        case .transaction(let type, let saleData, let posNotificationCallbackUrl):
            defaultParameters["TransactionMode"] = TransactionMode.ASYNC
            defaultParameters["TransactionType"] = type
            defaultParameters["SaleData"] = saleData
            defaultParameters["PosNotificationCallbackUrl"] = posNotificationCallbackUrl
        default:
            return nil
        }
        return defaultParameters
    }
    
    var sampleData: Data {
        switch self {
        case .pairing(_, _):
            return stubbedResponse("Pairing")
        case .transaction(_, _, _):
            return stubbedResponse("Transaction")
        default:
            return "None".UTF8EncodedData
        }
    }
    
    var multipartBody: [MultipartFormData]? {
        // Optional
        return nil
    }
}

// MARK: - Helpers
private extension String {
    var URLEscapedString: String {
        return self.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlHostAllowed)!
    }
    var UTF8EncodedData: Data {
        return self.data(using: String.Encoding.utf8)!
    }
}

// MARK: - Provider support
func stubbedResponse(_ filename: String) -> Data! {
    let bundle = Bundle.main
    let path = bundle.path(forResource: filename, ofType: "json")
    return (try? Data(contentsOf: URL(fileURLWithPath: path!)))
}

func url(_ route: TargetType) -> String {
    return route.baseURL.appendingPathComponent(route.path).absoluteString
}

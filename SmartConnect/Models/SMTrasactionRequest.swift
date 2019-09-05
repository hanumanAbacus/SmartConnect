//
//  SMTrasactionRequest.swift
//  SmartConnect
//
//  Created by Kheam Tan on 5/9/19.
//  Copyright © 2019 Abacus. All rights reserved.
//

import Foundation

@objc
public class SMTrasactionRequest: NSObject {
    public var amount: NSNumber? = nil
    public var amountCash: NSNumber? = nil
    public var transactionReference: NSString? = nil
    public var date: Date? = nil
    
    public func requestParameters(type: String) -> [String : Any] {
        var parameters = [String : Any]()
        switch type {
        case TransactionConstant.purchase,
             TransactionConstant.cardRefund,
             TransactionConstant.qrMerchantPurchase,
             TransactionConstant.qrRefund,
             TransactionConstant.cashAdvance:
            parameters["AmountTotal"] = amount
        case TransactionConstant.purchasePlusCash:
            parameters["AmountTotal"] = amount
            parameters["AmountCash"] = amountCash
        case TransactionConstant.authorise:
            parameters["AmountAuth"] = amount
            parameters["TransactionReference"] = transactionReference
        case TransactionConstant.finalise:
            parameters["AmountFinal"] = amount
            parameters["TransactionReference"] = transactionReference
        case TransactionConstant.settlementInquiry:
            parameters["Date"] = date
        default:
            break
            
        }
        return parameters
    }
}

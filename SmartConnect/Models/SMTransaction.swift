//
//  Transaction.swift
//  SmartConnect
//
//  Created by Kheam Tan on 5/9/19.
//  Copyright © 2019 Abacus. All rights reserved.
//

import Foundation
import Gloss

// MARK: - Transaction
public struct SMTransaction: Glossy {
    var transactionId: String!
    var transactionTimeStamp: String!
    var merchantId: String!
    var deviceId: String!
    var transactionStatus: String!
    var transactionData: SMTransactionData!
    var merchantAccessToken: String!

    //MARK: Decodable
    public init!(json: JSON){
        transactionId = "transactionId" <~~ json
        transactionTimeStamp = "transactionTimeStamp" <~~ json
        merchantId = "merchantId" <~~ json
        deviceId = "deviceId" <~~ json
        transactionStatus = "transactionStatus" <~~ json
        transactionData = "data" <~~ json
        merchantAccessToken = "merchantAccessToken" <~~ json
    }
    
    //MARK: Encodable
    public func toJSON() -> JSON? {
        return jsonify([
            "transactionId" ~~> transactionId,
            "transactionTimeStamp" ~~> transactionTimeStamp,
            "transactionStatus" ~~> transactionStatus,
            "cardPan" ~~> transactionData.cardPan,
            "accountType" ~~> transactionData.accountType,
            "receipt" ~~> transactionData.receipt,
            "amountTotal" ~~> transactionData.amountTotal
            ])
    }
}

// MARK: - DataClass
public struct SMTransactionData: Glossy {
    var posVendor: String!
    var posRegisterID: String!
    var posBusinessName: String!
    var amountTotal: String!
    var deviceID: String!
    var function: String!
    var merchant: String!
    var company: String!
    var requestId: String!
    var transactionResult: String!
    var result: String!
    var resultText: String!
    var status: String!
    var pollingUrl: String!

    // complete
    var authId: String!
    var acquirerRef: String!
    var terminalRef: String!
    var cardPan: String!
    var cardType: String!
    var accountType: String!
    var amountSurcharge: String!
    var amountTip: String!
    var timestamp: String!
    var receipt: String!
    var requestTimestamp: String!
    var responseTimestamp: String!
    
    //MARK: Decodable
    public init!(json: JSON){
        posVendor = "PosVendor" <~~ json
        status = "Status" <~~ json
        posRegisterID = "PosRegisterID" <~~ json
        posBusinessName = "PosBusinessName" <~~ json
        amountTotal = "AmountTotal" <~~ json
        deviceID = "DeviceID" <~~ json
        function = "Function" <~~ json
        merchant = "Merchant" <~~ json
        company = "Company" <~~ json
        requestId = "RequestId" <~~ json
        transactionResult = "TransactionResult" <~~ json
        result = "Result" <~~ json
        resultText = "ResultText" <~~ json
        pollingUrl = "PollingUrl" <~~ json
        
        
        authId = "AuthId" <~~ json
        acquirerRef = "AcquirerRef" <~~ json
        terminalRef = "TerminalRef" <~~ json
        cardPan = "CardPan" <~~ json
        accountType = "AccountType" <~~ json
        amountSurcharge = "AmountSurcharge" <~~ json
        cardPan = "CardPan" <~~ json
        amountTip = "AmountTip" <~~ json
        timestamp = "Timestamp" <~~ json
        receipt = "Receipt" <~~ json
        requestTimestamp = "RequestTimestamp" <~~ json
        responseTimestamp = "ResponseTimestamp" <~~ json
    }
    
    
    //MARK: Encodable
    public func toJSON() -> JSON? {
        return jsonify([
            "pollingUrl" ~~> pollingUrl,
            "result" ~~> result,
            "resultText" ~~> resultText,
            "transactionResult" ~~> transactionResult
            ])
    }
}

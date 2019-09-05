//
//  Service+Transaction.swift
//  SmartConnect
//
//  Created by Kheam Tan on 5/9/19.
//  Copyright © 2019 Abacus. All rights reserved.
//

import Foundation

extension SmartConnectService {
    static func smartPayTransaction(type: String, requestData: SMTrasactionRequest? = nil, completion: @escaping (_ result: SMResult) -> ()) {
        service.request(.transaction(type: type, requestData: requestData, saleData: nil, posNotificationCallbackUrl: nil), type: SMTransaction.self, completion: { (result, error) in
            guard let pollingUrl = result?.transactionData.pollingUrl else {
                completion(.failure(error ?? NetworkError.error(withErrorCode: .JSONMalformed)))
                return
            }
            completion(.success(result: pollingUrl))
        })
    }
    
    static func startPolling(url: String, completion: @escaping (_ result: SMResult) -> ()) {
        service.request(.polling(url: url), type: SMTransaction.self, completion: { (result, error) in
            guard let response = result else {
                completion(.failure(error ?? NetworkError.error(withErrorCode: .JSONMalformed)))
                return
            }
            completion(.success(result: response))
        })
    }
}

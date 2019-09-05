//
//  SmartConnect.swift
//  SmartConnect
//
//  Created by Hanuman on 4/9/19.
//  Copyright © 2019 Abacus. All rights reserved.
//

import Foundation

@objc
public class SmartConnect: NSObject {
    var pairingCode: String
    public var pollingInterval: TimeInterval = 5
    var pollingTimer: Timer?

    @objc
    public init(pairingCode: String) {
        self.pairingCode = pairingCode
    }
    
    @objc
    public func connect(completion: @escaping (_ errorMessage: String?) -> Void) {
        SmartConnectService.pairDevice(pairingCode: pairingCode) { (result) in
            switch result {
            case .failure(let error):
                completion(error.localizedDescription)
            case .success:
                completion(nil)
            }
        }
    }
    
    @objc
    public func terminalStatus(processing: @escaping (_ result: [String: Any]?, _ errorMessage: String?) -> Void, completion: @escaping (_ result: [String: Any]?, _ errorMessage: String?) -> Void) {
        let status = TransactionConstant.getStatus
        self.transaction(type: status, requestData: nil, processing: { (result, errorMessage) in
            processing(result, errorMessage)
        }) { (result, errorMessage) in
            completion(result, errorMessage)
        }
    }
    
    @objc
    public func startPolling(url: String, processing: @escaping (_ result: [String: Any]?, _ errorMessage: String?) -> Void, completion: @escaping (_ result: [String: Any]?, _ errorMessage: String?) -> Void) {
        stopPolling()
        
        let invocation = TimerInvocation {
            SmartConnectService.startPolling(url: url, completion: { [weak self] (result) in
                guard let weakSelf = self else { return }
                switch result {
                case .failure(let error):
                    completion(nil, error.localizedDescription)
                case .success(let result):
                    guard let result = result as? SMTransaction, let status = result.transactionStatus else {
                        completion(nil, NetworkError.error(withErrorCode: .JSONMalformed).localizedDescription)
                        return
                    }
                    if (status == "COMPLETED") {
                        completion(result.toJSON(), nil)
                        weakSelf.stopPolling()
                    } else {
                        processing(result.toJSON(), nil)
                    }
                }
            })
        }
        self.pollingTimer = Timer.scheduledTimer(timeInterval: pollingInterval, target: invocation, selector:#selector(TimerInvocation.invoke), userInfo: nil, repeats: true)
    }
    
    @objc
    public func stopPolling() {
        self.pollingTimer?.invalidate()
        self.pollingTimer = nil
    }
    
    @objc
    public func transaction(type: String, requestData: SMTrasactionRequest?, processing: @escaping (_ result: [String: Any]?, _ errorMessage: String?) -> Void,  completion: @escaping (_ result: [String: Any]?, _ errorMessage: String?) -> Void) {
        SmartConnectService.smartPayTransaction(type: type, requestData: requestData) { [weak self] (result) in
            guard let weakSelf = self else { return }
            switch result {
            case .failure(let error):
                completion(nil, error.localizedDescription)
            case .success(let result):
                guard let pollingURL = result as? String else {
                    completion(nil, NetworkError.error(withErrorCode: .JSONMalformed).localizedDescription)
                    return
                }
                weakSelf.startPolling(url: pollingURL, processing: processing, completion: completion)
            }
        }
    }

}

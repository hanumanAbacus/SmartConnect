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
}

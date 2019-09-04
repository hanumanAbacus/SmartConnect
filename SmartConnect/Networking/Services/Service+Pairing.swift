//
//  Service+Sync.swift
//  AbacusSync
//
//  Created by Hanuman on 29/5/19.
//  Copyright © 2019 Hanuman. All rights reserved.
//

import Foundation

extension SmartConnectService {
    static func pairDevice(pairingCode: String, completion: @escaping (_ result: VoidResult) -> ()) {
        service.request(.pairing(pairingCode: pairingCode, address: nil), type: SMCommonResponse.self, completion: { (result, error) in
            guard let response = result else {
                completion(.failure(error ?? NetworkError.error(withErrorCode: .JSONMalformed)))
                return
            }
            completion(.success)
        })
    }
}

//
//  NetworkError.swift
//  AbacusSync
//
//  Created by Hanuman on 28/5/19.
//  Copyright © 2019 Hanuman. All rights reserved.
//

import Foundation
import Gloss

class NetworkError: Error {
    fileprivate static let domain = "com.abacus.error.network"
    static func error(withErrorCode errorCode: ErrorCode) -> Error {
        return NSError(domain: NetworkError.domain, code: errorCode.rawValue, userInfo: [NSLocalizedDescriptionKey: errorCode.contextString()])
    }
    
    // MARK: Declaration for string constants to be used to decode and also serialize.
    private struct SerializationKeys {
        static let error = "error"
    }
    
    static func error(json: [String: Any]) -> Error {
        let errorCode: ErrorCode = .Generic
        
        guard let errorMessage = json.valueForKeyPath(keyPath: SerializationKeys.error) as? String else {
            return NSError(domain: NetworkError.domain, code: errorCode.rawValue, userInfo: [NSLocalizedDescriptionKey: errorCode.contextString()])
        }

        return NSError(domain: NetworkError.domain, code: errorCode.rawValue, userInfo: [NSLocalizedDescriptionKey: errorMessage])
    }
}

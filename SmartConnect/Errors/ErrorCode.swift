//
//  ErrorCode.swift
//  AbacusSync
//
//  Created by Hanuman on 28/5/19.
//  Copyright © 2019 Hanuman. All rights reserved.
//

import Foundation

enum ErrorCode: Int {
    case Generic = 0
    
    // Login Error
    case EmptyFields = -1
    case InvalidCredential = -2
    case NoPinResetUser = -3
    case InactiveUser = -4
    
    // Generic Error
    case RequiredFieldMissing = -20
    
    // Network Error
    case JSONMalformed = -200
    case Forbidden = -201
    case ServerError = -202
    
    // Database Error
    case JSONEmpty = -300
    case CreateModelFailed = -301
    case SavingFailed = -302
    
    func contextString () -> String {
        switch self {
        case .EmptyFields:
            return NSLocalizedString("Username and/or password cannot be empty", comment: "Empty credential")
        case .InvalidCredential:
            return NSLocalizedString("Username and/or password is Invalid", comment: "Credential is invalid")
        case .NoPinResetUser:
            return NSLocalizedString("Please try logging again", comment: "Please try logging again")
        case .RequiredFieldMissing:
            return NSLocalizedString("Required field missing.", comment: "required field is missing")
        case .InactiveUser:
            return NSLocalizedString("User is inactive or deleted.", comment: "inactive or deleted")
            
            // network Error
        case .JSONMalformed:
            return NSLocalizedString("JSON is malformed", comment: "Json is malformed and cannot be processed")
        case .Forbidden:
            return NSLocalizedString("Authentication Error", comment: "Unable to Authenticate, please try again later.")
        case .ServerError:
            return NSLocalizedString("Something went wrong.\n Please try again", comment: "server error just let them retry")
            // Database error
        case .JSONEmpty:
            return NSLocalizedString("JSON is empty", comment: "Json string received is empty")
        case .CreateModelFailed:
            return NSLocalizedString("Please try again", comment: "Please try again")
        case .SavingFailed:
            return NSLocalizedString("Something went wrong.\nPlease try again", comment: "Encountered an error in saving the object")
        default:
            return NSLocalizedString("Unknown Error", comment: "Unknown error")
        }
    }
}

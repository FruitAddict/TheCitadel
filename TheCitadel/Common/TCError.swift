//
//  TCError.swift
//  TheCitadel
//
//  Created by Mateusz Popiało on 06/12/2018.
//  Copyright © 2018 Mateusz Popiało. All rights reserved.
//

import Foundation

extension Error {
    var code: Int { return (self as NSError).code }
    var domain: String { return (self as NSError).domain }
}

enum TCError : Error {
    case invalidJSONData
    case emptyJSON
    case operationNotSupported
    case noResults
}

extension TCError: LocalizedError {
    
    public var errorDescription: String? {
        switch self {
            
        case .invalidJSONData:
            return NSLocalizedString("errorInvalidJSON", comment: "")
            
        case .emptyJSON:
            return NSLocalizedString("errorNoData", comment: "")
            
        case .operationNotSupported:
            return NSLocalizedString("errorOpNotSupported", comment: "")
            
        case .noResults:
            return NSLocalizedString("errorNoData", comment: "")
        }
    }
    
}

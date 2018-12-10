//
//  Optional + Extensions.swift
//  TheCitadel
//
//  Created by Mateusz Popiało on 06/12/2018.
//  Copyright © 2018 Mateusz Popiało. All rights reserved.
//

import Foundation

extension Optional where Wrapped == String {
    
    var orEmpty : String {
        if case .some(let value) = self {
            return value
        } else {
            return ""
        }
    }
    
}

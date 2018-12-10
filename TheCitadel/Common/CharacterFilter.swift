//
//  CharacterFilter.swift
//  TheCitadel
//
//  Created by Mateusz Popiało on 05/12/2018.
//  Copyright © 2018 Mateusz Popiało. All rights reserved.
//

import Foundation

enum CharacterFilter {
    case all
    case alive
    case dead
    
    var descriptor : String {
        switch self {
        case .alive:
            return "alive".localized
            
        case .dead:
            return "dead".localized
            
        case .all:
            return "all".localized
        }
    }
}

//
//  Collection + Extensions.swift
//  TheCitadel
//
//  Created by Mateusz Popiało on 07/12/2018.
//  Copyright © 2018 Mateusz Popiało. All rights reserved.
//

import Foundation

extension Collection {
    
    subscript (safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}

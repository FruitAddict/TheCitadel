//
//  String + Localizable.swift
//  TheCitadel
//
//  Created by Mateusz Popiało on 08/12/2018.
//  Copyright © 2018 Mateusz Popiało. All rights reserved.
//

import Foundation

extension String {
    
    var localized : String {
        return NSLocalizedString(self, comment: "")
    }
    
}

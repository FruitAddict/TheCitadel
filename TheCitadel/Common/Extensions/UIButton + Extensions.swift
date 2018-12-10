//
//  UIButton + Extensions.swift
//  TheCitadel
//
//  Created by Mateusz Popiało on 08/12/2018.
//  Copyright © 2018 Mateusz Popiało. All rights reserved.
//

import UIKit

extension UIButton {

    func applyBorderedStyle() {
        layer.cornerRadius = 4
        layer.borderColor = UIColor.appColor.cgColor
        layer.borderWidth = 1
    }
    
}


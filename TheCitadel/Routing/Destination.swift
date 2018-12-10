//
//  Destination.swift
//  TheCitadel
//
//  Created by Mateusz Popiało on 08/12/2018.
//  Copyright © 2018 Mateusz Popiało. All rights reserved.
//

import UIKit

enum PresentationMode {
    case push, present
}

protocol Destination {
    
    func create(with router: Router) -> UIViewController
    
    var presentationMode : PresentationMode { get }
    
    var identifier : String { get } //For logging 
    
}

//
//  Router.swift
//  TheCitadel
//
//  Created by Mateusz Popiało on 06/12/2018.
//  Copyright © 2018 Mateusz Popiało. All rights reserved.
//

import UIKit

protocol Router : class {
    
    init(base: TheCitadelNavigationController)
    
    func transition(to destination: Destination)
    
    func open(url: URL)
    
}

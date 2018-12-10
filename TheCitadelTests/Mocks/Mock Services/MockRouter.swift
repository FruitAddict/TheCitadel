//
//  MockRouter.swift
//  TheCitadelTests
//
//  Created by Mateusz Popiało on 09/12/2018.
//  Copyright © 2018 Mateusz Popiało. All rights reserved.
//

import Foundation

@testable import TheCitadel

class MockRouter: Router {
    
    var openedURL : Bool = false
    
    var lastReqDestinationIdentifier : String = ""
    
    required init(base: TheCitadelNavigationController) {
        
    }
    
    func transition(to destination: Destination) {
        let identifier = destination.identifier
        lastReqDestinationIdentifier = identifier
    }
    
    func open(url: URL) {
        openedURL = true
    }
}

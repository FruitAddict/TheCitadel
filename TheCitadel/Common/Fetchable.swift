//
//  Fetchable.swift
//  TheCitadel
//
//  Created by Mateusz Popiało on 07/12/2018.
//  Copyright © 2018 Mateusz Popiało. All rights reserved.
//

import Foundation

typealias ResourceID = Int

enum Fetchable<T> {
    case notFetchedYet(ResourceID)
    case fetched(T)
    
    init?(from url: String) {
        let components = url.components(separatedBy: "/")
        
        guard
            let lastComponent = components.last,
            let id = Int(lastComponent)
        else {
            return nil
        }
        self = .notFetchedYet(id)
    }
}

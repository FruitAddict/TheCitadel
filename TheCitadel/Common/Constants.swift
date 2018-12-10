//
//  Constants.swift
//  TheCitadel
//
//  Created by Mateusz Popiało on 06/12/2018.
//  Copyright © 2018 Mateusz Popiało. All rights reserved.
//

import Foundation

/// Enums are used here just for namespacing
enum Constants {
    
    enum API {
        static let baseAddress = "https://anapioficeandfire.com/api"
        
        enum Characters {
            static let firstPageIndex : Int = 1
            static let itemsPerPage : Int = 20
        }
    
    }
    
    enum Books {
        static let booksBatchSize : Int = 10
    }
    
    enum ErrorDescription {
        static let cancelled = "cancelled"
    }
    
    enum URLs {
        static let networkSettings = "App-Prefs:root=WIFI"
    }
    
    enum DestinationIdentifiers {
        static let characterList = "allChars"
        static let bookCharacterList = "bookChars"
        static let characterDetails = "charDetails"
        static let bookList = "allBooks"
        static let errorScreen = "errorScreen"
        static let aboutApp = "aboutApp"
    }
    
}

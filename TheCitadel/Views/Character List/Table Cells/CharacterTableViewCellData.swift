//
//  CharacterTableViewCellData.swift
//  TheCitadel
//
//  Created by Mateusz Popiało on 08/12/2018.
//  Copyright © 2018 Mateusz Popiało. All rights reserved.
//

import Foundation

//MARK: - View model
struct CharacterTableViewCellData {
    
    var mainDsc : String
    var isAlive : Bool
    var miscDsc : String
    
    init(with character : Character) {
        mainDsc = character.getMainDescriptor()
        miscDsc = character.getMiscDescriptor()
        isAlive = character.died.orEmpty.isEmpty
    }
}

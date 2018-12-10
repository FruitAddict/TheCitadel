//
//  FetchCharactersService.swift
//  TheCitadel
//
//  Created by Mateusz Popiało on 05/12/2018.
//  Copyright © 2018 Mateusz Popiało. All rights reserved.
//

import Foundation

typealias FetchCharactersServiceCompletion = (Result<[Character]>) -> Void

typealias FetchCharacterServiceCompletion = (Result<Character>) -> Void

struct CharacterQuery {
    var filter : CharacterFilter
    var page : Int
    var pageLimit : Int
}

protocol FetchCharactersService {
    
    func fetchCharacters(using query: CharacterQuery, completion: @escaping FetchCharactersServiceCompletion)
    
    func fetchCharacter(with id: Int, completion: @escaping FetchCharacterServiceCompletion)
    
}

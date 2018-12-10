//
//  MockCharacterService.swift
//  TheCitadelTests
//
//  Created by Mateusz Popiało on 09/12/2018.
//  Copyright © 2018 Mateusz Popiało. All rights reserved.
//

import Foundation

@testable import TheCitadel

class MockCharacterService : FetchCharactersService {
    
    lazy var mockCharacters : [TheCitadel.Character] = {
        
        return (0..<50).map {
            int in
            let char = TheCitadel.Character()
            
            char.name = "Random Char No. #\(int)"
            char.aliases = ["Alias identifier No. #\(100-int)"]
            char.born = "Born at: \(String(describing: Date()))"
            
            return char
        }
        
    }()
    
    var autoCharacterRSP : Bool = false
    var characterCallCount : Int = 0
    
    var charactersApiCall : (query: CharacterQuery, completion: FetchCharactersServiceCompletion)?
    var characterApiCall : (id: Int, completion: FetchCharacterServiceCompletion)?
    
    func fetchCharacters(using query: CharacterQuery, completion: @escaping FetchCharactersServiceCompletion) {
        self.charactersApiCall = (query: query, completion: completion)
    }
    
    func fetchCharacter(with id: Int, completion: @escaping FetchCharacterServiceCompletion) {
        characterCallCount += 1
        if autoCharacterRSP {
            let char = Character()
            char.name = "No #\(id)"
            completion(.success(char))
        } else {
            self.characterApiCall = (id: id, completion: completion)
        }
    }
    
    //MARK: - Mockrsps
    func sendMockCharacterOKResponse(using character: TheCitadel.Character) {
        characterApiCall?.completion(.success(character))
    }
    
    func sendMockCharacterErrorResponse() {
        characterApiCall?.completion(.error(TCError.invalidJSONData))
    }
    
    func sendMockCharactersOKResponse() {
        let query = charactersApiCall!.query
        
        if query.filter == .dead  || query.filter == .alive { //if any filters are selected return first 5 characters just to assert the behavior of SUT.
            
            let subset = Array(mockCharacters[0..<5])
            charactersApiCall?.completion(.success(subset))
            
            return
        }
        
        let adjutedPageForMock = query.page - 1
        
        let pageStart = adjutedPageForMock * query.pageLimit
        var pageEnd = pageStart + query.pageLimit
        
        if pageEnd >= mockCharacters.count {
            pageEnd = mockCharacters.count
        }
        
        let subset = Array(mockCharacters[pageStart..<pageEnd])
        charactersApiCall?.completion(.success(subset))
    }
    
    func sendMockCharactersErrorResponse() {
        charactersApiCall?.completion(.error(TCError.invalidJSONData))
    }
}

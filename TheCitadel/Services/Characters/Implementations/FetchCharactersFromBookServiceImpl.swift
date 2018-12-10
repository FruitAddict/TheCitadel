//
//  FetchCharactersFromBookService.swift
//  TheCitadel
//
//  Created by Mateusz Popiało on 05/12/2018.
//  Copyright © 2018 Mateusz Popiało. All rights reserved.
//

import Foundation

//MARK: - Dependencies
struct FetchCharactersFromBookServiceDependencies {
    var book : Book
}

//MARK: - Implementation
final class FetchCharactersFromBookServiceImpl : FetchCharactersService {

    var book: Book
    var apiLookupService : FetchCharactersService
    
    init(with book: Book, lookupService : FetchCharactersService) {
        self.book = book
        self.apiLookupService = lookupService
    }
    
    func fetchCharacters(using query: CharacterQuery, completion: @escaping FetchCharactersServiceCompletion) {
    
        let group = DispatchGroup()
        var apiErroredOutDuringLookup = false
        
        let pageStart = query.page * query.pageLimit
        var pageEnd = pageStart + query.pageLimit
        
        if pageStart >= book.characters.count || (query.page < 0 || query.pageLimit < 0) {
            completion(.success([]))
            return
        }
        
        if pageEnd >= book.characters.count {
            pageEnd = book.characters.count
        }
        
        for i in pageStart..<pageEnd {
            guard
                let character = book.characters[safe: i]
            else {
                break
            }
            
            if case .notFetchedYet(let id) = character {
                group.enter()
                
                apiLookupService.fetchCharacter(with: id) {
                    result in
                    
                    switch result {
                    case .success(let character):
                        self.book.characters[i] = .fetched(character)
                        
                    case .error(_):
                        apiErroredOutDuringLookup = true
                    }
                    group.leave()
                }
            }
        }
        
        group.notify(queue: .main) {
            
            switch apiErroredOutDuringLookup {
            case true:
                completion(.error(TCError.noResults))
                
            case false:
                let characters = self.book.characters[pageStart..<pageEnd].compactMap({
                    fetchable -> Character? in
                    if case .fetched(let char) = fetchable {
                        return char
                    } else {
                        return nil
                    }
                })
                completion(.success(characters))
                
            }
        }
    }
    
    func fetchCharacter(with id: Int, completion: @escaping FetchCharacterServiceCompletion) {
   
        let filtered = book.characters.filter({
            character in
            
            switch character {
            case .fetched(let char):
                if
                    let charID = char.url.orEmpty.components(separatedBy: "/").last,
                    let intCharID = Int(charID),
                    intCharID == id {
                    return true
                } else {
                    return false
                }
                
            case .notFetchedYet(_):
                return false
            }
        }).first
        
        if case .fetched(let char)? = filtered {
            completion(.success(char))
        } else {
            completion(.error(TCError.noResults))
        }
    
    }
    
}

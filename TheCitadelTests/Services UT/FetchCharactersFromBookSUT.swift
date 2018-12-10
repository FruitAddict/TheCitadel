//
//  FetchCharactersFromBookSUT.swift
//  TheCitadelTests
//
//  Created by Mateusz Popiało on 09/12/2018.
//  Copyright © 2018 Mateusz Popiało. All rights reserved.
//

import UIKit

import Nimble
import Quick

@testable import TheCitadel

//MARK: - Tests
class FetchCharactersFromBookSUT: QuickSpec {
    
    func createMockBook() -> Book {
        let book = Book()
        
        book.name = "Mock"
        book.authors = ["John Smith"]
        book.numberOfPages = 1000
        book.characters = (0..<100).map {
            int in
            return Fetchable<TheCitadel.Character>.notFetchedYet(int)
        }
        
        return book
    }
    
    func createPartiallyFilledMockBook() -> Book {
        let book = Book()
        
        book.name = "Mock"
        book.authors = ["John Smith"]
        book.numberOfPages = 1000
        book.characters = (0..<100).map {
            int in
            return Fetchable<TheCitadel.Character>.notFetchedYet(int)
        }
        
        book.characters[3] = .fetched(Character())
        book.characters[4] = .fetched(Character())
        
        return book
    }
    
    
    override func spec() {
        //MARK: - Test subject
        var serviceUT : FetchCharactersFromBookServiceImpl!
        
        //MARK: - Injectable mock services
        var apiLookupService : MockCharacterService!
        
        var mockBook: Book!
        
        beforeEach {
            mockBook = self.createMockBook()
            
            apiLookupService = MockCharacterService()
    
            serviceUT = FetchCharactersFromBookServiceImpl(with: mockBook, lookupService: apiLookupService)
            
        }
        
        describe("the service treats the book as it's data source") {
            
            it("Can fetch the first 10 characters from the book (separately, api limitation)") {
            
                apiLookupService.autoCharacterRSP = true
                
                let query = CharacterQuery(filter: .all, page: 0, pageLimit: 10)
                
                var characters : [TheCitadel.Character] = []
                
                serviceUT.fetchCharacters(using: query) {
                    result in
                    
                    switch result {
                    case .success(let chars):
                        characters = chars
                        
                    case .error(_):
                        fail("This shouldn't happen. Check the SUT.")
                    }
                }
                
                expect(characters.count).toEventually(be(10))
                
                expect(apiLookupService.characterCallCount).toEventually(be(10))
                
            }
            
            it("Skips the already fetched characters") {
                
                apiLookupService.autoCharacterRSP = true
                
                serviceUT.book = self.createPartiallyFilledMockBook()
                
                let query = CharacterQuery(filter: .all, page: 0, pageLimit: 10)
                
                var characters : [TheCitadel.Character] = []
                
                serviceUT.fetchCharacters(using: query) {
                    result in
                    
                    switch result {
                    case .success(let chars):
                        characters = chars
                        
                    case .error(_):
                        fail("This shouldn't happen. Check the SUT.")
                    }
                }
                
                expect(characters.count).toEventually(be(10))
                
                expect(apiLookupService.characterCallCount).toEventually(be(8))
            }
            
            it("Handles array bounds correctly") {
                apiLookupService.autoCharacterRSP = true
                
                let query = CharacterQuery(filter: .all, page: 10, pageLimit: 10)
                
                var characters : [TheCitadel.Character]?
                
                serviceUT.fetchCharacters(using: query) {
                    result in
                    
                    switch result {
                    case .success(let chars):
                        characters = chars
                        
                    case .error(_):
                        fail("This shouldn't happen. Check the SUT.")
                    }
                }
                
                expect(characters?.count).toEventually(be(0))
                
                var malformedResult : [TheCitadel.Character]?
                
                let malformedQuery = CharacterQuery(filter: .all, page: -1, pageLimit: -43)

                serviceUT.fetchCharacters(using: malformedQuery) {
                    result in
                    
                    switch result {
                    case .success(let chars):
                        malformedResult = chars
                        
                    case .error(_):
                        fail("This shouldn't happen. Check the SUT.")
                    }
                }
                
                expect(malformedResult?.count).toEventually(be(0))
                
            }
            
            it("Behaves correctly when count of characters in book is less than 1 page") {
                apiLookupService.autoCharacterRSP = true

                let newBook = Book()
                newBook.characters = [.notFetchedYet(1)]
                
                serviceUT.book = newBook
                
                var characters : [TheCitadel.Character] = []

                let query = CharacterQuery(filter: .all, page: 0, pageLimit: 10)
                
                serviceUT.fetchCharacters(using: query) {
                    result in
                    
                    switch result {
                    case .success(let chars):
                        characters = chars
                        
                    case .error(_):
                        fail("This shouldn't happen. Check the SUT.")
                    }
                }
                
                expect(characters.count).toEventually(be(1))
                
            }
        }
    }
}

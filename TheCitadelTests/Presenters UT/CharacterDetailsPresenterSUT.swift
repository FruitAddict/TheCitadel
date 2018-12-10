//
//  CharacterDetailsPresenterSUT.swift
//  TheCitadelTests
//
//  Created by Mateusz Popiało on 09/12/2018.
//  Copyright © 2018 Mateusz Popiało. All rights reserved.
//

import Foundation


import Nimble
import Quick

@testable import TheCitadel


//MARK: - Tests
class CharacterDetailsPresenterSUT: QuickSpec {
    
    private func createMockCharacter() -> TheCitadel.Character {
        let char = TheCitadel.Character()
        
        char.name = "Mock Man"
        
        char.spouse = .notFetchedYet(1)
        
        char.books = [.notFetchedYet(1), .notFetchedYet(2)]
        
        return char
    }
    
    override func spec() {
        //MARK: - Test subject
        var presenterUT : CharacterDetailsPresenterImpl!
        
        //MARK: - Injectable mock services
        var mockView : MockCharacterDetailsView!
        
        var mockCharacterService: MockCharacterService!
        
        var mockBookService: MockBookService!
        
        var mockRouter : MockRouter!
        
        beforeEach {
            
            mockCharacterService = MockCharacterService()
            
            mockBookService = MockBookService()
            
            mockRouter = MockRouter(base: TheCitadelNavigationController())
            
            let mockDependencies = CharacterDetailsPresenterImpl.Dependencies(
                router : mockRouter,
                character : self.createMockCharacter(),
                characterService : mockCharacterService,
                booksService : mockBookService
            )
            
            presenterUT = CharacterDetailsPresenterImpl(with: mockDependencies)
            
            mockView = MockCharacterDetailsView(with: presenterUT)
        }
        
        
        describe("the presenter") {
            
            it("initialized the view with config after it attached itself") {
                expect(mockView.title).toNot(beEmpty())
            }
            
            it("Passed the character to the view") {
                expect(mockView.currentCharacter).toNot(beNil())
            }
            
            context("checks the dependencies (books or characters) and updates the view") {
                
                it("Should call for the unfetched books and spouse character") {
                    mockBookService.autoRSP = true
                    
                    expect(mockCharacterService.characterApiCall).toNot(beNil())
                    
                    let spouse = Character()
                    spouse.name = "Lovely spouse of the Mock Man"
                    
                    mockCharacterService.sendMockCharacterOKResponse(using: spouse)
                                        
                    expect(mockView.currentCharacter.spouse).toNot(beNil())
                    
                    if case .fetched(let char)? = mockView.currentCharacter.spouse {
                        expect(char).to(be(spouse))
                    } else {
                        fail("Spouse wasn't assigned the the original character as expected")
                    }
                    
                    if case .notFetchedYet(_)? = mockView.currentCharacter.books?.first {
                        fail("Books should be there by now too")
                    }
                }
                
            }
            
            context("should handle errors gracefully") {
                
                it("routes to the error view when something goes wrong") {
                    let spouse = Character()
                    spouse.name = "Lovely spouse of the Mock Man"
                    
                    mockCharacterService.sendMockCharacterErrorResponse()
                    
                    expect(mockRouter.lastReqDestinationIdentifier).to(equal(Constants.DestinationIdentifiers.errorScreen))
                }
                
            }
            
            context("should handle routing correctly") {
                
                it("Should route to char details when user taps on a character") {
                    let spouse = Character()
                    spouse.name = "Lovely spouse of the Mock Man"
                    
                    mockCharacterService.sendMockCharacterOKResponse(using: spouse)
                    
                    mockView.selectCharacter(character: spouse)
                    
                    expect(mockRouter.lastReqDestinationIdentifier).to(equal(Constants.DestinationIdentifiers.characterDetails))
                }
                
                it("Shouldn't route anywhere when user taps on a book with no characters") {
                    let book = Book()
                    
                    mockView.selectBook(book: book)
                    
                    expect(mockRouter.lastReqDestinationIdentifier).to(equal(""))
                }
                
                it("Should route to books character list if it has atleast 1 character in it") {
                    let book = Book()
                    
                    book.characters = [.notFetchedYet(1)]
                    
                    mockView.selectBook(book: book)
                    
                    expect(mockRouter.lastReqDestinationIdentifier).to(equal(Constants.DestinationIdentifiers.bookCharacterList))
                }
            }
            
        }
    }
}

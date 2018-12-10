//
//  AllCharacterListSpecs.swift
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
class AllCharacterListPresenterSUT: QuickSpec {
    
    override func spec() {
        //MARK: - Test subject
        var presenterUT : AllCharacterListPresenterImpl!
        
        //MARK: - Injectable mock services
        var mockView : MockCharacterListView!
        
        var mockCharacterService: MockCharacterService!
        
        var mockRouter : MockRouter!
        
        beforeEach {
            
            mockCharacterService = MockCharacterService()
            
            mockRouter = MockRouter(base: TheCitadelNavigationController())
            
            let mockDependencies = AllCharacterListPresenterImpl.Dependencies(
                characterService: mockCharacterService,
                router: mockRouter
            )
            
            presenterUT = AllCharacterListPresenterImpl(with: mockDependencies)
            
            mockView = MockCharacterListView(with: presenterUT)
        }
        
        describe("the presenter") {
            
            it("initialized the view with config after it attached itself") {
                expect(mockView.title).toNot(beEmpty())
                
                expect(mockView.filters.count).to(be(3))
            }
            
            context("fetches characters and passes them to the view") {
                
                beforeEach {
                    presenterUT.fetchCharacters()
                }
                
                it("should call view to display an activity indicator when fetchCharacters is called") {
                    expect(mockView.isCentralIndicatorVisible).to(beTrue())
                }
                
                it("Should have the first 20 characters (unfiltered) ") {
                    expect(mockView.isCentralIndicatorVisible).to(beTrue())

                    mockCharacterService.sendMockCharactersOKResponse()
                    
                    expect(presenterUT.characters.count).to(be(20))
                    
                    expect(mockView.isCentralIndicatorVisible).to(beFalse())
                    
                    expect(mockView.characters.count).to(be(20))
                }
            }
            
            context("resolves filtering and search term changes by updating the view") {
                
                beforeEach {
                    presenterUT.fetchCharacters()
                    
                    mockCharacterService.sendMockCharactersOKResponse()
                }
                
                it("should initially pass 20 characters to the view") {
                    expect(presenterUT.characters.count).to(be(20))
                    
                    expect(mockView.characters.count).to(be(20))
                }
                
                it("should pass only 1 character to the view when filtered to '9'") {
                    mockView.changeSearchTerm(to: "11")
                    
                    expect(presenterUT.characters.count).to(be(1))
                    
                    expect(mockView.isCentralIndicatorVisible).to(beFalse())
                }
                
                it("should pass only 1 character to the view when filtered to '90' (searches through aliases)") {
                    print("begin")
                    mockView.changeSearchTerm(to: "90")
                    
                    print(mockView.characters.map{$0.getMainDescriptor()})
                    
                    expect(presenterUT.characters.count).to(be(1))
                    
                    expect(mockView.isCentralIndicatorVisible).to(beFalse())
                }
                
                it("handle filtering") {
                    mockView.changeFilter(to: .dead)
                    
                    expect(mockView.isCentralIndicatorVisible).to(beTrue())
                    
                    mockCharacterService.sendMockCharactersOKResponse()
                    
                    expect(mockView.isCentralIndicatorVisible).to(beFalse())
                    
                    expect(presenterUT.characters.count).to(be(5)) //mock service returns first 5 chars if any filter was passed to it
                }
            }
            
            context("loads more characters when view requests it") {
                
                beforeEach {
                    presenterUT.fetchCharacters()
                    mockCharacterService.sendMockCharactersOKResponse()
                }
                
                it("begins with 20 characters and loads the next 20") {
                    expect(presenterUT.characters.count).to(be(20))
                    
                    mockView.loadMore() //user scrolls to the bottom of the list
                    
                    expect(mockView.isBottomIndicatorVisible).to(beTrue())
                    
                    mockCharacterService.sendMockCharactersOKResponse()
                    
                    expect(mockView.isBottomIndicatorVisible).to(beFalse())
                    
                    expect(presenterUT.characters.count).to(be(40))
                    
                    expect(presenterUT.shouldTryToFetchMoreCharacters()).to(beTrue())
                }
                
                
                it("After loading the second page, service reaches the character limit and should block any further load requests") {
                    mockView.loadMore()
                    
                    mockCharacterService.sendMockCharactersOKResponse()

                    expect(presenterUT.characters.count).to(be(40))
                    
                    expect(presenterUT.shouldTryToFetchMoreCharacters()).to(beTrue())
                    
                    mockView.loadMore()
                    
                    mockCharacterService.sendMockCharactersOKResponse()

                    expect(presenterUT.characters.count).to(be(50))
                    
                    expect(presenterUT.shouldTryToFetchMoreCharacters()).to(beFalse())


                }
            }
            
            context("Handles routing when view requests something that requires screen changes") {
                
                beforeEach {
                    presenterUT.fetchCharacters()
                    mockCharacterService.sendMockCharactersOKResponse()
                }
                
                it("Routes to character details") {
                    expect(mockView.characters.count).to(beGreaterThan(0))
                    
                    mockView.select(character: mockView.characters[0])
                    
                    expect(mockRouter.lastReqDestinationIdentifier).to(equal(Constants.DestinationIdentifiers.characterDetails))
                }
                
                it("Routes to error screen when service errors out") {
                    mockView.loadMore()
                    
                    mockCharacterService.sendMockCharactersErrorResponse()
                    
                    expect(mockRouter.lastReqDestinationIdentifier).to(equal(Constants.DestinationIdentifiers.errorScreen))
                    
                    presenterUT.onRetryPressed() //delegate method called - try again button from the error screen
                    
                    expect(mockView.isCentralIndicatorVisible).to(beTrue())
                    
                    mockCharacterService.sendMockCharactersOKResponse()
                    
                    expect(mockView.isCentralIndicatorVisible).to(beFalse())

                    expect(presenterUT.characters.count).to(be(20))

                }
                
            }
         
        }
    }

}

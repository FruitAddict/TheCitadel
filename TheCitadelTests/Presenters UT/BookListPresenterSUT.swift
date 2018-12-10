//
//  BookListPresenterSUT.swift
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
class BookListPresenterSUT: QuickSpec {
    
    override func spec() {
        //MARK: - Test subject
        var presenterUT : BookListPresenterImpl!
        
        //MARK: - Injectable mock services
        var mockView : MockBookView!
        
        var mockBookService: MockBookService!
        
        var mockRouter : MockRouter!
        
        beforeEach {
            
            mockBookService = MockBookService()
            
            mockBookService.autoRSP = false
            
            mockRouter = MockRouter(base: TheCitadelNavigationController())
            
            let mockDependencies = BookListPresenterImpl.Dependencies(
                router: mockRouter,
                bookService: mockBookService
            )
            
            presenterUT = BookListPresenterImpl(with: mockDependencies)
            
            mockView = MockBookView(with: presenterUT)
        }
        
        describe("the presenter") {
            
            it("initialized the view with config after it attached itself") {
                expect(mockView.title).toNot(beEmpty())
            }
            
            context("fetches characters and passes them to the view") {
                
                beforeEach {
                    presenterUT.fetchAllBooks()
                }
                
                it("should tell the view to display the activity indicator") {
                    expect(mockView.isCentralIndicatorVisible).to(beTrue())
                }
                
                it("should refresh the view after fetching the books") {
                    mockBookService.sendBooksAPIRspOK()
                    
                    expect(mockView.isCentralIndicatorVisible).to(beFalse())
                    
                    expect(mockView.books.count).to(be(12))
                }
            
            }
            
            context("should handle routing") {
                it("routes to details if the book has any characters") {
                    presenterUT.fetchAllBooks()

                    mockBookService.sendBooksAPIRspOK()
                    
                    let book = mockView.books.first!
                    
                    book.characters = [.notFetchedYet(1)]

                    mockView.selectBook(book: mockView.books.first!)
                    
                    expect(mockRouter.lastReqDestinationIdentifier).to(equal(Constants.DestinationIdentifiers.bookCharacterList))

                }
                
                it("routes to error screen if something goes wrong") {
                    
                    mockBookService.autoRSP = false
                    
                    presenterUT.fetchAllBooks()
                    
                    mockBookService.sendBooksAPIRspError()
                expect(mockRouter.lastReqDestinationIdentifier).to(equal(Constants.DestinationIdentifiers.errorScreen))
                    
                    presenterUT.onRetryPressed() //delegate method called - try again button from error screen
                    
                    expect(mockView.isCentralIndicatorVisible).to(beTrue())
                    
                    mockBookService.sendBooksAPIRspOK()
                    
                    expect(mockView.isCentralIndicatorVisible).to(beFalse())
                    
                    expect(mockView.books.count).to(be(12))
                }
            }
            
                
        }
    }
}


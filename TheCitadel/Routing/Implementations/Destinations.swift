//
//  Destinations.swift
//  TheCitadel
//
//  Created by Mateusz Popiało on 06/12/2018.
//  Copyright © 2018 Mateusz Popiało. All rights reserved.
//

import UIKit

enum Destinations : Destination {
    
    case charactersForBook(Book)
    case characterDetails(Character)
    case allCharacters
    case allBooks
    case noConnection(customErrorString: String, delegate: NoConnectionPresenterDelegate)
    case aboutApp
    
    var identifier : String {
   
        switch self {
        case .allCharacters:
            return Constants.DestinationIdentifiers.characterList
            
        case .characterDetails(_):
            return Constants.DestinationIdentifiers.characterDetails
            
        case .charactersForBook(_):
            return Constants.DestinationIdentifiers.bookCharacterList
            
        case .allBooks:
            return Constants.DestinationIdentifiers.bookList
            
        case .noConnection(_):
            return Constants.DestinationIdentifiers.errorScreen
            
        case .aboutApp:
            return Constants.DestinationIdentifiers.aboutApp
        }
    }
    
    var presentationMode: PresentationMode {
        switch self {
        case .noConnection(_):
            return .present
            
        default:
            return .push
            
        }
    }
    
    func create(with router: Router) -> UIViewController {
        switch self {
        case .allCharacters:
            return createCharacterListVC(with: router)
            
        case .characterDetails(let character):
            return createCharacterDetailsVC(with: router, character: character)
            
        case .charactersForBook(let book):
            return createBookCharacterListVC(with: router, book: book)
            
        case .allBooks:
            return createBookListVC(with: router)
            
        case .noConnection(let errorString, let delegate):
            return createNoConnectionVC(with: router, errorString: errorString, delegate: delegate)
            
        case .aboutApp:
            return createAboutAppVC(with: router)
        }
    }
}

//MARK: - DI on Presenters and vc creation, could be in factories for more abstraction
extension Destination {
    
    fileprivate func createCharacterListVC(with router: Router) -> UIViewController {
        let service = FetchCharactersFromAPIServiceImpl()
        
        let presenter = AllCharacterListPresenterImpl(with:
            AllCharacterListPresenterImpl.Dependencies(
                characterService: service,
                router: router
            )
        )
        
        return CharacterListViewController.getInstance(with: presenter)
    }
    
    fileprivate func createBookCharacterListVC(with router: Router, book: Book) -> UIViewController {
        let apiService = FetchCharactersFromAPIServiceImpl()
        let service = FetchCharactersFromBookServiceImpl(with: book, lookupService: apiService)
        
        let presenter = BookCharacterListPresenterImpl(with:
            BookCharacterListPresenterImpl.Dependencies(
                characterService: service,
                book: book,
                router: router
            )
        )
        
        return CharacterListViewController.getInstance(with: presenter)
    }
    
    fileprivate func createCharacterDetailsVC(with router: Router, character: Character) -> UIViewController {
        let charService = FetchCharactersFromAPIServiceImpl()
        let bookService = FetchBooksFromAPIServiceImpl()
        
        let dependencies = CharacterDetailsPresenterImpl.Dependencies(
            router: router,
            character: character,
            characterService: charService,
            booksService: bookService
        )
        
        let presenter = CharacterDetailsPresenterImpl(with: dependencies)
        
        return CharacterDetailsViewController.getInstance(with: presenter)
    }
    
    fileprivate func createBookListVC(with router: Router) -> UIViewController {
        let bookService = FetchBooksFromAPIServiceImpl()
        
        let dependencies = BookListPresenterImpl.Dependencies(
            router: router,
            bookService: bookService
        )
        
        let presenter = BookListPresenterImpl(with: dependencies)
        
        return BookListViewController.getInstance(with: presenter)
    }
    
    fileprivate func createNoConnectionVC(with router: Router, errorString: String, delegate: NoConnectionPresenterDelegate) -> UIViewController {
        
        let dependencies = NoConnectionPresenterImpl.Dependencies(
            router: router,
            delegate : delegate,
            customErrorString : errorString
        )
        
        let presenter = NoConnectionPresenterImpl(with: dependencies)
        
        return NoConnectionViewController.getInstance(with: presenter)
    }
    
    fileprivate func createAboutAppVC(with router: Router) -> UIViewController {
        let dependencies = AboutAppPresenterImpl.Dependencies(router: router)
        
        let presenter = AboutAppPresenterImpl(with: dependencies)
        
        return AboutAppViewController.getInstance(with: presenter)
    }
}

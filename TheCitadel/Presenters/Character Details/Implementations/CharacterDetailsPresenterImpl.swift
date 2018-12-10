//
//  CharacterDetailsPresenterImpl.swift
//  TheCitadel
//
//  Created by Mateusz Popiało on 06/12/2018.
//  Copyright © 2018 Mateusz Popiało. All rights reserved.
//

import Foundation

final class CharacterDetailsPresenterImpl : CharacterDetailsPresenter {
    
    //MARK: - Dependencies
    struct Dependencies {
        var router : Router
        var character : Character
        var characterService : FetchCharactersService
        var booksService : FetchBooksService
    }
    
    //MARK: - CharacterDetailsPresenter
    weak var view : CharacterDetailsView?
    
    var router : Router
    var character : Character
    var characterService : FetchCharactersService
    var booksService : FetchBooksService

    init(with dependencies : CharacterDetailsPresenterImpl.Dependencies) {
        router = dependencies.router
        character = dependencies.character
        characterService = dependencies.characterService
        booksService = dependencies.booksService
        retrieveFetchables()
    }
    
    func attach(view: CharacterDetailsView) {
        self.view = view
        configureView()
    }
    
    //MARK: - Configuration
    private func configureView() {
        let config = CharacterDetailsViewConfig(
            title: self.character.getMainDescriptor()
        )
        
        view?.configureView(using: config)
        view?.update(with: character)
    }
}

//MARK: - Retrieve fetchables
extension CharacterDetailsPresenterImpl {
    
    private func retrieveFetchables() {
        retrieveBooks()
        retrievePovBooks()
        retrieveSpouse()
        retrieveFather()
        retrieveMother()
    }
    
    private func retrieveBooks() {
        
        guard
            let books = character.books
        else {
            return
        }
        
        for (index, book) in books.enumerated() {
            guard
                case .notFetchedYet(let id) = book
            else {
                continue
            }
            
            booksService.fetchBook(with: id) {
                result in
                
                switch result {
                case .success(let book):
                    
                    self.character.books?[index] = .fetched(book)
                    self.view?.update(with: self.character)
                    
                case .error(let error):
                    self.handleError(error)
                    
                }
            }
            
        }
    }
    
    private func retrievePovBooks() {
        guard
            let books = character.povBooks
        else {
            return
        }
        
        for (index, book) in books.enumerated() {
            guard
                case .notFetchedYet(let id) = book
            else {
                continue
            }
            
            booksService.fetchBook(with: id) {
                result in
                
                switch result {
                case .success(let book):
                    
                    self.character.povBooks?[index] = .fetched(book)
                    self.view?.update(with: self.character)
                    
                case .error(let error):
                    self.handleError(error)
                    
                }
            }
            
        }
    }
    
    private func retrieveSpouse() {
        guard
            case .notFetchedYet(let id)? = character.spouse
        else {
            return
        }
        fetchCharacter(with: id) {
            spouse in
            
            self.character.spouse = .fetched(spouse)
            self.view?.update(with: self.character)
        }
    }
    
    private func retrieveMother() {
        guard
            case .notFetchedYet(let id)? = character.mother
        else {
            return
        }
        fetchCharacter(with: id) {
            mother in
            self.character.mother = .fetched(mother)
            self.view?.update(with: self.character)
        }
    }
    
    private func retrieveFather() {
        guard
            case .notFetchedYet(let id)? = character.father
        else {
            return
        }
        fetchCharacter(with: id) {
            father in
            
            self.character.father = .fetched(father)
            self.view?.update(with: self.character)
        }
    }
    
    private func fetchCharacter(with id: Int, completion: @escaping (Character) -> Void) {
        characterService.fetchCharacter(with: id) {
            result in
            
            switch result {
                
            case .success(let character):
                completion(character)
                
            case .error(let error):
                self.handleError(error)

            }
        }
    }
}

//MARK: - Events emitted from view
extension CharacterDetailsPresenterImpl {
    
    func selectCharacter(character: Character) {
        self.router.transition(to: Destinations.characterDetails(character))
    }
    
    func selectBook(book: Book) {
        if book.characters.count > 0 {
            self.router.transition(to: Destinations.charactersForBook(book))
        }
    }
}

//MARK: - No connection presenter delegate & error handling
extension CharacterDetailsPresenterImpl : NoConnectionPresenterDelegate {
    
    fileprivate func handleError(_ error : Error) {
        self.router.transition(to: Destinations.noConnection(customErrorString: error.localizedDescription, delegate: self))
    }
    
    func onRetryPressed() {
        retrieveFetchables()
    }
}

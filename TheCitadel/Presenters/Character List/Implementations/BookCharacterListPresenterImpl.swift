//
//  BookCharacterListPresenterImpl.swift
//  TheCitadel
//
//  Created by Mateusz Popiało on 05/12/2018.
//  Copyright © 2018 Mateusz Popiało. All rights reserved.


import Foundation

//MARK: - Implementation
final class BookCharacterListPresenterImpl : CharacterListPresenter {
    
    //MARK: - Dependencies
    struct Dependencies {
        var characterService : FetchCharactersService
        var book: Book
        var router : Router
    }
    
    //MARK: - CharacterListPresenter
    private weak var view : CharacterListView?
    
    var characterService: FetchCharactersService
    
    var router : Router
    
    var book: Book
    
    //MARK: - State
    private var currentlySelectedFilter : CharacterFilter = .all
    
    private var currentPage : Int = 0
    
    private var currentSearchTerm : String = ""
    
    private var prefilteredCharacters: [Character] = []
    
    private var shouldFetchMoreCharacters : Bool = true
    
    var characters : [Character] {
        if currentSearchTerm.isEmpty {
            return prefilteredCharacters.filter { $0.checkIfMatches(currentlySelectedFilter) }
        } else {
            return prefilteredCharacters.filter { $0.checkIfMatches(currentSearchTerm) && $0.checkIfMatches(currentlySelectedFilter) }
        }
    }
    
    //MARK: - Configuration
    init(with dependencies : BookCharacterListPresenterImpl.Dependencies) {
        characterService = dependencies.characterService
        router = dependencies.router
        book = dependencies.book
    }
    
    func attach(view: CharacterListView) {
        self.view = view
        configureView()
    }
    
    private func configureView() {
        let config = CharacterListViewConfig(
            title: book.getMainDescriptor(),
            filters: [.all, .alive, .dead]
        )
        view?.configureView(using: config)
    }
}

//MARK: - Fetching characters from service
extension BookCharacterListPresenterImpl {
    
    fileprivate func fetchCharactersFromService(nextPage: Bool = false) {
        
        var page = currentPage
        
        if nextPage {
            self.view?.setBottomIndicatorVisibility(visible: true)
            self.shouldFetchMoreCharacters = false
            page += 1
        } else {
            currentPage = 0
            page = 0 
            self.view?.setCentralIndicatorVisibility(visible: true)
        }
        
        let query = CharacterQuery(
            filter: .all,
            page: page,
            pageLimit: Constants.Books.booksBatchSize
        )
        
        characterService.fetchCharacters(using: query) {
            result in
            
            switch result {
            case .success(let characters):
                if nextPage {
                    self.view?.setBottomIndicatorVisibility(visible: false)
                    self.currentPage += 1
                    self.prefilteredCharacters.append(contentsOf: characters)
                    if characters.count < query.pageLimit {
                        self.shouldFetchMoreCharacters = false
                    } else {
                        self.shouldFetchMoreCharacters = true
                    }
                } else {
                    self.view?.setCentralIndicatorVisibility(visible: false)
                    self.prefilteredCharacters = characters
                }
                self.view?.reloadData(with: self.characters)
                
            case .error(let error):
                self.resetState()
                self.router.transition(to: Destinations.noConnection(customErrorString: error.localizedDescription, delegate: self))
            }
        }
    }
    
    private func resetState() {
        self.currentPage = 0
        self.shouldFetchMoreCharacters = true
        self.prefilteredCharacters.removeAll()
        self.view?.reloadData(with: self.characters)
    }
    
}

//MARK: - Events emitted from view
extension BookCharacterListPresenterImpl {
    
    func onSearchTermChanged(newTerm: String) {
        currentSearchTerm = newTerm
        view?.reloadData(with: self.characters)
    }
    
    func onFilterChanged(newFilter: CharacterFilter) {
        currentlySelectedFilter = newFilter
        view?.reloadData(with: self.characters)
    }
    
    func shouldTryToFetchMoreCharacters() -> Bool {
        var filterIsDisabled : Bool = false
        if case .all = self.currentlySelectedFilter {
            filterIsDisabled = true
        }
        return shouldFetchMoreCharacters && self.currentSearchTerm.isEmpty && filterIsDisabled
    }
    
    func fetchCharacters() {
        fetchCharactersFromService()
    }
    
    func fetchMoreCharacters() {
        fetchCharactersFromService(nextPage: true)
    }
    
    func selectCharacter(character: Character) {
        self.router.transition(to: Destinations.characterDetails(character))
    }
}

//MARK: - No connection view delegate
extension BookCharacterListPresenterImpl : NoConnectionPresenterDelegate {
    
    func onRetryPressed() {
        fetchCharacters()
    }
}

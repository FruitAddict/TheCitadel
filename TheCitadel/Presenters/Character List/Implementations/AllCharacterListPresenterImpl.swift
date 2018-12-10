//
//  AllCharacterListPresenter.swift
//  TheCitadel
//
//  Created by Mateusz Popiało on 05/12/2018.
//  Copyright © 2018 Mateusz Popiało. All rights reserved.
//

import Foundation

//MARK: - Implementation
final class AllCharacterListPresenterImpl : CharacterListPresenter {
    
    //MARK: - Dependencies
    struct Dependencies {
        var characterService : FetchCharactersService
        var router : Router
    }

    //MARK: - CharacterListPresenter
    private weak var view : CharacterListView?

    var characterService: FetchCharactersService
    
    var router : Router
    
    //MARK: - State
    private var currentlySelectedFilter : CharacterFilter = .all

    private var currentPage : Int = Constants.API.Characters.firstPageIndex
    
    private var currentSearchTerm : String = ""
    
    private var prefilteredCharacters: [Character] = []
    
    private var shouldFetchMoreCharacters : Bool = true
    
    var characters : [Character] {
        if currentSearchTerm.isEmpty {
            return prefilteredCharacters
        } else {
            return prefilteredCharacters.filter { $0.checkIfMatches(currentSearchTerm) }
        }
    }
    
    //MARK: - Configuration
    init(with dependencies : AllCharacterListPresenterImpl.Dependencies) {
        characterService = dependencies.characterService
        router = dependencies.router
    }
    
    func attach(view: CharacterListView) {
        self.view = view
        configureView()
    }
    
    private func configureView() {
        let config = CharacterListViewConfig(
            title: "charactersTabTitle".localized,
            filters: [.all, .alive, .dead]
        )
        view?.configureView(using: config)
    }
}

//MARK: - Fetching characters from service
extension AllCharacterListPresenterImpl {
    
    
    func fetchCharactersFromService(nextPage: Bool = false) {
        
        var page = currentPage
        
        if nextPage {
            self.view?.setBottomIndicatorVisibility(visible: true)
            self.shouldFetchMoreCharacters = false
            page += 1
        } else {
            currentPage = Constants.API.Characters.firstPageIndex
            page = Constants.API.Characters.firstPageIndex
            self.view?.setCentralIndicatorVisibility(visible: true)
        }
        
        let query = CharacterQuery(
            filter: currentlySelectedFilter,
            page: page,
            pageLimit: Constants.API.Characters.itemsPerPage
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
                guard
                    error.localizedDescription != Constants.ErrorDescription.cancelled
                else {
                    return
                }
                self.resetState()
                self.router.transition(to: Destinations.noConnection(customErrorString: error.localizedDescription, delegate: self))
            }
        }
    }
    
    private func resetState() {
        self.currentPage = Constants.API.Characters.firstPageIndex
        self.shouldFetchMoreCharacters = true
        self.prefilteredCharacters.removeAll()
        self.view?.reloadData(with: self.characters)
    }
    
}

//MARK: - Events emitted from view
extension AllCharacterListPresenterImpl {
    
    func onSearchTermChanged(newTerm: String) {
        currentSearchTerm = newTerm
        view?.reloadData(with: self.characters)
    }
    
    func onFilterChanged(newFilter: CharacterFilter) {
        currentlySelectedFilter = newFilter
        fetchCharactersFromService(nextPage: false)
    }
    
    func shouldTryToFetchMoreCharacters() -> Bool {
        return shouldFetchMoreCharacters && self.currentSearchTerm.isEmpty
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
extension AllCharacterListPresenterImpl : NoConnectionPresenterDelegate {
    
    func onRetryPressed() {
        fetchCharacters()
    }
}

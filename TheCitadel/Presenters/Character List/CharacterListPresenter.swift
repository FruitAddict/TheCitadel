//
//  CharacterListPresenter.swift
//  TheCitadel
//
//  Created by Mateusz Popiało on 05/12/2018.
//  Copyright © 2018 Mateusz Popiało. All rights reserved.
//

import Foundation

//MARK: - Supported view contract
struct CharacterListViewConfig {
    var title : String
    var filters : [CharacterFilter]
}

protocol CharacterListView : class {
    
    func configureView(using config: CharacterListViewConfig)
    
    func reloadData(with data: [Character])
    
    func setBottomIndicatorVisibility(visible: Bool)
    
    func setCentralIndicatorVisibility(visible: Bool)
}

//MARK: - Presenter
protocol CharacterListPresenter : class {

    var characterService : FetchCharactersService { get }
        
    func attach(view: CharacterListView)
    
    func onSearchTermChanged(newTerm: String)
    
    func onFilterChanged(newFilter: CharacterFilter)
    
    func shouldTryToFetchMoreCharacters() -> Bool
    
    func fetchCharacters()
    
    func fetchMoreCharacters()
    
    func selectCharacter(character: Character)
}

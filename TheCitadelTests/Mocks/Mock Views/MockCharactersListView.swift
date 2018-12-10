//
//  MockCharactersListView.swift
//  TheCitadelTests
//
//  Created by Mateusz Popiało on 09/12/2018.
//  Copyright © 2018 Mateusz Popiało. All rights reserved.
//

import Foundation

@testable import TheCitadel

class MockCharacterListView: CharacterListView {
    
    var title : String = ""
    
    var filters : [CharacterFilter] = []
    
    var characters : [TheCitadel.Character] = []
    
    var isCentralIndicatorVisible : Bool = false
    
    var isBottomIndicatorVisible : Bool = true
    
    var presenter: CharacterListPresenter!
    
    init(with presenter: CharacterListPresenter) {
        self.presenter = presenter
        presenter.attach(view: self)
    }
    
    func configureView(using config: CharacterListViewConfig) {
        title = config.title
        filters = config.filters
    }
    
    func reloadData(with data: [TheCitadel.Character]) {
        characters = data
    }
    
    func setBottomIndicatorVisibility(visible: Bool) {
        isBottomIndicatorVisible = visible
    }
    
    func setCentralIndicatorVisibility(visible: Bool) {
        isCentralIndicatorVisible = visible
    }
    
    //MARK: - Actions
    func changeSearchTerm(to newTerm: String) {
        presenter.onSearchTermChanged(newTerm: newTerm)
    }
    
    func changeFilter(to newFilter: CharacterFilter) {
        presenter.onFilterChanged(newFilter: newFilter)
    }
    
    func loadMore() {
        presenter.fetchMoreCharacters()
    }
    
    func select(character: TheCitadel.Character) {
        presenter.selectCharacter(character: character)
    }
    
}

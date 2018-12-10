//
//  MockCharacterDetailsView.swift
//  TheCitadelTests
//
//  Created by Mateusz Popiało on 09/12/2018.
//  Copyright © 2018 Mateusz Popiało. All rights reserved.
//

import Foundation

@testable import TheCitadel

class MockCharacterDetailsView : CharacterDetailsView {
    
    var title : String = ""
    
    var currentCharacter : TheCitadel.Character!
    
    var reloadDataCalled : Bool = false
    
    var presenter : CharacterDetailsPresenter!
    
    init(with presenter: CharacterDetailsPresenter) {
        self.presenter = presenter
        presenter.attach(view: self)
    }
    
    func configureView(using: CharacterDetailsViewConfig) {
        self.title = using.title
    }
    
    func update(with character: TheCitadel.Character) {
        currentCharacter = character
    }
    
    func reloadData() {
        reloadDataCalled = true
    }
    
    //MARK: - Actions
    func selectCharacter(character: TheCitadel.Character) {
        presenter.selectCharacter(character: character)
    }
    
    func selectBook(book: Book) {
        presenter.selectBook(book: book)
    }
    
}

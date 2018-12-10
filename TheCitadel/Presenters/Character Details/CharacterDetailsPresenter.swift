//
//  CharacterDetailsPresenter.swift
//  TheCitadel
//
//  Created by Mateusz Popiało on 06/12/2018.
//  Copyright © 2018 Mateusz Popiało. All rights reserved.
//

import Foundation

//MARK: - Supported view contract
struct CharacterDetailsViewConfig {
    var title : String
}

protocol CharacterDetailsView : class {
    
    func configureView(using: CharacterDetailsViewConfig)
    
    func update(with character : Character)
    
    func reloadData()
    
}

//MARK: - Presenter
protocol CharacterDetailsPresenter {
    
    func attach(view: CharacterDetailsView)
    
    func selectCharacter(character: Character)
    
    func selectBook(book: Book)
    
}

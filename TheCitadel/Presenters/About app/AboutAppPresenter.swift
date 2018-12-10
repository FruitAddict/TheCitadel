//
//  AboutAppPresenter.swift
//  TheCitadel
//
//  Created by Mateusz Popiało on 08/12/2018.
//  Copyright © 2018 Mateusz Popiało. All rights reserved.
//

import Foundation

struct AboutAppConfig {
    var title : String
}

protocol AboutAppView : class {
    
    func configureView(using config: AboutAppConfig)
    
    func update(with author: Character, frameworks: [Framework])
    
}

protocol AboutAppPresenter {
    
    func attach(view: AboutAppView)
    
    func selectFramework(framework: Framework)
    
    func selectAuthor(author: Character)
}

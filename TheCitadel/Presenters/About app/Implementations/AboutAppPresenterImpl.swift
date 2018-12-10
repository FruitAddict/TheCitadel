//
//  AboutAppPresenterImpl.swift
//  TheCitadel
//
//  Created by Mateusz Popiało on 08/12/2018.
//  Copyright © 2018 Mateusz Popiało. All rights reserved.
//

import Foundation

final class AboutAppPresenterImpl : AboutAppPresenter {
    
    struct Dependencies {
        var router : Router
    }
    
    //MARK: - Instance variables
    fileprivate weak var view : AboutAppView?
    
    private var router: Router
    
    private lazy var author : Character = {
        
        let character = Character()
        
        character.name = "Mateusz Popiało"
        character.gender = "Male"
        character.born = "in 1994, Jastrzębie-Zdrój"
        character.aliases = ["iOS Developer"]
        character.titles = ["MSc in Comp Sci (in progress)"]
        
        return character
    }()
    
    private lazy var frameworks : [Framework] = {
        
        let moya = Framework(
            name: "Moya",
            url: "https://github.com/Moya/Moya"
        )
        
        let quick = Framework(
            name: "Quick",
            url: "https://github.com/Quick/Quick"
        )
        
        let nimble = Framework(
            name: "Nimble",
            url: "https://github.com/Quick/Nimble"
        )
        
        return [moya,quick,nimble]
    }()
    
    //MARK: - Initialization
    init(with dependencies: Dependencies) {
        self.router = dependencies.router
    }
    
    func attach(view: AboutAppView) {
        self.view = view
        configureView()
    }
    
    //MARK: - View configuration
    private func configureView() {
        let config = AboutAppConfig(
            title: NSLocalizedString("aboutApp", comment: "")
        )
        view?.configureView(using: config)
        view?.update(with: self.author, frameworks: self.frameworks)
    }
    
}

//MARK: - Events emitted from view
extension AboutAppPresenterImpl {
    
    func selectFramework(framework: Framework) {
        guard
            let url = URL(string: framework.url)
           else {
            return
        }
        self.router.open(url: url)
    }
    
    func selectAuthor(author: Character) {
        self.router.transition(to: Destinations.characterDetails(author))
    }
    
    
}

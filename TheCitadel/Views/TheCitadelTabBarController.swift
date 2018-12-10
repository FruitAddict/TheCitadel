//
//  TheCitadelTabBarController.swift
//  TheCitadel
//
//  Created by Mateusz Popiało on 04/12/2018.
//  Copyright © 2018 Mateusz Popiało. All rights reserved.
//

import UIKit

final class TheCitadelTabBarController: UITabBarController {
 
    private struct TheCitadelTabBarControllerTags {
        static let charactersTag = 0
        static let booksTag = 1
        static let moreTag = 2
    }
    
    //MARK: - Child view controllers
    private lazy var characterListNavigationController : TheCitadelNavigationController = {
        let navCtrl = TheCitadelNavigationController()
        let image = UIImage.swordIcon?.resize(targetSize: .tabIconSize)
        navCtrl.tabBarItem = UITabBarItem(title: "charactersTabTitle".localized, image: image, tag: TheCitadelTabBarControllerTags.charactersTag)
        return navCtrl
    }()
    
    private lazy var bookListNavigationController : TheCitadelNavigationController = {
        let navCtrl = TheCitadelNavigationController()
        let image = UIImage.bookIcon?.resize(targetSize: .tabIconSize)
        navCtrl.tabBarItem = UITabBarItem(title: "booksTabTitle".localized, image: image, tag: TheCitadelTabBarControllerTags.booksTag)
        return navCtrl
    }()
    
    private lazy var showMoreNavigationController : TheCitadelNavigationController = {
        let navCtrl = TheCitadelNavigationController()
        let image = UIImage.moreIcon?.resize(targetSize: .tabIconSize)
        navCtrl.tabBarItem = UITabBarItem(title: "moreTabTitle".localized, image: image, tag: TheCitadelTabBarControllerTags.moreTag)
        return navCtrl
    }()
    

    //MARK: - View lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureUI()
        self.setupViewControllers()
    }
    
    //MARK: - Configuration
    private func configureUI() {
        self.view.backgroundColor = .white
    }
    
    private func setupViewControllers() {
        self.viewControllers = [
            characterListNavigationController,
            bookListNavigationController,
            showMoreNavigationController
        ]
        
        setupCharacterListViewController()
        setupBookListViewController()
        setupShowMoreViewController()
    }
    
    private func setupCharacterListViewController() {
        characterListNavigationController.router.transition(to: Destinations.allCharacters)
    }
    
    private func setupBookListViewController() {
        bookListNavigationController.router.transition(to: Destinations.allBooks)
    }
    
    private func setupShowMoreViewController() {
        showMoreNavigationController.router.transition(to: Destinations.aboutApp)
    }
    
}


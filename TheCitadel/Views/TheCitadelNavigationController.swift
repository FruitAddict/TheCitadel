//
//  TheCitadelNavigationController.swift
//  TheCitadel
//
//  Created by Mateusz Popiało on 05/12/2018.
//  Copyright © 2018 Mateusz Popiało. All rights reserved.
//

import UIKit

final class TheCitadelNavigationController : UINavigationController {
    
    //MARK: - Router
    lazy var router : Router = {
       return RouterImpl(base: self)
    }()
    
    //MARK: - View lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    
    //MARK: - Configuration
    private func configureUI() {
        navigationItem.largeTitleDisplayMode = .automatic
        navigationBar.prefersLargeTitles = true
        navigationBar.isTranslucent = false
    }
}

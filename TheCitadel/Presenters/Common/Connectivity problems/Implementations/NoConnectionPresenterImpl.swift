//
//  NoConnectionPresenterImpl.swift
//  TheCitadel
//
//  Created by Mateusz Popiało on 08/12/2018.
//  Copyright © 2018 Mateusz Popiało. All rights reserved.
//

import Foundation

final class NoConnectionPresenterImpl : NoConnectionViewPresenter {
    
    struct Dependencies {
        var router : Router
        var delegate : NoConnectionPresenterDelegate
        var customErrorString : String?
    }
    
    //MARK: - Instance variables
    fileprivate weak var view : NoConnectionView?
    
    private weak var delegate : NoConnectionPresenterDelegate?
    
    private var router: Router
        
    private var customErrorString : String?
    
    //MARK: - Initialization
    init(with dependencies: Dependencies) {
        self.delegate = dependencies.delegate
        self.customErrorString = dependencies.customErrorString
        self.router = dependencies.router
    }
    
    func attach(view: NoConnectionView) {
        self.view = view
        configureView()
    }
    
    //MARK: - View configuration
    private func configureView() {
        let config = NoConnectionViewConfig(
            title: "connectivityProblems".localized,
            customErrorString: customErrorString.orEmpty
        )
        view?.configureView(using: config)
    }
    
}

//MARK: - Events emitted from view
extension NoConnectionPresenterImpl {
    
    func retryPressed() {
        self.delegate?.onRetryPressed()
        self.view?.dismiss()
    }
    
    func goToSettingsPressed() {
        guard
            let url = URL(string: Constants.URLs.networkSettings)
        else {
            return
        }
        self.router.open(url: url)
    }
}

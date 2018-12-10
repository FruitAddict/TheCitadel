//
//  NoConnectionPresenter.swift
//  TheCitadel
//
//  Created by Mateusz Popiało on 08/12/2018.
//  Copyright © 2018 Mateusz Popiało. All rights reserved.
//

import Foundation

struct NoConnectionViewConfig {
    var title : String
    var customErrorString : String
}

//MARK: - Supported view contract
protocol NoConnectionView : class {
    
    func configureView(using: NoConnectionViewConfig)
    
    func dismiss()
    
}

//MARK: - Delegate
protocol NoConnectionPresenterDelegate : class {
    func onRetryPressed()
}

//MARK: - Presenter
protocol NoConnectionViewPresenter {
    
    func attach(view: NoConnectionView)
    
    func retryPressed()
    
    func goToSettingsPressed()

}

//
//  NoConnectionViewController.swift
//  TheCitadel
//
//  Created by Mateusz Popiało on 08/12/2018.
//  Copyright © 2018 Mateusz Popiało. All rights reserved.
//

import UIKit

//MARK: - Creation
extension NoConnectionViewController {
    
    static func getInstance(with presenter: NoConnectionViewPresenter) -> NoConnectionViewController {
        let noConnectionVC = NoConnectionViewController(nibName: String(describing: NoConnectionViewController.self), bundle: Bundle(for: NoConnectionViewController.self))
        
        _ = noConnectionVC.view
        
        noConnectionVC.configure(using: presenter)
        
        return noConnectionVC
    }
    
}

final class NoConnectionViewController: UIViewController {
    
    //MARK: - Interface builder outlets
    @IBOutlet weak var titleLabel: UILabel! {
        didSet {
            titleLabel.text = "commonErrorTitle".localized
        }
    }
    
    @IBOutlet weak var descriptionLabel: UILabel! {
        didSet {
            descriptionLabel.text = "commonErrorDesc".localized
        }
    }
    
    @IBOutlet weak var orLabel: UILabel! {
        didSet {
            orLabel.text = "or".localized
        }
    }
    
    @IBOutlet weak var tryAgainButton: UIButton! {
        didSet {
            tryAgainButton.addTarget(self, action: #selector(tryAgainButtonClicked), for: .touchUpInside)
            tryAgainButton.applyBorderedStyle()
        }
    }
    
    @IBOutlet weak var goToSettingsButton: UIButton! {
        didSet {
            goToSettingsButton.addTarget(self, action: #selector(goToSettingsButtonClicked), for: .touchUpInside)
            goToSettingsButton.applyBorderedStyle()
        }
    }
  
    //MARK: - Instance variables & dependencies
    fileprivate var presenter : NoConnectionViewPresenter!
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    //MARK: - Configuration
    private func configure(using presenter: NoConnectionViewPresenter) {
        self.presenter = presenter
        presenter.attach(view: self)
    }
    
    //MARK: - Actions
    @objc fileprivate func tryAgainButtonClicked() {
        presenter.retryPressed()
    }
    
    @objc fileprivate func goToSettingsButtonClicked() {
        presenter.goToSettingsPressed()
    }
}

extension NoConnectionViewController : NoConnectionView {
    
    func configureView(using config: NoConnectionViewConfig) {
        self.title = config.title
        if !config.customErrorString.isEmpty {
            self.descriptionLabel.text = config.customErrorString
        }
    }
    
    func dismiss() {
        self.dismiss(animated: true, completion: nil)
    }
    
}


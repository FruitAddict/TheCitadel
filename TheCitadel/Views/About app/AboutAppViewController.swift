//
//  AboutAppViewController.swift
//  TheCitadel
//
//  Created by Mateusz Popiało on 08/12/2018.
//  Copyright © 2018 Mateusz Popiało. All rights reserved.
//

import UIKit

//MARK: - Creation & DI
extension AboutAppViewController {
    
    static func getInstance(with presenter: AboutAppPresenter) -> AboutAppViewController {
        let aboutAppVC = AboutAppViewController(nibName: String(describing: AboutAppViewController.self), bundle: Bundle(for: AboutAppViewController.self))
        
        _ = aboutAppVC.view
        
        aboutAppVC.configure(using: presenter)
        
        return aboutAppVC
    }
}


final class AboutAppViewController: UIViewController {

    //MARK: - Interface builder outlets
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.delegate = self
            tableView.dataSource = self
        }
    }
    
    //MARK: - Instance variables & dependencies
    private var presenter: AboutAppPresenter!
    
    private let numberOfSections = 2
    private let authorSectionIndex = 0
    private let frameworksSectionIndex = 1
    
    private var author : Character!
    
    private var frameworks: [Framework] = []
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        registerTableViewCells()
    }
    
    //MARK: - Configuration
    private func registerTableViewCells() {
        tableView.register(UINib(nibName: String(describing: BasicInfoTableViewCell.self), bundle: Bundle(for: BasicInfoTableViewCell.self)), forCellReuseIdentifier: BasicInfoTableViewCell.identifier)
        
        tableView.register(UINib(nibName: String(describing: CharacterTableViewCell.self), bundle: Bundle(for: CharacterTableViewCell.self)), forCellReuseIdentifier: CharacterTableViewCell.identifier)
    }
    
    fileprivate func configure(using presenter: AboutAppPresenter) {
        self.presenter = presenter
        presenter.attach(view: self)
    }
    
}

//MARK: - TableView delegate & DataSource
extension AboutAppViewController : UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return numberOfSections
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case authorSectionIndex :
            return 1
            
        case frameworksSectionIndex:
            return frameworks.count
            
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case authorSectionIndex:
            return NSLocalizedString("authorSection", comment: "")
            
        case frameworksSectionIndex:
            return NSLocalizedString("frameworks", comment: "")
            
        default:
            return ""
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case authorSectionIndex:
            return createAuthorCell(for: indexPath)
            
        case frameworksSectionIndex:
            return createFrameworkCell(for: indexPath)
            
        default:
            fatalError("Section \(indexPath.section) doesn't exist. Make sure your data is valid.")
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        switch indexPath.section {
        case authorSectionIndex:
            presenter.selectAuthor(author: self.author)
            
        case frameworksSectionIndex:
            let framework = self.frameworks[indexPath.row]
            presenter.selectFramework(framework: framework)
            
        default: ()
            
        }
    }
    
    private func createAuthorCell(for indexPath: IndexPath) -> UITableViewCell {
        guard
            let cell = tableView.dequeueReusableCell(withIdentifier: CharacterTableViewCell.identifier, for: indexPath) as? CharacterTableViewCell
        else {
            fatalError("Couldn't dequeue the table cell, make sure you're using correct identifiers and the cell is properly registered")
        }
        
        cell.accessoryType = .disclosureIndicator
        
        let data = CharacterTableViewCellData(with: self.author)
        cell.configure(with: data)
        
        return cell
    }
    
    private func createFrameworkCell(for indexPath: IndexPath) -> UITableViewCell {
        guard
            let cell = tableView.dequeueReusableCell(withIdentifier: BasicInfoTableViewCell.identifier, for: indexPath) as? BasicInfoTableViewCell
        else {
            fatalError("Couldn't dequeue the table cell, make sure you're using correct identifiers and the cell is properly registered")
        }
        
        cell.accessoryType = .disclosureIndicator
        cell.selectionStyle = .default
        
        let model = self.frameworks[indexPath.row]
        let data = BasicInfoTableViewCellData(titleText: model.name, infoText: model.url)
        cell.configure(with: data)
        
        return cell
    }
    
}

extension AboutAppViewController : AboutAppView {
    
    func update(with author: Character, frameworks: [Framework]) {
        self.author = author
        self.frameworks = frameworks
        self.tableView.reloadData()
    }
    
    func configureView(using config: AboutAppConfig) {
        self.navigationItem.title = config.title
    }
    
}

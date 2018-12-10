//
//  CharacterDetailsViewController.swift
//  TheCitadel
//
//  Created by Mateusz Popiało on 06/12/2018.
//  Copyright © 2018 Mateusz Popiało. All rights reserved.
//

import UIKit

//MARK: - Creation & DI
extension CharacterDetailsViewController {
    
    static func getInstance(with presenter: CharacterDetailsPresenter) -> CharacterDetailsViewController {
        let characterDetailsVC = CharacterDetailsViewController(nibName: String(describing: CharacterDetailsViewController.self), bundle: Bundle(for: CharacterDetailsViewController.self))
        
        _ = characterDetailsVC.view
        
        characterDetailsVC.configure(using: presenter)
        
        return characterDetailsVC
    }
}

final class CharacterDetailsViewController: UIViewController {
    
    //MARK: - Interaface Builder Outlets
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.estimatedRowHeight = 50
            tableView.rowHeight = UITableView.automaticDimension
            tableView.delegate = self
            tableView.dataSource = self
        }
    }
    
    //MARK: - Instance variables & dependencies
    fileprivate var presenter : CharacterDetailsPresenter!
    
    fileprivate var sections: [CharacterDetailsViewSection] = []

    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        registerTableViewCells()
    }
    
    //MARK: - Configuration
    fileprivate func configure(using presenter: CharacterDetailsPresenter) {
        self.presenter = presenter
        self.presenter.attach(view: self)
    }
    
    private func registerTableViewCells() {
        tableView.register(UINib(nibName: String(describing: BasicInfoTableViewCell.self), bundle: Bundle(for: BasicInfoTableViewCell.self)), forCellReuseIdentifier: BasicInfoTableViewCell.identifier)
        
        tableView.register(UINib(nibName: String(describing: PreloaderTableViewCell.self), bundle: Bundle(for: PreloaderTableViewCell.self)), forCellReuseIdentifier: PreloaderTableViewCell.identifier)
        
        tableView.register(UINib(nibName: String(describing: CharacterTableViewCell.self), bundle: Bundle(for: CharacterTableViewCell.self)), forCellReuseIdentifier: CharacterTableViewCell.identifier)
        
        tableView.register(UINib(nibName: String(describing: BookTableViewCell.self), bundle: Bundle(for: BookTableViewCell.self)), forCellReuseIdentifier: BookTableViewCell.identifier)
    }
}

//MARK: - UITableViewDelegate & DataSource
extension CharacterDetailsViewController : UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.sections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.sections[section].sectionItems.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return self.sections[section].type.descriptor
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let section = sections[indexPath.section]
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        if
            case .anotherCharacter(let character) = section.sectionItems[indexPath.row],
            case .fetched(let fetchedChar) = character {
            presenter.selectCharacter(character: fetchedChar)
        }
        
        if
            case .book(let book) = section.sectionItems[indexPath.row],
            case .fetched(let fetchedBook) = book {
            presenter.selectBook(book: fetchedBook)
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let section = indexPath.section
        let item = self.sections[section].sectionItems[indexPath.row]
        
        return createCell(for: item, at: indexPath)
    }
    
    private func createCell(for item: CharacterDetailsViewSectionItem, at indexPath: IndexPath) -> UITableViewCell {
        
        switch item {
        case .basic(let title, let value):
            return createBasicCell(title: title, value: value, at: indexPath)
            
        case .anotherCharacter(let characterContainer):
            switch characterContainer {
            case .fetched(let character):
                return createCharacterCell(for: character, at: indexPath)
                
            case .notFetchedYet(_):
                 return createPreloaderCell(at: indexPath)
                
            }
            
        case .book(let bookContainer):
            switch bookContainer {
            case .fetched(let book):
                return createBookCell(for: book, at: indexPath)
                
            case .notFetchedYet(_):
                return createPreloaderCell(at: indexPath)

            }
        }
    }
    
    private func createBasicCell(title: String, value: String, at indexPath: IndexPath) -> UITableViewCell {
        guard
            let cell = self.tableView.dequeueReusableCell(withIdentifier: BasicInfoTableViewCell.identifier, for: indexPath) as? BasicInfoTableViewCell
        else {
            fatalError("Couldn't dequeue the table cell, make sure you're using correct identifiers and the cell is properly register")
        }
        
        cell.configure(with: BasicInfoTableViewCellData(titleText: title, infoText: value))
        
        return cell
    }
    
    private func createBookCell(for book: Book, at indexPath: IndexPath) -> UITableViewCell {
        guard
            let cell = self.tableView.dequeueReusableCell(withIdentifier: BookTableViewCell.identifier, for: indexPath) as? BookTableViewCell
        else {
            fatalError("Couldn't dequeue the table cell, make sure you're using correct identifiers and the cell is properly register")
        }
        
        cell.configure(with: BookTableViewCellData(from: book))
        
        return cell
    }
    
    private func createCharacterCell(for character: Character, at indexPath: IndexPath) -> UITableViewCell {
        guard
            let cell = tableView.dequeueReusableCell(withIdentifier: CharacterTableViewCell.identifier, for: indexPath) as? CharacterTableViewCell
        else {
            fatalError("Couldn't dequeue the table cell, make sure you're using correct identifiers and the cell is properly registered")
        }
        
        cell.accessoryType = .disclosureIndicator
        
        let data = CharacterTableViewCellData(with: character)
        cell.configure(with: data)
        
        return cell
    }
    
    private func createPreloaderCell(at indexPath: IndexPath) -> UITableViewCell {
        guard
            let cell = self.tableView.dequeueReusableCell(withIdentifier: PreloaderTableViewCell.identifier, for: indexPath) as? PreloaderTableViewCell
        else {
            fatalError("Couldn't dequeue the table cell, make sure you're using correct identifiers and the cell is properly register")
        }
        
        cell.startIndicatingProgress()
        
        return cell
    }
}

//MARK: CharacterDetailsView conformance
extension CharacterDetailsViewController : CharacterDetailsView {
    
    func configureView(using config: CharacterDetailsViewConfig) {
        self.title = config.title
    }
    
    func update(with character: Character) {
        self.sections = CharacterDetailsViewSection.createSections(from: character)
        self.tableView.reloadData()
    }
    
    func reloadData() {
        var sectionsToReload : [Int] = []
        for (index, element) in sections.enumerated() {
            switch element.type {
            case .spouse, .father, .mother, .books, .povBooks:
                sectionsToReload.append(index)
            default:
                ()
            }
        }
        tableView.reloadSections(IndexSet(sectionsToReload), with: .automatic)
    }
}

//
//  CharacterListViewController.swift
//  TheCitadel
//
//  Created by Mateusz Popiało on 05/12/2018.
//  Copyright © 2018 Mateusz Popiało. All rights reserved.
//

import UIKit

//MARK: Creation & DI
extension CharacterListViewController {
    
    static func getInstance(with presenter: CharacterListPresenter) -> CharacterListViewController {
        let characterListVC = CharacterListViewController(nibName: String(describing: CharacterListViewController.self), bundle: Bundle(for: CharacterListViewController.self))
        
        _ = characterListVC.view
        
        characterListVC.configure(using: presenter)
        
        return characterListVC
    }
    
}

final class CharacterListViewController: UIViewController {
    
    //MARK: - Interface builder outlets
    @IBOutlet weak var tableView : UITableView! {
        didSet {
            tableView.delegate = self
            tableView.dataSource = self
            tableView.estimatedRowHeight = 50
            tableView.rowHeight = UITableView.automaticDimension
        }
    }
    
    //MARK: - Instance variables & dependencies
    private lazy var bottomIndicatorView : IndicatorView = {
        let view = IndicatorView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 44))
        return view
    }()
    
    private lazy var centralIndicatorView : IndicatorView = {
        let view = IndicatorView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: tableView.frame.height))
        return view
    }()
    
    private lazy var searchController : UISearchController = {
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        searchController.searchBar.placeholder = "searchPlaceholder".localized
        searchController.searchBar.setValue("searchCancelButtonTitle".localized, forKey:"_cancelButtonText")
        searchController.searchBar.delegate = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.returnKeyType = .done
        searchController.searchBar.enablesReturnKeyAutomatically = false
        return searchController
    }()
    
    fileprivate var presenter : CharacterListPresenter!
    
    fileprivate var filters: [CharacterFilter] = [] {
        didSet {
            self.searchController.searchBar.scopeButtonTitles = filters.map { $0.descriptor } 
        }
    }
    
    fileprivate var characters : [Character] = []
    
    fileprivate var lastSearchText : String = ""
    
    fileprivate var neverAppearedBefore = true
    
    //MARK: - View lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        registerTableViewCells()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //searchControllers default behavior is to hide the searchBar until the view is scrolled
        //to make it visible just after load, we have to temporarily switch it off as the view is presented on the screen
        navigationItem.hidesSearchBarWhenScrolling = false
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        navigationItem.hidesSearchBarWhenScrolling = true
        
        if neverAppearedBefore {
            neverAppearedBefore = false
            presenter.fetchCharacters()
        }
    }
    
    //MARK: - Configuration
    private func configureUI() {
        definesPresentationContext = true
        navigationItem.searchController = searchController
    }
    
    private func registerTableViewCells() {
        tableView.register(UINib(nibName: String(describing: CharacterTableViewCell.self), bundle: Bundle(for: CharacterTableViewCell.self)), forCellReuseIdentifier: CharacterTableViewCell.identifier)
    }
    
    private func configure(using presenter: CharacterListPresenter) {
        self.presenter = presenter
        presenter.attach(view: self)
    }

}

//MARK: UISearchResultsUpdating conformance
extension CharacterListViewController : UISearchResultsUpdating, UISearchBarDelegate {
    
    func updateSearchResults(for searchController: UISearchController) {
        let searchText = searchController.searchBar.text.orEmpty
        lastSearchText = searchText
        presenter.onSearchTermChanged(newTerm: searchText)
    }
    
    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        let filter = self.filters[selectedScope]
        presenter.onFilterChanged(newFilter: filter)
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchBar.text = lastSearchText
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchController.isActive = false
    }
    
}

//MARK: Table view delegate & datasource
extension CharacterListViewController : UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return characters.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard
            let cell = tableView.dequeueReusableCell(withIdentifier: CharacterTableViewCell.identifier, for: indexPath) as? CharacterTableViewCell
        else {
            fatalError("Couldn't dequeue the table cell, make sure you're using correct identifiers and the cell is properly registered")
        }
        
        cell.accessoryType = .disclosureIndicator
        
        let character = characters[indexPath.row]
        
        let data = CharacterTableViewCellData(with: character)
        cell.configure(with: data)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard
            indexPath.row == characters.count - 1,
            presenter.shouldTryToFetchMoreCharacters()
        else {
            return
        }
        
        presenter.fetchMoreCharacters()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let character = characters[indexPath.row]
        presenter.selectCharacter(character: character)
    }
}

//MARK: CharacterListView conformance
extension CharacterListViewController : CharacterListView {
    
    func configureView(using config: CharacterListViewConfig) {
        navigationItem.title = config.title
        filters = config.filters
    }
    
    func reloadData(with data: [Character]) {
        characters = data
        tableView.reloadData()
    }
    
    func setBottomIndicatorVisibility(visible : Bool) {
        if visible {
            tableView.tableFooterView = bottomIndicatorView
            bottomIndicatorView.startIndicatingProgress()
        } else {
            tableView.tableFooterView = nil
            bottomIndicatorView.stopIndicatingProgress()
        }
    }
    
    func setCentralIndicatorVisibility(visible: Bool) {
        if visible {
            view.addSubview(centralIndicatorView)
            centralIndicatorView.frame = tableView.frame
            centralIndicatorView.startIndicatingProgress()
        } else {
            centralIndicatorView.removeFromSuperview()
            centralIndicatorView.stopIndicatingProgress()
        }
    }
}

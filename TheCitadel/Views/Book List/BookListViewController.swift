//
//  BookListViewController.swift
//  TheCitadel
//
//  Created by Mateusz Popiało on 05/12/2018.
//  Copyright © 2018 Mateusz Popiało. All rights reserved.
//

import UIKit

//MARK: - Creation & DI
extension BookListViewController {
    
    static func getInstance(with presenter: BookListPresenter) -> BookListViewController {
        let bookListVC = BookListViewController(nibName: String(describing: BookListViewController.self), bundle: Bundle(for: BookListViewController.self))
        
        _ = bookListVC.view
        
        bookListVC.configure(using: presenter)
        
        return bookListVC
    }
}

final class BookListViewController: UIViewController {

    //MARK: - Interface builder outlets
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.dataSource = self
            tableView.delegate = self
        }
    }
    
    //MARK: - Instance variables & dependencies
    private lazy var centralIndicatorView : IndicatorView = {
        let view = IndicatorView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: tableView.frame.height))
        return view
    }()
    
    fileprivate var neverAppearedBefore = true

    fileprivate var presenter : BookListPresenter!
    
    fileprivate var books : [Book] = []
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        registerTableViewCells()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if neverAppearedBefore {
            neverAppearedBefore = false
            presenter.fetchAllBooks()
        }
    }
    
    //MARK: - Configuration
    private func registerTableViewCells() {
        tableView.register(UINib(nibName: String(describing: BookTableViewCell.self), bundle: Bundle(for: BookTableViewCell.self)), forCellReuseIdentifier: BookTableViewCell.identifier)
    }
    
    fileprivate func configure(using presenter: BookListPresenter) {
        self.presenter = presenter
        presenter.attach(view: self)
    }
}

//MARK: - UITableViewDelegate & DataSource
extension BookListViewController : UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return books.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard
            let cell = tableView.dequeueReusableCell(withIdentifier: BookTableViewCell.identifier, for: indexPath) as? BookTableViewCell
        else {
            fatalError("Couldn't dequeue the table cell, make sure you're using correct identifiers and the cell is properly register")
        }
                
        let book = books[indexPath.row]
        cell.configure(with: BookTableViewCellData(from: book))
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let book = self.books[indexPath.row]
        presenter.selectBook(book: book)
    }
    
}

//MARK: - BookListView conformance
extension BookListViewController : BookListView {
    func update(using books: [Book]) {
        self.books = books
        self.reloadData()
    }
    
    func configureView(using config: BookListViewConfig) {
        title = config.title
    }
    
    func reloadData() {
        self.tableView.reloadData()
    }
    
    func setCentralIndicatorVisibility(visible: Bool) {
        if visible {
            self.view.addSubview(centralIndicatorView)
            centralIndicatorView.frame = tableView.frame
            centralIndicatorView.startIndicatingProgress()
        } else {
            centralIndicatorView.removeFromSuperview()
            centralIndicatorView.stopIndicatingProgress()
        }
    }
    
}

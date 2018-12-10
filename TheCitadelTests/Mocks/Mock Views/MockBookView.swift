//
//  MockBookView.swift
//  TheCitadelTests
//
//  Created by Mateusz Popiało on 09/12/2018.
//  Copyright © 2018 Mateusz Popiało. All rights reserved.
//

import Foundation

@testable import TheCitadel

class MockBookView : BookListView {
    
    var title : String = ""
    
    var books : [Book] = []
    
    var isCentralIndicatorVisible : Bool = false
    
    var presenter : BookListPresenter!
    
    init(with presenter: BookListPresenter) {
        self.presenter = presenter
        presenter.attach(view: self)
    }

    func configureView(using config: BookListViewConfig) {
        self.title = config.title
    }
    
    func update(using books: [Book]) {
        self.books = books
    }
    
    func setCentralIndicatorVisibility(visible: Bool) {
        isCentralIndicatorVisible = visible
    }
    
    //MARK: - Actions
    func selectBook(book: Book) {
        presenter.selectBook(book: book)
    }
}

//
//  BookTableViewCell.swift
//  TheCitadel
//
//  Created by Mateusz Popiało on 07/12/2018.
//  Copyright © 2018 Mateusz Popiało. All rights reserved.
//

import UIKit

//MARK: - Cell data
struct BookTableViewCellData {
    var title : String
    var authors: String
    var description : String
    var containsCharacters: Bool
}

extension BookTableViewCellData {
    
    init(from book: Book) {
        title = book.getMainDescriptor()
        authors = book.getAuthors()
        description = book.getMiscDescriptor()
        containsCharacters = book.characters.count > 0
    }
}

final class BookTableViewCell: UITableViewCell {
    
    static let identifier = "BookTableViewCellIdentifier"

    //MARK: - Interface builder outlets
    @IBOutlet weak var titleLabel : UILabel!
    
    @IBOutlet weak var authorLabel: UILabel!
    
    @IBOutlet weak var descLabel : UILabel!
    
    //MARK: - Configuration
    
    func configure(with data: BookTableViewCellData) {
        titleLabel.text = data.title
        authorLabel.text = data.authors
        descLabel.text = data.description
        
        if data.containsCharacters {
            self.accessoryType = .disclosureIndicator
        } else {
            self.accessoryType = .none
        }
    }
    
}

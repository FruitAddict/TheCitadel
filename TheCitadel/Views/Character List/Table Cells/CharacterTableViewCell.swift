//
//  CharacterTableViewCell.swift
//  TheCitadel
//
//  Created by Mateusz Popiało on 06/12/2018.
//  Copyright © 2018 Mateusz Popiało. All rights reserved.
//

import UIKit

final class CharacterTableViewCell: UITableViewCell {
    
    static let identifier = "CharacterTableViewCellIdentifier"

    //MARK: - IBOutlets
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var descriptionLabel: UILabel!
    
    @IBOutlet weak var tombstoneImageContainer: UIView!
    
    @IBOutlet weak var tombstoneImage: UIImageView! {
        didSet {
            tombstoneImage.image = UIImage.tombstone?.resize(targetSize: .regularIconSize)
        }
    }
    
    //MARK: - Configuration
    func configure(with data: CharacterTableViewCellData) {
        titleLabel.text = data.mainDsc
        tombstoneImageContainer.isHidden = data.isAlive
        
        if data.miscDsc.isEmpty {
            descriptionLabel.isHidden = true
        } else {
            descriptionLabel.isHidden = false
            descriptionLabel.text = data.miscDsc
        }
    }
}

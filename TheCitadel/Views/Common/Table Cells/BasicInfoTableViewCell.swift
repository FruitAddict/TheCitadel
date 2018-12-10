//
//  BasicInfoTableViewCell.swift
//  TheCitadel
//
//  Created by Mateusz Popiało on 07/12/2018.
//  Copyright © 2018 Mateusz Popiało. All rights reserved.
//

import UIKit

//MARK: - View model
struct BasicInfoTableViewCellData {
    var titleText : String
    var infoText : String

}

final class BasicInfoTableViewCell: UITableViewCell {
    
    static let identifier = "BasicInfoTableViewCellIdentifier"

    //MARK: - IBOutlets
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var infoLabel: UILabel!
    
    //MARK: - Configuration
    func configure(with data: BasicInfoTableViewCellData) {
        if data.titleText.isEmpty {
             titleLabel.isHidden = true
        } else {
            titleLabel.isHidden = false
            titleLabel.text = "\(data.titleText):"
        }
        
        if data.infoText.isEmpty {
            infoLabel.isHidden = true
        } else {
            infoLabel.isHidden = false
            infoLabel.text = data.infoText
        }
    }
}

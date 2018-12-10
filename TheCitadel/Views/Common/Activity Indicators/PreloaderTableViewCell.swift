//
//  PreloaderTableViewCell.swift
//  TheCitadel
//
//  Created by Mateusz Popiało on 07/12/2018.
//  Copyright © 2018 Mateusz Popiało. All rights reserved.
//

import UIKit

final class PreloaderTableViewCell: UITableViewCell {

    static let identifier = "PreloaderTableViewCellIdentifier"
    
    //MARK: - IBOutlets
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView! {
        didSet {
            activityIndicator.color = UIColor.appColor
        }
    }
    
    //MARK: - Indicator
    func startIndicatingProgress() {
        activityIndicator.startAnimating()
    }
    
    func stopIndicatingProgress() {
        activityIndicator.stopAnimating()
    }
}

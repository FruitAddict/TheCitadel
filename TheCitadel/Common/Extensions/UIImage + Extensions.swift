//
//  UIImage + Extensions.swift
//  TheCitadel
//
//  Created by Mateusz Popiało on 05/12/2018.
//  Copyright © 2018 Mateusz Popiało. All rights reserved.
//

import UIKit

extension UIImage {
    
    static let swordIcon = UIImage(named: "sword")
    static let bookIcon = UIImage(named: "book")
    static let moreIcon = UIImage(named: "more")
    static let tombstone = UIImage(named: "cross")
    
    func resize(targetSize: CGSize) -> UIImage {
        return UIGraphicsImageRenderer(size:targetSize).image { _ in
            self.draw(in: CGRect(origin: .zero, size: targetSize))
        }
    }
    
}

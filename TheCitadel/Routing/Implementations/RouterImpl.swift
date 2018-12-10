//
//  RouterImpl.swift
//  TheCitadel
//
//  Created by Mateusz Popiało on 06/12/2018.
//  Copyright © 2018 Mateusz Popiało. All rights reserved.
//

import UIKit

final class RouterImpl : Router {
    
    weak var base : TheCitadelNavigationController?
    
    required init(base : TheCitadelNavigationController) {
        self.base = base
    }
    
    func transition(to destination: Destination) {
        let view = destination.create(with: self)
        
        switch destination.presentationMode {
        case .push:
            self.base?.pushViewController(view, animated: true)

        case .present:
            self.base?.present(view, animated: true, completion: nil)
        }
        
    }
    
    func open(url: URL) {
        if UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
}

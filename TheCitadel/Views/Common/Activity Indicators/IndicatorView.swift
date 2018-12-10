//
//  IndicatorView.swift
//  TheCitadel
//
//  Created by Mateusz Popiało on 06/12/2018.
//  Copyright © 2018 Mateusz Popiało. All rights reserved.
//

import UIKit

final class IndicatorView: UIView {
    
    private var view : UIView!

    //MARK: - Outlets
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView! {
        didSet {
            activityIndicator.color = UIColor.appColor
            activityIndicator.alpha = 0
        }
    }
    
    //MARK: - Initialization
    override init(frame: CGRect) {
        super.init(frame: frame)
        nibSetup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        nibSetup()
    }
    
    private func nibSetup() {
        view = loadViewFromNib()
        view.frame = self.frame
        addSubview(view)
    }
    
    private func loadViewFromNib() -> UIView {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: String(describing: type(of: self)), bundle: bundle)
        let nibView = nib.instantiate(withOwner: self, options: nil).first as! UIView
        return nibView
    }
    
    //MARK: - Indicator
    func startIndicatingProgress() {
        activityIndicator.startAnimating()
        UIView.animate(withDuration: 0.1) {
            self.activityIndicator.alpha = 1.0
        }
    }
    
    func stopIndicatingProgress() {
        activityIndicator.stopAnimating()
        activityIndicator.alpha = 0
    }
    
}

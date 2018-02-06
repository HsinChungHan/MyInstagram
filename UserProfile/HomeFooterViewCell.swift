//
//  HomeFooterViewCell.swift
//  Instagram
//
//  Created by 辛忠翰 on 26/01/18.
//  Copyright © 2018 辛忠翰. All rights reserved.
//

import Foundation
import UIKit
class HomeFooterCell: BasicCell {
    
    let spinnerView: UIActivityIndicatorView = {
        let spinner = UIActivityIndicatorView()
        return spinner
    }()
    
    override func setupViews() {
        addSubview(spinnerView)
        spinnerView.center = self.center
    }
    
    
}

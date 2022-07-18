//
//  AuthorImage.swift
//  Motivator
//
//  Created by Timothey Urbanovich on 18/07/2022.
//

import Foundation
import UIKit

class AuthorImage: UIImageView {
    
    func setImageView() {
        self.layer.cornerRadius = 15
        self.clipsToBounds = true
        
        addGrayLayer()
    }
    
    func addGrayLayer() {
        let grayLayer = CALayer()
        grayLayer.frame = bounds
        grayLayer.compositingFilter = "colorBlendMode"
        grayLayer.backgroundColor = UIColor(red: 0.2, green: 0.2, blue: 0.2, alpha: 1.0).cgColor
        layer.addSublayer(grayLayer)
    }
}

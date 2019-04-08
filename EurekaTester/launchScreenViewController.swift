//
//  launchScreenViewController.swift
//  Running2WinGroupTimer
//
//  Created by Ian Fitzgerald on 4/4/19.
//  Copyright © 2019 Ian Fitzgerald. All rights reserved.
//

import Foundation
import UIKit

class launchScreenViewController: UIView{
    
    var gradientLayer: CAGradientLayer!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.createGradientLayer()
    }
    
    
    
    
    func createGradientLayer() {
        gradientLayer = CAGradientLayer()
        gradientLayer.frame = self.bounds
        gradientLayer.colors = [Colors.stopColor.cgColor, Colors.pauseColor.cgColor]
        self.layer.addSublayer(gradientLayer)
    }
    
    
    
    
    
    
    
}

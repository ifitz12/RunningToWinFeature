//
//  FormButtons.swift
//  Running2WinGroupTimer
//
//  Created by Ian Fitzgerald on 2/15/19.
//  Copyright © 2019 Ian Fitzgerald. All rights reserved.
//

import Foundation
import UIKit

//class
//
//func createButtons() -> [UIButton]{
//    
//    let title = UIButton(frame: CGRect(x: 5, y: 5, width: 100, height: 20))
//    let start = UIButton(frame: CGRect(x: 250, y: 10, width: 80, height: 25))
//    let split = UIButton(frame: CGRect(x: 250, y: 45, width: 80, height: 25))
//    let reset = UIButton(frame: CGRect(x:0 , y: 0, width: 100, height: 48))
//    let splitData = UIButton(frame: CGRect(x:275 , y: 0, width: 100, height: 48))
//    
//    //Setting up positions for animations
//    title.center.x -= view.bounds.width
//    start.center.x += view.bounds.width
//    split.center.x += view.bounds.width
//    
//    start.backgroundColor = .green
//    start.setTitle("GO", for: .normal)
//    start.setTitleColor(.black, for: .normal)
//    start.titleLabel?.font = .systemFont(ofSize: 12)
//    start.addTarget(self, action: #selector(startAction), for: .touchUpInside)
//    
//    split.backgroundColor = .blue
//    split.setTitle("Split", for: .normal)
//    split.titleLabel?.font = .systemFont(ofSize: 12)
//    split.addTarget(self, action: #selector(splitAction), for: .touchUpInside)
//    
//    reset.setTitle("RESET", for: .normal)
//    reset.addTarget(self, action: #selector(resetAction), for: .touchUpInside)
//    reset.layer.borderWidth = 1.0
//    reset.layer.borderColor = UIColor.black.cgColor
//    
//    splitData.setTitle("Data", for: .normal)
//    splitData.layer.borderWidth = 1.0
//    splitData.layer.borderColor = UIColor.black.cgColor
//    splitData.addTarget(self, action: #selector(self.dataAction), for: .touchUpInside)
//    
//    title.backgroundColor = .orange
//    title.setTitle("", for: .normal)
//    title.layer.masksToBounds = false
//    title.layer.shadowColor = UIColor.black.cgColor
//    title.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
//    title.layer.shadowOpacity = 0.5
//    title.setTitleColor(.black, for: .normal)
//    
//    return [start, split, reset, splitData, title]
//    
//}

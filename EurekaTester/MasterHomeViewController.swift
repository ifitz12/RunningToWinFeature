//
//  MasterHomeViewController.swift
//  EurekaTester
//
//  Created by Ian Fitzgerald on 11/6/18.
//  Copyright © 2018 Ian Fitzgerald. All rights reserved.
//

import Foundation
import UIKit


//protocol homeViewDelegate: class {
//
//    func editPressed(sender: UIBarButtonItem)
//
//}


class MasterHomeViewController: UIViewController {

    let alerts: AlertsViewController = AlertsViewController()
    
    //var delegate: homeViewDelegate?

    @IBOutlet weak var editButton: UIBarButtonItem!
    
    
    convenience init() {
        self.init(nibName:nil, bundle:nil)
        
//        editButton = UIBarButtonItem()
//        editButton.target = self
//        editButton.action = #selector(sendSignal(button:))
    }
    
    func setButton(){
//        editButton.target? = self
//        editButton.action = #selector(sendSignal(button:))
//        
    }
//    
// @objc func sendSignal(button: UIBarButtonItem){
//        print("dang")
//        print(button)
//    
//        self.delegate?.editPressed(sender: button)
//    }
//    
    @IBAction func newTeam(_ sender: UIButton) {
        self.viewDidAppear(true)
        self.present(self.alerts.showNewTeamDialog(), animated: true, completion: nil)
        
    }
    
    
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
      
    }
    

    
        override func viewDidLoad() {
        super.viewDidLoad()
            print("heyyyyyy")
//            editButton.target = self
//            editButton.action = #selector(sendSignal(button:))
//
    }
    

}

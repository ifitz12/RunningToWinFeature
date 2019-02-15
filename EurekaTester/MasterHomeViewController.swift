//
//  MasterHomeViewController.swift
//  EurekaTester
//
//  Created by Ian Fitzgerald on 11/6/18.
//  Copyright © 2018 Ian Fitzgerald. All rights reserved.
//

import Foundation
import UIKit
import Eureka

class MasterHomeViewController: UIViewController {

    let alerts: AlertsViewController = AlertsViewController()
   

    @IBOutlet weak var editButton: UIBarButtonItem!
    
    
    convenience init() {
        self.init(nibName:nil, bundle:nil)

    }

    @IBAction func newTeam(_ sender: UIButton) {
        self.viewDidAppear(true)
        self.present(self.alerts.showNewTeamDialog(), animated: true, completion: nil)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
      
    }

    

}

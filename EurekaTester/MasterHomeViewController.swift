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

class MasterHomeViewController: UIViewController, UINavigationBarDelegate {

    let alerts: AlertsViewController = AlertsViewController()
   
   

    @IBAction func editButton(_ sender: UIBarButtonItem) {
        
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "editSender"), object: nil, userInfo: [sender: (Any).self])
        
    }
    
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
   
    
    override func viewDidLoad() {
        print("HOME LOADED")
        let customBackButton = UIBarButtonItem(title: "Teams", style: .plain, target: self, action: #selector(self.presentWarning))
       //let customBackButton = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(self.presentWarning))
     self.navigationItem.setLeftBarButton(customBackButton, animated: true)
        
        //NotificationCenter.default.post(name: NSNotification.Name(rawValue: "editSender"), object: nil, userInfo: nil)
        alerts.initialize()
    }
    
    
    @objc func presentWarning(){
        let alert = UIAlertController(title: "Warning", message: "Returning to team selection will clear all team timers, continue?", preferredStyle: .alert)
        
        let confirm = UIAlertAction(title: "Confirm", style: .destructive) { (_) in
             NotificationCenter.default.post(name: NSNotification.Name(rawValue: "resetForm"), object: nil, userInfo: nil)
            
            self.navigationController?.popViewController(animated: true)
        }
            
      
        
        let cancel = UIAlertAction(title: "Cancel", style: .default, handler: nil)
        
        alert.addAction(cancel)
        alert.addAction(confirm)
       
        self.present(alert, animated: true)
    }

}

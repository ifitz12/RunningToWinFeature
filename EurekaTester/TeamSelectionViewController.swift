//
//  TeamSelectionViewController.swift
//  Running2WinGroupTimer
//
//  Created by Ian Fitzgerald on 4/7/19.
//  Copyright © 2019 Ian Fitzgerald. All rights reserved.
//

import Foundation
import UIKit
import Eureka

class TeamSelectionViewController: UIViewController{
  
    
    var teams: [String] = []
    var members: [String: [String]] = [:]
    
    
   
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.getTeamList), name: NSNotification.Name(rawValue: "sendTeams"), object: nil)
       
    }
    
    
    ///Delegate methods
    @objc func getTeamList(_ n: Notification) {
        //self.teams = list
       // let API = n.object as! APIEngine
        print("IN CONTROLLER")
       let teams = n.userInfo!["teams"] as! [String]
        let members = n.object as! [String:[String]]
        print(members)
    
       //let mems =  API.requestTeamMembers(teamName: teams[0], completion: nil)
        

    }
    
    func getRunnersByTeam(members: [String]) {
    
        for t in teams{
            self.members[t] = members
        }
        
    }
    
    
    
    
    
    
    
}

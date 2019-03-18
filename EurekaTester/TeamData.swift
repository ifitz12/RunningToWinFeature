//
//  TeamData.swift
//  Running2WinGroupTimer
//
//  Created by Ian Fitzgerald on 3/7/19.
//  Copyright © 2019 Ian Fitzgerald. All rights reserved.
//

import Foundation
import UIKit
import Eureka


class TeamData{
    
   
    var sec: Section = Section()
    
    
    func getSection() -> Section{
        
        return sec
    }
    
    func createRunnerDataCells(forTeam: String, rowTag: String, dataSet: TeamHandler){
        
        let data = dataSet.runnnerHandlers[forTeam]?.runners.masterRunnerList
        var runners: [String: [String]] = [:]
        var keys:[String] = []
        
        
        for member in data![forTeam]!{
            let name = member.firstName.capitalized + " " + member.lastName.capitalized
            runners[name] = member.time.splits
        }
        
        keys = Array(runners.keys)
        
        let section = PushRow<String>() {
            $0.title = keys[0]
            $0.hidden = Condition(stringLiteral: "$\(rowTag) != 'Runner Data'")
            $0.optionsProvider = .lazy({ (form, completion) in
                let activityView = UIActivityIndicatorView(style: .gray)
                form.tableView.backgroundView = activityView
                activityView.startAnimating()
                DispatchQueue.main.asyncAfter(deadline: .now() + 3, execute: {
                    form.tableView.backgroundView = nil
                    completion(["hey", "wow", "cool"])
                })
            })
            }
            .onPresent { from, to in
                to.sectionKeyForValue = { option -> String in
                    switch option {
                    case "hey", "wow": return "People"
                    case "cool": return "Animals"
                    
                    default: return ""
                    }
                }
        }
            <<< PushRow<String>() {
            $0.title = keys[1]
            $0.hidden = Condition(stringLiteral: "$\(rowTag) != 'Runner Data'")
                
                
        }
            <<< PushRow<String>() {
            $0.title = keys[2]
            $0.hidden = Condition(stringLiteral: "$\(rowTag) != 'Runner Data'")
                
                
        }
            <<< PushRow<String>() {
            $0.title = keys[3]
            $0.hidden = Condition(stringLiteral: "$\(rowTag) != 'Runner Data'")
                
        }
      
        
      sec = section
    }
    
    
    
    func storeData(){
        
        
        
        
    }
    
    
    
    
    
    
    
    
}

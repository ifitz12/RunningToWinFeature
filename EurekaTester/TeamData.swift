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
        print("DATA")
        let team = forTeam.lowercased()
        var runners: [String: [String]] = [:]
        var keys:[String] = []
        
        for member in data![team]!{
            let name = member.firstName.capitalized + " " + member.lastName.capitalized
            runners[name] = member.time.splits
        }
        
        keys = Array(runners.keys)
        
        let section =  DoublePickerRow<String, Int>() {
            $0.title = "Relay"
            $0.firstOptions = { return ["a", "b", "c"]}
            $0.secondOptions = { _ in return [1, 2, 3]}
             $0.hidden = Condition(stringLiteral: "$\(rowTag) != 'Runner Data'")
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

//
//  loginViewController.swift
//  Running2WinGroupTimer
//
//  Created by Ian Fitzgerald on 4/4/19.
//  Copyright © 2019 Ian Fitzgerald. All rights reserved.
//

import Foundation
import UIKit
import Eureka


protocol loginDelegate: class{
    
    func getTeamList()
    func getRunnersByTeam(members: [String])
    
}


class loginViewController: UIViewController, APIEngineDelegate{
    
    @IBOutlet weak var userNameField: UITextField!
    
    @IBOutlet weak var passwordField: UITextField!
    
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var backgroundImage: UIImageView!
    
    var gradientLayer: CAGradientLayer!
    var API: APIEngine = APIEngine()
    var activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView()
    var teamMembersInSession: [String: [String]] = [:]{
        didSet{
            self.shouldPost(list: self.teamList)
        }
    }
    var teamList: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        API.delegate = self
        setUpFields()
        setupLoginButton()
        createBackgroundImage()
        UIView.animate(withDuration: 1.2, animations: {
            self.passwordField.alpha = 1.0
            self.userNameField.alpha = 1.0
            self.loginButton.alpha = 1.0
            self.loginButton.center = CGPoint(x: 188.0, y: 474.5)
            self.passwordField.center = CGPoint(x: 187.0, y: 394.0)
            self.userNameField.center = CGPoint(x: 187.0, y: 328.0)
            
        })
    }
    
   
    func createBackgroundImage(){
        
        backgroundImage.image = UIImage(named: "Image")
        self.view.bringSubviewToFront(userNameField)
        self.view.bringSubviewToFront(passwordField)
        self.view.bringSubviewToFront(loginButton)
        userNameField.alpha = 0.0
        passwordField.alpha = 0.0
        loginButton.alpha = 0.0
        loginButton.center = CGPoint(x: 188.0, y: 504.5)
        passwordField.center = CGPoint(x: 187.0, y: 424.0)
        userNameField.center = CGPoint(x: 187.0, y: 358.0)
        
    }
    

    
    private func setUpFields(){
    
        userNameField.backgroundColor = .clear
        passwordField.backgroundColor = .clear
        
        setBoxStyle(field: userNameField, color: UIColor.black)
        setBoxStyle(field: passwordField, color: UIColor.black)
        
      
    
    }
    
    
    private func setupLoginButton(){
        loginButton.addTarget(self, action: #selector(self.loginRequest), for: .touchUpInside)
        loginButton.backgroundColor = Colors.loginColor
        loginButton.setTitleColor(.black, for: .normal)
        loginButton.titleLabel?.font = .systemFont(ofSize: 14)
        loginButton.layer.cornerRadius = 15
        loginButton.clipsToBounds = true
        
        
       
    }
    
    
    @objc func loginRequest(){
        UIButton.animate(withDuration: 0.1,
                         animations: {
                            self.loginButton.transform = CGAffineTransform(scaleX: 0.85, y: 0.85)
        },
                         completion: { finish in
                            UIButton.animate(withDuration: 0.2, animations: {
                                self.loginButton.transform = CGAffineTransform.identity
                            })
        })
        activityIndicator = UIActivityIndicatorView(style: .whiteLarge)
        
        
        view.addSubview(activityIndicator)
        view.bringSubviewToFront(activityIndicator)
        activityIndicator.frame = view.bounds
        activityIndicator.layer.backgroundColor = UIColor(white: 0.1, alpha: 0.3).cgColor
        activityIndicator.startAnimating()
      
      API.login["userNameOrEmail"] = userNameField.text
      API.login["password"] = passwordField.text
      API.request()
      
    }
    
    internal func successLogin() {
        print("Success")
       API.requestTeamList()
        //activityIndicator.removeFromSuperview()
        if let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "MasterNavigationController") as? UINavigationController{
            
            self.present(vc, animated: true, completion: {
                
                self.pullRunnerData()


            })
        }
        
       // NotificationCenter.default.post(name: NSNotification.Name(rawValue: "sendTeams"), object: API, userInfo: nil)
       //self.navigationController?.popViewController(animated: true)
       // self.navigationController?.popToViewController(vc!, animated: true)
       // print(self.isBeingPresented)
        //activityIndicator.removeFromSuperview()
        //self.show()
        
    }
    
    internal func failureLogin(error: Bool) {
        print("failue!!!")
        if(!error){
        setBoxStyle(field: passwordField, color: UIColor.red)
        setBoxStyle(field: userNameField, color: UIColor.red)
        }
    
        activityIndicator.removeFromSuperview()
    }
    
    
    func pullRunnerData(){
        
        self.teamList = self.API.getTeamList()
        
        for team in teamList{
            
            self.API.requestTeamMembers(teamName: team, completion: {
                
                self.set(team: team, completion: { response in
                    self.teamMembersInSession[team] = response[team]
                    
                    return ()
                })
                
            })
        }
        
    }
    
    //Helper function for pullRunnerData that guarentees all of the teams/members
    //have been pulled
    func shouldPost(list: [String]){
        if(list.count == teamMembersInSession.count){
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "sendTeams"), object: self.teamMembersInSession, userInfo: ["teams": list])
            NotificationCenter.default.addObserver(self, selector: #selector(self.removeSpinner), name: NSNotification.Name(rawValue: "stopSpinner"), object: nil)
            
        }
     
     
    }
    
    func set(team: String, completion: ([String:[String]]) -> ()? ){
        var hold: [String: [String]] = [:]
        hold[team] = self.API.getTeamMembers(team: team)
        completion(hold)
    }
    
    private func animateFields(){
        let animationPassword = CABasicAnimation(keyPath: "position")
        animationPassword.duration = 0.07
        animationPassword.repeatCount = 4
        animationPassword.autoreverses = true
        animationPassword.fromValue = NSValue(cgPoint: CGPoint(x: passwordField.center.x - 10, y: passwordField.center.y))
        animationPassword.toValue = NSValue(cgPoint: CGPoint(x: passwordField.center.x + 10, y: passwordField.center.y))


        let animationUsername = CABasicAnimation(keyPath: "position")
        animationUsername.duration = 0.07
        animationUsername.repeatCount = 4
        animationUsername.autoreverses = true
        animationUsername.fromValue = NSValue(cgPoint: CGPoint(x: userNameField.center.x - 10, y: userNameField.center.y))
        animationPassword.toValue = NSValue(cgPoint: CGPoint(x: userNameField.center.x + 10, y: userNameField.center.y))

        passwordField.layer.add(animationPassword, forKey: "position")
        userNameField.layer.add(animationUsername, forKey: "position")
        
    }
    
    private func setBoxStyle(field: UITextField, color: UIColor){
        
        let bottomLine = CALayer()
        bottomLine.frame = CGRect(x: 0.0, y: field.frame.height - 1, width: field.frame.width, height: 1.0)
        bottomLine.backgroundColor = color.cgColor
        field.borderStyle = UITextField.BorderStyle.none
        field.layer.addSublayer(bottomLine)
        
        
    }
    
    @objc func removeSpinner(){
        activityIndicator.removeFromSuperview()
        
        
    }
    
    
    
}

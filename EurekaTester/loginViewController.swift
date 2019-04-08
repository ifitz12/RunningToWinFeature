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



class loginViewController: UIViewController, APIEngineDelegate{
    
    @IBOutlet weak var userNameField: UITextField!
    
    @IBOutlet weak var passwordField: UITextField!
    
    @IBOutlet weak var loginButton: UIButton!
    
    var gradientLayer: CAGradientLayer!
    var API: APIEngine = APIEngine()
    var activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        API.delegate = self
        setUpFields()
        setupLoginButton()
        createGradientLayer()
    }
 
    
    
    func createGradientLayer() {
        gradientLayer = CAGradientLayer()
        gradientLayer.frame = self.view.bounds
        gradientLayer.colors = [Colors.stopColor.cgColor, Colors.pauseColor.cgColor]
        gradientLayer.opacity = 0.8
        self.view.layer.insertSublayer(gradientLayer, at: 0)
       
        
    }
    
    func setUpFields(){
    
        userNameField.backgroundColor = .clear
        passwordField.backgroundColor = .clear
        
        setBoxStyle(field: userNameField, color: UIColor.black)
        setBoxStyle(field: passwordField, color: UIColor.black)
        
      
    
    }
    
    
    func setupLoginButton(){
        loginButton.addTarget(self, action: #selector(self.loginRequest), for: .touchUpInside)
        loginButton.backgroundColor = .green
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
        activityIndicator.frame = view.bounds
        activityIndicator.layer.backgroundColor = UIColor(white: 0.1, alpha: 0.3).cgColor
        activityIndicator.startAnimating()
        
    
        
      API.login["userNameOrEmail"] = userNameField.text
      API.login["password"] = passwordField.text
      API.request()
      
       
    }
    
    func successLogin() {
        print("Success")
        activityIndicator.removeFromSuperview()
        if let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "TeamSelectionVC") as? TeamSelectionViewController{
            self.present(vc, animated: true, completion: nil)
        }
       //self.navigationController?.popViewController(animated: true)
       // self.navigationController?.popToViewController(vc!, animated: true)
       // print(self.isBeingPresented)
        //activityIndicator.removeFromSuperview()
    }
    
    func failureLogin() {
        print("failue!!!")
       
        setBoxStyle(field: passwordField, color: UIColor.red)
         setBoxStyle(field: userNameField, color: UIColor.red)
      //  passwordField.layer.borderColor = UIColor.red.cgColor
        //userNameField.layer.borderColor = UIColor.red.cgColor
        
        
        activityIndicator.removeFromSuperview()
    }
    
    
    func animateFields(){
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
    
    func setBoxStyle(field: UITextField, color: UIColor){
        
        let bottomLine = CALayer()
        bottomLine.frame = CGRect(x: 0.0, y: field.frame.height - 1, width: field.frame.width, height: 1.0)
        bottomLine.backgroundColor = color.cgColor
        field.borderStyle = UITextField.BorderStyle.none
        field.layer.addSublayer(bottomLine)
        
        
    }
    
    
    
}

//
//  LoginViewController.swift
//  RxFlowDemo
//
//  Created by park kevin on 2022/01/28.
//

import Foundation
import UIKit
import RxFlow
import RxSwift
import RxCocoa


class LoginViewController:UIViewController,Stepper{
    var steps: PublishRelay<Step> = PublishRelay<Step>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let loginButton = UIButton()
        loginButton.setTitle("Login", for: .normal)
        loginButton.layer.borderColor = UIColor.systemBlue.cgColor
        loginButton.layer.borderWidth = 1
        loginButton.layer.cornerRadius = 3
        loginButton.addTarget(self, action: #selector(loginButtonDidTap), for: .touchUpInside)
        
        view.addSubview(loginButton)
        
        loginButton.frame = CGRect(x: 0, y: 0, width: 100, height: 30)
        loginButton.center = view.center
        
    }
    
    @objc func loginButtonDidTap(){
        self.steps.accept(FlowStep.toGNB)
    }
}

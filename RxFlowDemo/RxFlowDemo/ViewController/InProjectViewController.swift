//
//  InChatViewController.swift
//  RxFlowDemo
//
//  Created by park kevin on 2022/01/28.
//

import Foundation

import RxFlow
import RxCocoa

class InProjectViewController:UIViewController,Stepper{
    let steps = PublishRelay<Step>()
    let label = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = true
    }
    
    @objc func chatElementDidTapped(){
        self.steps.accept(FlowStep.toGNB)
    }
}

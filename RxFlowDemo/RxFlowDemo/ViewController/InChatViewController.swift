//
//  InChatViewController.swift
//  RxFlowDemo
//
//  Created by park kevin on 2022/01/28.
//

import Foundation

import RxFlow
import RxCocoa

class InChatViewController:UIViewController,Stepper{
    let steps = PublishRelay<Step>()
    let label = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        label.frame = CGRect(x: 0,
                          y: 0,
                          width: label.intrinsicContentSize.width,
                          height: label.intrinsicContentSize.height)
        label.textColor = .label
        
        
        view.addSubview(label)
        label.center = view.center
        
        let chatCommentButton = UIButton()
        chatCommentButton.setTitle("comment", for: .normal)
        chatCommentButton.layer.borderColor = UIColor.systemBlue.cgColor
        chatCommentButton.layer.borderWidth = 1
        chatCommentButton.layer.cornerRadius = 3
        chatCommentButton.addTarget(self, action: #selector(chatElementDidTapped), for: .touchUpInside)
        
        view.addSubview(chatCommentButton)
        
        chatCommentButton.frame = CGRect(x: 0, y: 0, width: 100, height: 30)
        chatCommentButton.center = view.center
        chatCommentButton.center.y -= 50
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = true
    }
    
    @objc func chatElementDidTapped(){
        self.steps.accept(FlowStep.toInChatComment(withMessageID: 1234))
    }
}

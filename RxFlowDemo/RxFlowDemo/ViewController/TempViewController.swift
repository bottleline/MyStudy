//
//  TempViewController.swift
//  RxFlowDemo
//
//  Created by park kevin on 2022/01/28.
//

import Foundation
import UIKit

import RxFlow
import RxCocoa

class TempVC:UIViewController,Stepper{
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
        
    }
}

//
//  AppFlow.swift
//  RxFlowDemo
//
//  Created by park kevin on 2022/01/28.
//

import Foundation
import UIKit
import RxFlow
import RxSwift
import RxCocoa

class AppFlow: Flow {
    
    var window:UIWindow
    
    var root: Presentable {
        return self.window
    }

    init(window:UIWindow){
        self.window = window
    }


    func navigate(to step: Step) -> FlowContributors {
        guard let step = step as? FlowStep else { return .none }

        switch step {
        case .toLogin:
            return showLoginWindow()
        case .toGNB:
            return showGNBWindow()
        default:
            return .none
        }
    }

    private func showLoginWindow() -> FlowContributors {
        let loginFlow = LoginFlow()
        Flows.use(loginFlow, when: .created) { (root) in
            self.window.rootViewController = root
        }
        return .one(flowContributor: .contribute(withNextPresentable: loginFlow,
                                                 withNextStepper: OneStepper(withSingleStep: FlowStep.toLogin)))
    }

    private func showGNBWindow() -> FlowContributors {
        let dashBoardFlow = GNBFlow()
        Flows.use(dashBoardFlow, when: .created) { (root) in
            self.window.rootViewController = root
        }
        return .one(flowContributor: .contribute(withNextPresentable: dashBoardFlow,
                                                 withNextStepper: OneStepper(withSingleStep: FlowStep.toGNB)))
    }

}

class AppStepper: Stepper {

    let steps = PublishRelay<Step>()
    private let disposeBag = DisposeBag()

    init() {}

    var initialStep: Step{
        return FlowStep.toLogin
    }
}

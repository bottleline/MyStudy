//
//  LoginFlow.swift
//  RxFlowDemo
//
//  Created by park kevin on 2022/01/28.
//
import Foundation
import RxFlow

class LoginFlow: Flow {

    var root: Presentable {
        return self.rootViewController
    }

    private lazy var rootViewController: UINavigationController = {
        let viewController = UINavigationController()
        return viewController
    }()

    init() {}

    func navigate(to step: Step) -> FlowContributors {
        guard let step = step as? FlowStep else { return .none }
        switch step {
        case .toLogin:
            return self.showLoginWindow()
        case .toGNB:
            return .end(forwardToParentFlowWithStep: FlowStep.toGNB)
        default:
            return .none
        }
    }
    
    private func showLoginWindow() -> FlowContributors {
        let viewController = LoginViewController()
        self.rootViewController.setViewControllers([viewController], animated: false)
        return .one(flowContributor: .contribute(withNext: viewController))
    }
}

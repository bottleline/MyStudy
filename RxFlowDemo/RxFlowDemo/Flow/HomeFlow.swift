//
//  HomeFlow.swift
//  RxFlowDemo
//
//  Created by park kevin on 2022/01/28.
//

import Foundation
import RxFlow

enum HomeType:String{
    case channel = "Channel"
    case project = "Project"
}

class HomeFlow: Flow {

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
        case .toHome:
            return self.navigateToHome()
        case .toLogin:
            return .end(forwardToParentFlowWithStep: FlowStep.toLogin)
        default:
            return .none
        }
    }
    
    private func navigateToHome() -> FlowContributors {
        print(#function)
        let viewController = HomeViewController()//HomeViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: [:])
        
        self.rootViewController.pushViewController(viewController, animated: true)
        
        let chatListViewController = ListViewController()
        chatListViewController.type = .channel
        
        let projectListViewController = ListViewController()
        projectListViewController.type = .project
        
        let chatFlow = ChatFlow(listViewController:chatListViewController)
        let projectFlow = ProjectFlow(listViewController:projectListViewController)

        Flows.use(chatFlow, projectFlow, when: .created) { chatRoot, projectRoot in
            viewController.pages = [chatRoot, projectRoot]
        }
        
        return .multiple(flowContributors: [.contribute(withNextPresentable: chatFlow,
                                                        withNextStepper: OneStepper(withSingleStep: FlowStep.toChatList),
                                                        allowStepWhenDismissed: true),
                                            .contribute(withNextPresentable: projectFlow,
                                                        withNextStepper: OneStepper(withSingleStep: FlowStep.toProjectList),
                                                        allowStepWhenDismissed: true)])
    }
}

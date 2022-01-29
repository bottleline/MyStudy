//
//  GNBFlow.swift
//  RxFlowDemo
//
//  Created by park kevin on 2022/01/28.
//

import Foundation
import RxFlow

class GNBFlow: Flow {

    var root: Presentable {
        return self.rootViewController
    }

    private lazy var rootViewController = UITabBarController()

    init() {}

    func navigate(to step: Step) -> FlowContributors {
        guard let step = step as? FlowStep else { return .none }
        switch step {
        case .toGNB:
            return self.showGNBWindow()
        case .toLogin:
            return .end(forwardToParentFlowWithStep: FlowStep.toLogin)
        default:
            return .none
        }
    }
    
    private func showGNBWindow() -> FlowContributors {
        
        let homeFlow = HomeFlow()
        let tempFlow1 = TempFlow()
        let tempFlow2 = TempFlow()
        let tempFlow3 = TempFlow()
        let tempFlow4 = TempFlow()

        Flows.use(homeFlow,
                  tempFlow1,
                  tempFlow2,
                  tempFlow3,
                  tempFlow4,
                  when: .ready) { [unowned self] (root1: UINavigationController,
                                                    root2: UINavigationController,
                                                    root3: UINavigationController,
                                                    root4: UINavigationController,
                                                    root5: UINavigationController) in
            
            let tabBarItem1 = UITabBarItem(title: "Home", image: UIImage(systemName: "applelogo"), selectedImage: nil)
            let tabBarItem2 = UITabBarItem(title: "Activity", image: UIImage(systemName: "applelogo"), selectedImage: nil)
            let tabBarItem3 = UITabBarItem(title: "DM", image: UIImage(systemName: "applelogo"), selectedImage: nil)
            let tabBarItem4 = UITabBarItem(title: "Search", image: UIImage(systemName: "applelogo"), selectedImage: nil)
            let tabBarItem5 = UITabBarItem(title: "Profile", image: UIImage(systemName: "applelogo"), selectedImage: nil)
            root1.tabBarItem = tabBarItem1
            root1.title = "Home"
            root2.tabBarItem = tabBarItem2
            root2.title = "Activity"
            root3.tabBarItem = tabBarItem3
            root3.title = "DM"
            root4.tabBarItem = tabBarItem4
            root4.title = "Search"
            root5.tabBarItem = tabBarItem5
            root5.title = "Profile"

            self.rootViewController.setViewControllers([root1, root2, root3,root4,root5], animated: false)
        }
        
        return .multiple(flowContributors: [.contribute(withNextPresentable: homeFlow,
                                                        withNextStepper:  OneStepper(withSingleStep: FlowStep.toHome)),
                                            .contribute(withNextPresentable: tempFlow1,
                                                        withNextStepper: OneStepper(withSingleStep: FlowStep.toTemp(name: "Activity"))),
                                            .contribute(withNextPresentable: tempFlow2,
                                                        withNextStepper: OneStepper(withSingleStep: FlowStep.toTemp(name: "DM"))),
                                            .contribute(withNextPresentable: tempFlow3,
                                                        withNextStepper: OneStepper(withSingleStep: FlowStep.toTemp(name: "Search"))),
                                            .contribute(withNextPresentable: tempFlow4,
                                                        withNextStepper: OneStepper(withSingleStep: FlowStep.toTemp(name: "Profile"))),
                                            ])
    }
}

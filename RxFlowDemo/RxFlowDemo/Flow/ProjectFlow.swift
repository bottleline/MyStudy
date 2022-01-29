//
//  ProjectFlow.swift
//  RxFlowDemo
//
//  Created by park kevin on 2022/01/28.
//

import Foundation
import RxFlow
import RxCocoa
import RxSwift

class ProjectFlow: Flow,Stepper {
    var steps: PublishRelay<Step> = PublishRelay<Step>()
    
    
    var root: Presentable {
        return self.rootViewController
    }
    
    private var rootViewController: ListViewController
    
    init(listViewController:ListViewController) {
        rootViewController = listViewController
    }
    
    func navigate(to step: Step) -> FlowContributors {
        guard let step = step as? FlowStep else { return .none }
        switch step {
        case .toProjectList:
            return self.navigateToProjectList()
        case .toInProject(let projectID):
            return self.navigateToInProject(projectID:projectID)
        case .toLogin:
            return .end(forwardToParentFlowWithStep: FlowStep.toLogin)
        default:
            return .none
        }
    }
    
    private func navigateToProjectList() -> FlowContributors {
        return .one(flowContributor: .contribute(withNext: rootViewController))
    }
    
    private func navigateToInProject(projectID:Int) -> FlowContributors {
        let viewController = InProjectViewController()
        viewController.title = "This is Project-\(projectID + 1)"
        
        self.rootViewController.navigationController?.pushViewController(viewController, animated: true)
        return .one(flowContributor: .contribute(withNext: viewController))
    }
    
    
}




class TaskFlowStepper:Stepper{
    var steps = PublishRelay<Step>()
}

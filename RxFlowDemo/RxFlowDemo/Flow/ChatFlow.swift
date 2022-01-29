//
//  ChatFlow.swift
//  RxFlowDemo
//
//  Created by park kevin on 2022/01/28.
//

import Foundation
import RxFlow
import RxCocoa
import RxSwift

class ChatFlow: Flow,Stepper {
    var steps: PublishRelay<Step> = PublishRelay<Step>()

    var root: Presentable {
        return self.rootViewController
    }

    private let rootViewController: ListViewController

    init(listViewController:ListViewController) {
        rootViewController = listViewController
    }

    func navigate(to step: Step) -> FlowContributors {
        guard let step = step as? FlowStep else { return .none }
        switch step {
        case .toChatList:
            return self.navigateToChatList()
        case .toInChat(let channelID):
            return self.navigateToInChat(channelID:channelID)
        case .toInChatComment(let messageID):
            return self.modalInChatComment(messageID:messageID)
        case .toLogin:
            return .end(forwardToParentFlowWithStep: FlowStep.toLogin)
        default:
            return .none
        }
    }
    
    private func navigateToChatList() -> FlowContributors {
        return .one(flowContributor: .contribute(withNext: rootViewController))
    }
  
    private func navigateToInChat(channelID:Int) -> FlowContributors {
        let viewController = InChatViewController()
        viewController.title = "This is Channel-\(channelID + 1)"

        self.rootViewController.navigationController?.pushViewController(viewController, animated: true)
        return .one(flowContributor: .contribute(withNext: viewController))
    }
    private func modalInChatComment(messageID:Int) -> FlowContributors {

        let viewController = ChatCommentViewController()
        viewController.label.text = "This is Comment Area -\(messageID)"
        viewController.view.backgroundColor = .systemBackground

        self.rootViewController.present(viewController, animated: true, completion: nil)
        return .one(flowContributor: .contribute(withNext: viewController))
    }
    /*
    private func navigateTotoInChatComment(messageID:Int) -> FlowContributors {
        print(#function)
        let viewController = ChatCommentVC()
        viewController.modalPresentationStyle = .fullScreen
        viewController.modalTransitionStyle = .coverVertical
        self.rootViewController.present(viewController, animated: true, completion: nil)
        
        //self.rootViewController.navigationController?.pushViewController(viewController, animated: true)
        return .one(flowContributor: .contribute(withNext: viewController))
    }*/
}


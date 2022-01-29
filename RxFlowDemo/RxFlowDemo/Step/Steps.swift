//
//  Steps.swift
//  RxFlowDemo
//
//  Created by park kevin on 2022/01/28.
//

import Foundation
import RxFlow

enum FlowStep: Step{
    case toLogin
    case toGNB
    
    case toHome
    case toTemp(name:String)
    
    case toChatList
    case toProjectList
    
    case toInChat(withChannelID:Int)
    case toInChatComment(withMessageID:Int)
    
    case toInProject(withProjectID:Int)
}

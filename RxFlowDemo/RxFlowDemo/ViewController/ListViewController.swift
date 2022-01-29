//
//  ListViewController.swift
//  RxFlowDemo
//
//  Created by park kevin on 2022/01/28.
//

import Foundation
import UIKit
import RxFlow
import RxCocoa
import RxSwift

class ListViewController:UINavigationController,Stepper{
    var steps: PublishRelay<Step> = PublishRelay<Step>()
    
    let tableView = UITableView()
    let logoutButton = UIButton()
    var type:HomeType = .channel
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(tableView)
                
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.separatorColor = .systemGray5
        
        tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        tableView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor).isActive = true
        tableView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor).isActive = true

        
        
        logoutButton.setTitle("Logout", for: .normal)
        logoutButton.layer.borderColor = UIColor.systemBlue.cgColor
        logoutButton.layer.borderWidth = 1
        logoutButton.layer.cornerRadius = 3
        logoutButton.addTarget(self, action: #selector(logoutButtonDidTap), for: .touchUpInside)
        
        view.addSubview(logoutButton)
        
        logoutButton.frame = CGRect(x: 0, y: 0, width: 100, height: 30)
        //logoutButton.center.x = view.center.x
        //logoutButton.center.y = view.frame.height - 150
        logoutButton.center = view.center
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        UIView.animate(withDuration: 0.5) {
            self.tableView.alpha = 1.0
        }
    }
    @objc func logoutButtonDidTap(){
        self.steps.accept(FlowStep.toLogin)
    }
}
extension ListViewController:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel!.text = type.rawValue + " \(indexPath.row + 1)"
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        UIView.animate(withDuration: 0.5) {
            self.tableView.alpha = 0.0
        }
        if type == .channel{
            self.steps.accept(FlowStep.toInChat(withChannelID: indexPath.row))
        }else if type == .project{
            print("asdfasdf")
            self.steps.accept(FlowStep.toInProject(withProjectID: indexPath.row))
        }
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
}

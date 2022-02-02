//
//  ViewController.swift
//  TypistDemo
//
//  Created by park kevin on 2022/02/02.
//

import UIKit
import Typist
import SnapKit

class ViewController: UIViewController {
    let tableView = UITableView()
    let textField : UITextField = {
       let textField = UITextField()
        textField.layer.borderWidth = 1
        textField.layer.borderColor = UIColor.systemGray5.cgColor
        textField.placeholder = "This is TextField"
        
        textField.backgroundColor = .black
        return textField
    }()
  
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(tableView)
        view.addSubview(textField)
        
        
        [tableView,textField].forEach{
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        tableView.snp.makeConstraints{
            $0.edges.equalToSuperview()
        }
        
        textField.snp.makeConstraints{
            $0.bottom.left.right.equalToSuperview()
            $0.height.equalTo(50)
        }
    
        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.keyboardDismissMode = .interactive
        
        Typist.shared
            .toolbar(scrollView: tableView)
            .on(event: .willChangeFrame) { [unowned self] options in
                let height = options.endFrame.height
                
                print("current keyboard height : \(height)")
                    UIView.animate(withDuration: 0.5) {
                        self.textField.snp.updateConstraints {c in
                            c.bottom.equalTo(self.view.snp.bottom)
                                .offset(-height)
                        }
                    }
                
            }.on(event: .willHide) { [unowned self] options in
                UIView.animate(withDuration: options.animationDuration,
                               delay: 0,
                               options: UIView.AnimationOptions(curve: options.animationCurve)) {
                    self.textField.snp.updateConstraints {c in
                        c.bottom.equalTo(self.view.snp.bottom)
                    }
                }
                
            }.on(event: .willShow) { [unowned self] options in
                let height = options.endFrame.height
                self.textField.snp.updateConstraints {c in
                    UIView.animate(withDuration: options.animationDuration,
                                   delay: 0,
                                   options: UIView.AnimationOptions(curve: options.animationCurve)) {
                        c.bottom.equalTo(self.view.snp.bottom).offset(-height)
                    }
                    self.tableView.contentOffset.y += height
                }
            }.start()
    }


}

extension ViewController:UITableViewDataSource,UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 100
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text = "\(indexPath.row)"
        return cell
    }
}

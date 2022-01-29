//
//  ViewController.swift
//  RxFlowDemo
//
//  Created by park kevin on 2022/01/28.
//

import UIKit
import RxCocoa
import RxSwift
import RxFlow

class HomeViewController: UIViewController {
    var pages = [UIViewController]()

    private let disposeBag = DisposeBag()
    private var firstVC = UIViewController()


    private lazy var pageViewController: UIPageViewController = {
        let page = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: [:])
        page.view.translatesAutoresizingMaskIntoConstraints = false
        page.delegate = self
        page.dataSource = self
        return page
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        layout()
        
        guard let firstVC = pages.first else { return }
        pageViewController.setViewControllers([firstVC], direction: .forward, animated: false, completion: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = false
        
    }

    private func layout() {
        
        view.addSubview(pageViewController.view)
        addChild(pageViewController)

        NSLayoutConstraint.activate([pageViewController.view.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
                                     pageViewController.view.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
                                     pageViewController.view.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0),
                                     pageViewController.view.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)])
        pageViewController.didMove(toParent: self)
        pageViewController.view.setNeedsLayout()
    }


}

extension HomeViewController: UIPageViewControllerDataSource {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let index = pages.firstIndex(of: viewController), index > 0 else { return nil }
        return pages[index - 1]
    }

    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let index = pages.firstIndex(of: viewController), index < pages.count - 1 else { return nil }
        return pages[index + 1]
    }
}

extension HomeViewController: UIPageViewControllerDelegate {
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        guard completed,
            let currentViewController = pageViewController.viewControllers?.first,
            let index = pages.firstIndex(of: currentViewController) else {
            return
        }
    }
}

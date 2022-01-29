# RxFlow 샘플 프로젝트
## RxFlow 란

- 반응형 [코디네이터 패턴](https://www.raywenderlich.com/books/design-patterns-by-tutorials/v3.0/chapters/23-coordinator-pattern)을 기반으로한 ios 네비게이션 프레임워크

### 네비게이션을 사용할 시

ios 어플리케이션에서 제공하는 네비게이션을 사용할 경우 2가지 선택이 있음

- 스토리보드/세그를 이용하여 구현하는 매커니즘
- 코드를 작성하여 구현하는 메커니즘

위의 2가지 시나리오는 단점이 있음

- 스토리보드/세그 매커니즘

1. 네비게이션이 전역적으로(스태틱하게) 연관되며, 

2. 스토리보드가 복잡해짐, 

3. 뷰컨트롤러가 네비게이션 관련 코드로 오염됨.

- 코드 매커니즘
1. 디자인 패턴에 따라서 코드를 작성하기 복잡해 질 수 있음 (코디네이터 패턴 구현 혹은 라우팅 패턴 구현시)

### RxFlow 사용의 목적

- 뷰컨트롤러의 재사용성과 협응성을 높이고 스토리보드를 최대한의 작은 단위로 쪼갤수 있도록 함
- 네비게이션 컨텍스트에 따라 뷰컨트롤러를 다른 목적으로 프레젠테이션 할수 있게 함
- 의존성 주입을 쉽게 구현할수 있도록 함
- 모든 뷰컨트롤러 내부에 네비게이션 매커니즘을 없애도록 함
- 반응형 프로그램을 만들수 있도록 함
- 네비게이션 블록 로직에 따라서 어플리케이션을 나눌 수 있도록 함

### RxFlow 의 장점

- Flow 를 통해 네비게이션을 선언 형 프로그램에 가깝게 만들수 있다?
- 내장된 FlowCoordinator를 통해 네비게이션간의 흐름을 제어한다.
- 네비게이션 실행을 FlowCoordinator를 향해 트리거 하며 반응형 프로그램을 사용한다.

### 간단요약

코디네이터 패턴을 구현할 시 많은 보일러플레이트 코드가 생길수 있다.

하지만 RxFlow 는 코디네이터 패턴을 적은 코드로 쉽게 구현할수 있도록 한다.

---

# RxFlow 사용하기

### RxFlow의 6가지 주요 요소

- Flow - 네비게이션 액션이 선언된 공간 (다른 뷰 컨트롤러, 혹은 다른 플로우로 이동하는 코드가 있는 공간)
- Step - 네비게이션이 어떤 경로로 이동할지에 대한 정의 (enum case로 구현)
- Stepper - Flow 에게 Step을 방출하여 네비게이션 액션을 실행시키는 모든 것
- Presentable - Presented되는 모든것을 추상화한 개념 (기본적으로 UIViewController 나 Flow 가 해당)
- FlowContributor - Flow 내에서 발생한 다음 스텝을 FlowCoordinator 에게 전달하는 간단한 구조체
- FlowCoordinator - 개발자가 정의한 Flow와 Step들을 적절히 조합하고 앱의 네비게이션을 컨트롤함. RxFlow에서 제공하므로 구현할 필요는 없음.

## 예시)
![telegram-cloud-photo-size-5-6316439193856880646-y](https://user-images.githubusercontent.com/97213734/151660055-387b58b8-7ef8-476c-ba15-0a0a87af7205.jpg)

![image](https://user-images.githubusercontent.com/97213734/151660072-c8603742-b802-4769-b007-255481b9661f.png)


참조 : [https://velog.io/@phs880623/RxSwift-Community-RxFlow](https://velog.io/@phs880623/RxSwift-Community-RxFlow)

# 예제 프로젝트

- 예제 프로젝트의 구조

![telegram-cloud-photo-size-5-6316439193856880655-y](https://user-images.githubusercontent.com/97213734/151660179-fd08e816-5744-4b6f-9b3a-7344fc46f969.jpg)


### 1. step 정의

```swift
import Foundation
import RxFlow

enum FlowStep: Step{
    case toLogin // 로그인 화면으로 가기위한 스텝
    case toGNB // 탭바 컨트롤러로 가기 위한 스텝
     
    case toHome // 홈 화면 (채널/프로젝트 페이지뷰) 로 가기위한 스텝
    case toTemp(name:String) // 임시로 만든 빈 화면으로 가기위한 스텝
    
    case toChatList // 채팅 리스트로 가기위한 스텝
    case toProjectList // 프로젝트 리스트로 가기위한 스텝
    
    case toInChat(withChannelID:Int) // InChat 화면으로 가기위한 스텝
    case toInChatComment(withMessageID:Int) // ChatComment 로 가기위한 스텝
    
    case toInProject(withProjectID:Int) // 프로젝트 상세로 들어가기위한 스텝
}
```

### 2. AppFlow / AppStepper 구현

앱 시작시 실행될 Flow 를 구현한다.

- root : flow의 기본 바탕이 될 뷰
- navigate 메소드 : flow 가 전달받은 step 에 맞는 flowContributors 를 리턴하고 새로운 Presentable을 띄운다.
- AppStepper : 앱이 실행되고 처음으로 방출 될 step을 지정하기 위해 구현한다. 처음 방출될 step 은 initialStep 변수에 지정한다.

```swift
import Foundation
import UIKit
import RxFlow
import RxSwift
import RxCocoa

class AppFlow: Flow {
    
    var window:UIWindow
    
//Flow 의 RootView - 기본 바탕이 될 뷰 
    var root: Presentable {
        return self.window
    }

    init(window:UIWindow){
        self.window = window
    }

// 전달된 스텝을 받아서 실행하는 구간
    func navigate(to step: Step) -> FlowContributors {
        guard let step = step as? FlowStep else { return .none }
				case .toLogin:
            return showLoginWindow()      
        case .toGNB:
            return showGNBWindow()
        default:
            return .none
    }

  private func showLoginWindow() -> FlowContributors {
      // 나중에 구현
    }

    private func showGNBWindow() -> FlowContributors {
        // 나중에 구현
    }
}

//
class AppStepper: Stepper {

    let steps = PublishRelay<Step>()
    private let disposeBag = DisposeBag()

    init() {}

    var initialStep: Step{
        return FlowStep.toLogin
    }
}
```

### 3. SceneDelegate 내에 FlowCoordinator 정의

- FlowCoordinator 를 생성후 AppFlow 와 AppStepper 를 전달해주면 첫 step이 실행된다.(toLogin 스텝)

```swift
import UIKit
import RxFlow
import RxSwift

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    var coordinator = FlowCoordinator()
    var disposeBag: DisposeBag = DisposeBag()

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {

        guard let windowScene = (scene as? UIWindowScene) else { return }
        let window = UIWindow(windowScene: windowScene)

        self.window = window
        self.window?.backgroundColor = UIColor.systemBackground

// 모든 네비게이션 액션을 구독한다. 안해도 됨
        self.coordinator.rx.willNavigate.subscribe(onNext: { (flow, step) in
            print("will navigate to flow=\(flow) and step=\(step)")
        }).disposed(by: self.disposeBag)

        self.coordinator.rx.didNavigate.subscribe(onNext: { (flow, step) in
            print("did navigate to flow=\(flow) and step=\(step)")
        }).disposed(by: self.disposeBag)

        
        let appFlow = AppFlow(window: self.window!)
        self.coordinator.coordinate(flow: appFlow, with: AppStepper())
        self.window?.makeKeyAndVisible()
    }
}
```

### 4. LoginViewController / LoginFlow 구현

- LoginFlow - root 를 navigationController 로 지정해준다.
- navigate 메소드에서 toLogin 스텝을 전달받으면 root 의 화면을 LoginViewController 로 넣어준다.
- 그리고 nextPrestable 에 LoginViewController 를 지정해주고 Contributor 를 반환한다.  (.one → 하나의 contributor 만 리턴할 때)

```swift
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
				// toGNB 스텝을 받으면 부모 플로우로 올라가고 toGNB 스텝을 전달한다.
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
```

- LoginViewController - Stepper 를 상속하고 기본 프로토콜인 steps 객체를 생성
- 로그인 버튼을 누르면 toGNB 스텝을 방출한다

```swift
import Foundation
import UIKit
import RxFlow
import RxSwift
import RxCocoa

class LoginViewController:UIViewController,Stepper{
    var steps: PublishRelay<Step> = PublishRelay<Step>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let loginButton = UIButton()
        loginButton.setTitle("Login", for: .normal)
        loginButton.layer.borderColor = UIColor.systemBlue.cgColor
        loginButton.layer.borderWidth = 1
        loginButton.layer.cornerRadius = 3
        loginButton.addTarget(self, action: #selector(loginButtonDidTap), for: .touchUpInside)
        
        view.addSubview(loginButton)
        
        loginButton.frame = CGRect(x: 0, y: 0, width: 100, height: 30)
        loginButton.center = view.center
        
    }
    
    @objc func loginButtonDidTap(){
        self.steps.accept(FlowStep.toGNB)
    }
}
```

## 5. AppFlow 의 navigate 메소드 수정

- LoginFlow 선언 후 Flows.use 메소드(Flow 의 준비상태와 동기화 하는 유틸리티 메소드)의 클로저내에서 현재 윈도우의 rootViewController 를 LoginFlow 의 root 로 설정
- 단일 Contributor로 다음에 present 될 flow 와 스텝 전달
- OneStepper(withSingleStep: FlowStep.toLogin) → 간단하게 스텝을 전달할 단일 Stepper

```swift

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

    ✅private func showLoginWindow() -> FlowContributors {
        let loginFlow = LoginFlow()
        Flows.use(loginFlow, when: .created) { (root) in
            self.window.rootViewController = root
        }
        return .one(flowContributor: .contribute(withNextPresentable: loginFlow,
                                                 withNextStepper: OneStepper(withSingleStep: FlowStep.toLogin)))
    }

    ✅private func showGNBWindow() -> FlowContributors {
        let dashBoardFlow = GNBFlow()
        Flows.use(dashBoardFlow, when: .created) { (root) in
            self.window.rootViewController = root
        }
        return .one(flowContributor: .contribute(withNextPresentable: dashBoardFlow,
                                                 withNextStepper: OneStepper(withSingleStep: FlowStep.toGNB)))
    }

}
```

여기까지 하면 앱을 실행 했을때 로그인 화면이 나타난다.

![telegram-cloud-photo-size-5-6316453899824901677-y](https://user-images.githubusercontent.com/97213734/151660131-257ee360-fbd1-40e4-87fd-e449438cd613.jpg)


### 6. GNBFlow 구현

- root 를 TabbarController 로 설정
- toGNB 스텝을 전달받을 시 TabbarController 를 보여주고 각 탭마다 TempFlow 를 부여한다. FlowContributors 는 5개의 Flow 를 전달하기 때문에 .multiple 케이스에 5개의 플로우와 스탭을 전달한다.
- toLogin 스텝을 전달받을 시 부모 Flow(AppFlow)로 돌아가고 toLogin 스텝을 전달한다

```swift
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
        
        let tempFlow0 = TempFlow()
        let tempFlow1 = TempFlow()
        let tempFlow2 = TempFlow()
        let tempFlow3 = TempFlow()
        let tempFlow4 = TempFlow()

        Flows.use(tempFlow0,
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
        
        return .multiple(flowContributors: [.contribute(withNextPresentable: tempFlow0,
                                                        withNextStepper:  OneStepper(withSingleStep: FlowStep.toTemp(name: "Home"))),
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
```

### 7. TempFlow / TempViewController 구현

```swift
import Foundation
import RxFlow

class TempFlow: Flow {

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
        case .toTemp(let name):
            return self.navigateToTemp(name:name)
        case .toLogin:
            return .end(forwardToParentFlowWithStep: FlowStep.toLogin)
        default:
            return .none
        }
    }
    
    private func navigateToTemp(name:String) -> FlowContributors {
        let viewController = TempVC()
        viewController.label.text = "This is \(name)"
        self.rootViewController.setViewControllers([viewController], animated: false)
        return .one(flowContributor: .contribute(withNext: viewController))
    
    }
}
```

```swift
import Foundation
import UIKit

import RxFlow
import RxCocoa

class TempVC:UIViewController,Stepper{
    let steps = PublishRelay<Step>()
    let label = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        label.frame = CGRect(x: 0,
                          y: 0,
                          width: label.intrinsicContentSize.width,
                          height: label.intrinsicContentSize.height)
        label.textColor = .label
        
        
        view.addSubview(label)
        label.center = view.center
        
    }
}
```

구현 화면  
![ezgif com-gif-maker (6)](https://user-images.githubusercontent.com/97213734/151660142-d6107223-1212-4f46-ac06-a9b8174a0fb8.gif)


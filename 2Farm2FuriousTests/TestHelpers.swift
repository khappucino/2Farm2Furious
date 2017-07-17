import Foundation
import Swinject
import SwinjectStoryboard

@testable import _Farm2Furious

func createViewControllerWithIdentifier(_ identifier: String, container: Container) -> UIViewController {
    let storyBoard = SwinjectStoryboard.create(name: "Main", bundle: nil, container: container)
    let vc = storyBoard.instantiateViewController(withIdentifier: identifier)
    return vc
}

func applyMainAssemblyToContainer(container: Container) {
    let mainAssembly = MainAssembly()
    mainAssembly.assemble(container: container)
}

func attachViewToScreen(window: UIWindow, viewToBeAttached: UIView) {
    let vc = UIViewController()
    vc.view.frame = CGRect(x: 0, y: 0, width: 1000, height: 1000)
    vc.view.addSubview(viewToBeAttached)
    
    viewToBeAttached.leadingAnchor.constraint(equalTo: vc.view.leadingAnchor).isActive = true
    viewToBeAttached.trailingAnchor.constraint(equalTo: vc.view.trailingAnchor).isActive = true
    viewToBeAttached.topAnchor.constraint(equalTo: vc.view.topAnchor).isActive = true
    viewToBeAttached.bottomAnchor.constraint(equalTo: vc.view.bottomAnchor).isActive = true
    
    window.rootViewController = nil
    window.rootViewController = vc
}

extension LoginViewTextType: Equatable {
    public static func == (lhs: LoginViewTextType, rhs: LoginViewTextType) -> Bool {
        switch (lhs, rhs) {
        case (.username(let val1), .username(let val2)):
            return val1 == val2
        case (.password(let val1), .password(let val2)):
            return val1 == val2
        default:
            return false
        }
    }
}

extension LoginViewEvent: Equatable {
    public static func == (lhs: LoginViewEvent, rhs: LoginViewEvent) -> Bool {
        switch (lhs, rhs) {
        case (.textChanged(let val1), .textChanged(let val2)):
            return val1 == val2
        case (.submitButtonPressed(let val1a, let val1b), .submitButtonPressed(let val2a, let val2b)):
            return val1a == val2a && val1b == val2b
        default:
            return false
        }
    }
}

extension LoginViewState: Equatable {
    public static func == (lhs: LoginViewState, rhs: LoginViewState) -> Bool {
        switch (lhs, rhs) {
        case (.username(let val1), .username(let val2)):
            return val1 == val2
        case (.password(let val1), .password(let val2)):
            return val1 == val2
        case (.success(let val1), .success(let val2)):
            return val1 == val2
        case (.startedLoading, .startedLoading):
            return true
        case (.finishedLoading, .finishedLoading):
            return true
        default:
            return false
        }
    }
}






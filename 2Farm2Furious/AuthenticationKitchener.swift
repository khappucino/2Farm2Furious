import Foundation
import RxSwift

enum LoginViewState {
    case username(Bool)
    case password(Bool)
    case success(String)
    case startedLoading
    case finishedLoading
}

enum LoginViewTextType {
    case username(String)
    case password(String)
}

enum LoginViewAction {
    case textChanged(LoginViewTextType)
    case submitButtonPressed(LoginViewTextType, LoginViewTextType)
}

protocol AuthenticationKitchener {
    func bindTo(actions: Observable<LoginViewAction>) -> Observable<LoginViewState>
}

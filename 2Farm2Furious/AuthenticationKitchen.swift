import Foundation
import RxSwift

class AuthenticationKitchen: AuthenticationKitchener {
    
    private let fieldValidating: FieldValidating
    private let randomQueryService: RandomQueryDomainModelServicing
    
    init(fieldValidating: FieldValidating, randomQueryService: RandomQueryDomainModelServicing) {
        self.fieldValidating = fieldValidating
        self.randomQueryService = randomQueryService
    }
    
    func bindTo(actions: Observable<LoginViewAction>) -> Observable<LoginViewState> {
        return actions.flatMap({ [weak self] (LoginViewAction) -> Observable<LoginViewState> in
            switch LoginViewAction {
            case .textChanged(let textType):
                return self?.validateTextType(textType) ?? Observable.empty()
            case .submitButtonPressed(let usernameTextType, let passwordTextType):
                return self?.validateOnSubmit(usernameTextType, passwordTextType) ?? Observable.empty()
            }
        })
    }
    
    private func validateTextType(_ textType: LoginViewTextType) -> Observable<LoginViewState> {
        switch textType {
        case .username(let value):
            let isValid = fieldValidating.validateUsername(value)
            return Observable.just(.username(isValid))
        case .password(let value):
            let isValid = fieldValidating.validatePassword(value)
            return Observable.just(.password(isValid))
        }
    }
    
    private func validateOnSubmit(_ usernameTextType: LoginViewTextType, _ passwordTextType: LoginViewTextType) -> Observable<LoginViewState> {
        var usernameSuccess = false
        var passwordSuccess = false
        var usernameText = ""
        var passwordText = ""
        if case let LoginViewTextType.username(value) = usernameTextType {
            usernameSuccess = fieldValidating.validateUsername(value)
            usernameText = value
        }
        
        if case let LoginViewTextType.password(value) = passwordTextType {
            passwordSuccess = fieldValidating.validatePassword(value)
            passwordText = value
        }
        
        if usernameSuccess && passwordSuccess {
            let combinedSeedValue = usernameText + "," + passwordText + ","
            return randomQueryService.getRandomQuery(seedValue: combinedSeedValue).flatMap { (randomQuery) -> Observable<LoginViewState> in
                Observable.just(LoginViewState.success(randomQuery.queryString))
                }
                .startWith(.startedLoading)
                .concat(Observable.just(.finishedLoading))
        }
        else {
            return Observable.just(.username(usernameSuccess))
                             .concat(Observable.just(.password(passwordSuccess)))
        }
        
    }
}

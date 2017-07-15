import Foundation
import RxSwift

class AuthenticationKitchen: AuthenticationKitchener {
    
    private let fastAndTheFuriousCastValidator: FastAndTheFuriousCastValidator
    private let coronaService: CoronaService
    
    init(fastAndTheFuriousCastValidator: FastAndTheFuriousCastValidator, coronaService: CoronaService) {
        self.fastAndTheFuriousCastValidator = fastAndTheFuriousCastValidator
        self.coronaService = coronaService
    }
    
    func bindTo(events: Observable<LoginViewEvent>) -> Observable<LoginViewState> {
        return events.flatMap({ [weak self] (loginViewEvent) -> Observable<LoginViewState> in
            switch loginViewEvent {
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
            let isValid = fastAndTheFuriousCastValidator.validateUserName(value)
            return Observable.just(.username(isValid))
        case .password(let value):
            let isValid = fastAndTheFuriousCastValidator.validatePassword(value)
            return Observable.just(.password(isValid))
        }
    }
    
    private func validateOnSubmit(_ usernameTextType: LoginViewTextType, _ passwordTextType: LoginViewTextType) -> Observable<LoginViewState> {
        var usernameSuccess = false
        var passwordSuccess = false
        if case let LoginViewTextType.username(value) = usernameTextType {
            usernameSuccess = fastAndTheFuriousCastValidator.validateUserName(value)
        }
        
        if case let LoginViewTextType.password(value) = passwordTextType {
            passwordSuccess = fastAndTheFuriousCastValidator.validatePassword(value)
        }
        
        if usernameSuccess && passwordSuccess {
            return coronaService.getCorona().flatMap { (corona) -> Observable<LoginViewState> in
                Observable.just(LoginViewState.success(corona))
            }
        }
        else {
            return Observable.just(.password(passwordSuccess))
                             .startWith(.username(usernameSuccess))
        }
        
    }
}

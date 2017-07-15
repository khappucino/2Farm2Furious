import UIKit
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

enum LoginViewEvent {
    case textChanged(LoginViewTextType)
    case submitButtonPressed(LoginViewTextType, LoginViewTextType)
}

class AuthenticationViewController: UIViewController {
    @IBOutlet weak var loginView: LoginView!
    
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    private var authenticationKitchener: AuthenticationKitchener!
    private var router: AuthenticationVCRouting!
    
    private let disposeBag = DisposeBag()
    
    internal func inject(authenticationKitchener: AuthenticationKitchener, router: AuthenticationVCRouting) {
        self.authenticationKitchener = authenticationKitchener
        self.router = router
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // the loginview could always emit different events,
        // we would just need to flatmap those events into the VC specific events
        // for sake of
        authenticationKitchener.bindTo(events: loginView.validatedTextStream())
            .subscribe(onNext: { [weak self] (loginViewState) in
                self?.updateState(loginViewState)
            }, onError: { (error) in
                
            }).disposed(by: disposeBag)
    }
    
    
    private func updateState(_ state: LoginViewState) {
        switch state {
        case .startedLoading:
            loadingIndicator.isHidden = false
        case .finishedLoading:
            loadingIndicator.isHidden = true
        case .success(let value):
            router.routeToAllTheThings(title: value)
        default:
            loginView.updateState(textFieldState: state)
        }
        
    }
    
    
}


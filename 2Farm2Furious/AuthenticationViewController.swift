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
    
    public static let ID = "AuthenticationViewController"
    
    @IBOutlet weak var loginViewContainer: UIView!
    
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    private var authenticationKitchener: AuthenticationKitchener!
    private var router: AuthenticationVCRouting!
    private var loginView: LoginView!
    
    private let disposeBag = DisposeBag()
    
    internal func inject(authenticationKitchener: AuthenticationKitchener, router: AuthenticationVCRouting, loginView: LoginView) {
        self.authenticationKitchener = authenticationKitchener
        self.router = router
        self.loginView = loginView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureViews()

        // the loginview could always emit different events,
        // we would just need to flatmap those events into the VC specific events
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
    
    
    private func configureViews() {
        loginViewContainer.addSubview(loginView)
        
        loginView.leadingAnchor.constraint(equalTo: loginViewContainer.leadingAnchor).isActive = true
        loginView.trailingAnchor.constraint(equalTo: loginViewContainer.trailingAnchor).isActive = true
        loginView.topAnchor.constraint(equalTo: loginViewContainer.topAnchor).isActive = true
        loginView.bottomAnchor.constraint(equalTo: loginViewContainer.bottomAnchor).isActive = true

    }
    
}


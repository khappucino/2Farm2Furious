import UIKit
import RxSwift

class AuthenticationViewController: UIViewController {
    @IBOutlet weak var resultLabel: UILabel!
    @IBOutlet weak var loginView: LoginView!
    
    private var authenticationKitchener: AuthenticationKitchener!
    
    private let disposeBag = DisposeBag()
    
    internal func inject(authenticationKitchener: AuthenticationKitchener) {
        self.authenticationKitchener = authenticationKitchener
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        authenticationKitchener.bindTo(events: loginView.validatedTextStream())
            .subscribe(onNext: { [weak self] (loginViewState) in
                if case let LoginViewState.success(value) = loginViewState {
                    self?.resultLabel.text = value
                }
                else {
                    self?.loginView.updateState(textFieldState: loginViewState)
                }
            }, onError: { (error) in
                
            }).disposed(by: disposeBag)
    }
    
    
    
}


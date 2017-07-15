import Foundation
import UIKit
import RxSwift
import RxCocoa

enum LoginViewState {
    case username(Bool)
    case password(Bool)
    case success(String)
}

enum LoginViewTextType {
    case username(String)
    case password(String)
}

enum LoginViewEvent {
    case textChanged(LoginViewTextType)
    case submitButtonPressed(LoginViewTextType, LoginViewTextType)
}


class LoginView: UIView {
    
    @IBOutlet weak var button: UIButton!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    private let disposeBag = DisposeBag()
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        addNibView()
        translatesAutoresizingMaskIntoConstraints = false
        setupErrorReset()
        
    }
    
    func validatedTextStream() -> Observable<LoginViewEvent> {
        let nonEmptyUsernameEvent = getNonEmptyUserNameEvent()
        let nonEmptyPasswordEvent = getNonEmptyPasswordNameEvent()
        
        let userNameTextFieldEndedEditing = getUserNameEndedEditingEvent()
        let passwordTextFieldEndedEditing = getPasswordNameEndedEditingEvent()
        
        let buttonTappedAndTextFieldTexts = getButtonTappedAndTextFieldTexts()
        
        return Observable.merge([nonEmptyUsernameEvent, nonEmptyPasswordEvent, userNameTextFieldEndedEditing, passwordTextFieldEndedEditing, buttonTappedAndTextFieldTexts])
    }

    func updateState(textFieldState: LoginViewState) {
        switch textFieldState {
        case .username(let isValid):
            updateTextFieldBorder(usernameTextField, isValid: isValid)
        case .password(let isValid):
            updateTextFieldBorder(passwordTextField, isValid: isValid)
        default:
            break
        }
    }
    
    private func addNibView() {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: String(describing: type(of: self)), bundle: bundle)
        let nibView = nib.instantiate(withOwner: self, options: nil).first as! UIView
        nibView.translatesAutoresizingMaskIntoConstraints = false
        
        self.addSubview(nibView)
        
        nibView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        nibView.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        nibView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        nibView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        
        usernameTextField.layer.borderWidth = 2
        usernameTextField.layer.borderColor = UIColor.darkGray.cgColor
        passwordTextField.layer.borderWidth = 2
        passwordTextField.layer.borderColor = UIColor.darkGray.cgColor
    }

    private func setupErrorReset() {
        usernameTextField.rx.text.subscribe(onNext: { [weak self] (text) in
            if let welf = self {
                let textOrEmpty = text ?? ""
                if textOrEmpty.isEmpty {
                    welf.updateTextFieldBorder(welf.usernameTextField, isValid: true)
                }
            }
        }).disposed(by: disposeBag)
        
        passwordTextField.rx.text.subscribe(onNext: { [weak self] (text) in
            if let welf = self {
                let textOrEmpty = text ?? ""
                if textOrEmpty.isEmpty {
                    welf.updateTextFieldBorder(welf.passwordTextField, isValid: true)
                }
            }
        }).disposed(by: disposeBag)
    }
    
    private func getButtonTappedAndTextFieldTexts() -> Observable<LoginViewEvent> {
        let userNameTextTypeObs = usernameTextField.rx.text.map { (text) in
            return LoginViewTextType.username(text ?? "")
        }
        let passwordTextTypeObs = passwordTextField.rx.text.map { (text) in
            return LoginViewTextType.password(text ?? "")
        }
        
        let combo = Observable.combineLatest(userNameTextTypeObs, passwordTextTypeObs)
        
        let buttonTappedObs =  button.rx.controlEvent(.touchUpInside).asObservable()
        
        return buttonTappedObs.withLatestFrom(combo)
            .map({ (userNameTextType, passwordTextType) -> LoginViewEvent in
                return LoginViewEvent.submitButtonPressed(userNameTextType, passwordTextType)
            })
    }
    
    private func getUserNameEndedEditingEvent() -> Observable<LoginViewEvent> {
        return usernameTextField.rx.controlEvent(.editingDidEnd)
            .withLatestFrom(usernameTextField.rx.text)
            .map { text in
                return LoginViewEvent.textChanged(.username(text ?? ""))
        }
    }
    
    private func getPasswordNameEndedEditingEvent() -> Observable<LoginViewEvent> {
        return passwordTextField.rx.controlEvent(.editingDidEnd)
            .withLatestFrom(passwordTextField.rx.text)
            .map { text in
                return LoginViewEvent.textChanged(.password(text ?? ""))
        }
    }
    
    private func getNonEmptyUserNameEvent() -> Observable<LoginViewEvent> {
        return usernameTextField.rx.text
            .flatMap { Observable.from(optional: $0) }
            .filter { (text) -> Bool in
                return !text.isEmpty
            }
            .map { (text) -> LoginViewEvent in
                return LoginViewEvent.textChanged(.username(text))
        }
        
    }
    
    private func getNonEmptyPasswordNameEvent() -> Observable<LoginViewEvent> {
        return passwordTextField.rx.text
            .flatMap { Observable.from(optional: $0) }
            .filter { (text) -> Bool in
                return !text.isEmpty
            }
            .map { (text) -> LoginViewEvent in
                return LoginViewEvent.textChanged(.password(text))
        }
    }
    
    private func updateTextFieldBorder(_ textField: UITextField, isValid: Bool) {
        if isValid {
            textField.layer.borderColor = UIColor.darkGray.cgColor
        }
        else {
            textField.layer.borderColor = UIColor.red.cgColor
        }
    }
    
}

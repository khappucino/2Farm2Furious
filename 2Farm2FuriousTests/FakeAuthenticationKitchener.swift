import Foundation
import RxSwift

@testable import _Farm2Furious

class FakeAuthenticationKitchener: AuthenticationKitchener {
    var receivedActions = [LoginViewAction]()
    private let eventPumper = PublishSubject<LoginViewState>()
    
    private let disposeBag = DisposeBag()
    
    func pumpVCState(vcState: LoginViewState) {
        eventPumper.onNext(vcState)
    }
    
    func bindTo(actions: Observable<LoginViewAction>) -> Observable<LoginViewState> {
        actions.subscribe(onNext: { [weak self] (event) in
            self?.receivedActions.append(event)
        }).disposed(by: disposeBag)
        return eventPumper.asObservable()
    }
}

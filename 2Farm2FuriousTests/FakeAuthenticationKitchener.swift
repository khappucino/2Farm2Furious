import Foundation
import RxSwift

@testable import _Farm2Furious

class FakeAuthenticationKitchener: AuthenticationKitchener {
    var receivedEvents = [LoginViewEvent]()
    private let eventPumper = PublishSubject<LoginViewState>()
    
    private let disposeBag = DisposeBag()
    
    func pumpVCState(vcState: LoginViewState) {
        eventPumper.onNext(vcState)
    }
    
    func bindTo(events: Observable<LoginViewEvent>) -> Observable<LoginViewState> {
        events.subscribe(onNext: { [weak self] (event) in
            self?.receivedEvents.append(event)
        }).disposed(by: disposeBag)
        return eventPumper.asObservable()
    }
}

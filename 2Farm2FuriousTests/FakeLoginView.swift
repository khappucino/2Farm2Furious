import Foundation
import UIKit
import RxSwift

@testable import _Farm2Furious

class FakeLoginView: LoginView {

    private let publishSubject = PublishSubject<LoginViewAction>()
    
    override func commonSetup() {
        // do nothing
    }
    
    func sendFakeEvent(event: LoginViewAction) {
        publishSubject.onNext(event)
    }
    
    func sendFakeEvents(events: [LoginViewAction]) {
        for event in events {
            publishSubject.onNext(event)
        }
    }
    
    var recordedState: LoginViewState?
    override func updateState(textFieldState: LoginViewState) {
        recordedState = textFieldState
    }
    
    override func validatedTextStream() -> Observable<LoginViewAction> {
        return publishSubject.asObservable()
    }
}

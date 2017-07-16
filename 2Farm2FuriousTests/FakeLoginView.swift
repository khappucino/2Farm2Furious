import Foundation
import UIKit
import RxSwift

@testable import _Farm2Furious

class FakeLoginView: LoginView {

    private let publishSubject = PublishSubject<LoginViewEvent>()
    
    override func commonSetup() {
        // do nothing
    }
    
    func sendFakeEvent(event: LoginViewEvent) {
        publishSubject.onNext(event)
    }
    
    func sendFakeEvents(events: [LoginViewEvent]) {
        for event in events {
            publishSubject.onNext(event)
        }
    }
    
    var recordedState: LoginViewState?
    override func updateState(textFieldState: LoginViewState) {
        recordedState = textFieldState
    }
    
    override func validatedTextStream() -> Observable<LoginViewEvent> {
        return publishSubject.asObservable()
    }
}

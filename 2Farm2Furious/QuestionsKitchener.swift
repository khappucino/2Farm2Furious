import Foundation
import RxSwift

enum QuestionsEvent {
    case load(String)
}

enum QuestionsVCState {
    case startedLoading
    case finishedLoading
    case loaded(Questions)
}

protocol QuestionsKitchener {
    func input(event: QuestionsEvent)
    func vcStateStream() -> Observable<QuestionsVCState>
}

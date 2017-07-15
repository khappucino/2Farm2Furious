import Foundation
import RxSwift

class CoronaService {
    func getCorona() -> Observable<String> {
        return Observable.just("corona").delay(2, scheduler: MainScheduler.instance)
    }
}

import Foundation
import UIKit
import RxSwift

@testable import _Farm2Furious

class FakeCoronaService: CoronaService {
    var stubbedReturn = "10SecondCar"
    override func getCorona() -> Observable<String> {
        return Observable.just(stubbedReturn)
    }
}

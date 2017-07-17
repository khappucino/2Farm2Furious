import Foundation
import UIKit
import RxSwift

@testable import _Farm2Furious

class FakeCoronaService: CoronaDomainModelServicing {
    var stubbedReturn = "10SecondCar"
    func getCorona() -> Observable<CoronaBeer> {
        return Observable.just(CoronaBeer(ingredients: stubbedReturn))
    }
}

import Foundation
import UIKit
import RxSwift

@testable import _Farm2Furious

class FakeRandomQueryServicing: RandomQueryDomainModelServicing {
    var stubbedReturn = "10SecondCar"
    func getRandomQuery(seedValue: String) -> Observable<RandomQuery> {
        return Observable.just(RandomQuery(queryString: stubbedReturn))
    }
}

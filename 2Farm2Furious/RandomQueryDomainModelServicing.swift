import Foundation
import RxSwift

protocol RandomQueryDomainModelServicing {
    func getRandomQuery(seedValue: String) -> Observable<RandomQuery>
}

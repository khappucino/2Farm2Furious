import Foundation
import RxSwift

protocol CoronaDomainModelServicing {
    func getCorona() -> Observable<CoronaBeer>
}

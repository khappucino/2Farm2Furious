import Foundation
import RxSwift

protocol AuthenticationKitchener {
    func bindTo(events: Observable<LoginViewEvent>) -> Observable<LoginViewState>
}

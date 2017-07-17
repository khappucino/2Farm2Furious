import Foundation
import RxSwift

protocol QuestionsDomainModelServicing {
    func getQuestions(query: String) -> Observable<Questions>
}

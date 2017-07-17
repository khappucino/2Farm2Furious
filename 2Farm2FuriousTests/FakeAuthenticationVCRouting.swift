import Foundation

@testable import _Farm2Furious

class FakeAuthenticationVCRouting: AuthenticationVCRouting {
    var recordedQuery = ""
    func routeToQuestionsWithQuery(_ query: String) {
        recordedQuery = query
    }
}

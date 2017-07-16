import Foundation

@testable import _Farm2Furious

class FakeAuthenticationVCRouting: AuthenticationVCRouting {
    var recordedTitle = ""
    func routeToAllTheThings(title: String) {
        recordedTitle = title
    }
}

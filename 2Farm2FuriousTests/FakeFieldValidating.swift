import Foundation
import UIKit

@testable import _Farm2Furious

class FakeFieldValidating: FieldValidating {
    
    var stubbedUsernameResult = true
    func validateUsername(_ username: String) -> Bool {
        return stubbedUsernameResult
    }
    
    var stubbedPasswordResult = true
    func validatePassword(_ password: String) -> Bool {
        return stubbedPasswordResult
    }
}

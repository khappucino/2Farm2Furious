import Foundation

protocol FieldValidating {
    func validateUsername(_ username: String) -> Bool
    func validatePassword(_ password: String) -> Bool
}

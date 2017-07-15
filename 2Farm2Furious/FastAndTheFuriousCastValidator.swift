import Foundation

class FastAndTheFuriousCastValidator: FieldValidating {
    func validateUsername(_ username: String) -> Bool {
        return username == "toretto"
    }
    
    func validatePassword(_ password: String) -> Bool {
        return password == "la famiglia"
    }
}

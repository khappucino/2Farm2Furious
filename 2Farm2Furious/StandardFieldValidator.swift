import Foundation

class StandardFieldValidator: FieldValidating {
    func validateUsername(_ username: String) -> Bool {
        let isValidChars = nil == username.rangeOfCharacter(from: NSCharacterSet.letters.inverted)
        return isValidChars && username.characters.count > 0
    }
    
    func validatePassword(_ password: String) -> Bool {
        let isValidChars = nil == password.rangeOfCharacter(from: NSCharacterSet.alphanumerics.inverted)
        return isValidChars && password.characters.count > 0
    }
}

import Foundation
import Swinject
import SwinjectStoryboard

extension SwinjectStoryboard {
    class func setup() {
        defaultContainer.storyboardInitCompleted(AuthenticationViewController.self) { resolver, controller in
            if let authenticationViewController = controller as? AuthenticationViewController {
                let authenticationKitchener = resolver.resolve(AuthenticationKitchener.self)!
                authenticationViewController.inject(authenticationKitchener: authenticationKitchener)
            }
        }
        
        defaultContainer.register(FieldValidating.self) { _ in
            return StandardFieldValidator()
        }
        
        defaultContainer.register(AuthenticationKitchener.self) { resolver in
            let fnfValidator = resolver.resolve(FieldValidating.self)!
            let coronaService = resolver.resolve(CoronaService.self)!
            return AuthenticationKitchen(fieldValidating: fnfValidator, coronaService: coronaService)
        }
        
        defaultContainer.register(CoronaService.self) { _ in
            return CoronaService()
        }
        
        
    }
}

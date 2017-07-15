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
        
        defaultContainer.register(FastAndTheFuriousCastValidator.self) { _ in
            return FastAndTheFuriousCastValidator()
        }
        
        defaultContainer.register(AuthenticationKitchener.self) { resolver in
            let fnfValidator = resolver.resolve(FastAndTheFuriousCastValidator.self)!
            let coronaService = resolver.resolve(CoronaService.self)!
            return AuthenticationKitchen(fastAndTheFuriousCastValidator: fnfValidator, coronaService: coronaService)
        }
        
        defaultContainer.register(CoronaService.self) { _ in
            return CoronaService()
        }
        
        
    }
}

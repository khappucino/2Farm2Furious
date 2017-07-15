import Foundation
import Swinject
import SwinjectStoryboard

extension SwinjectStoryboard {
    class func setup() {
        
        defaultContainer.storyboardInitCompleted(AuthenticationViewController.self) { resolver, controller in
            let authenticationKitchener = resolver.resolve(AuthenticationKitchener.self)!
            controller.inject(authenticationKitchener: authenticationKitchener)
        }
        
        defaultContainer.register(StoryboardProvider.self) { _ in
            return StoryboardProvider()
        }.inObjectScope(.container)
        
        defaultContainer.register(NavigationControllerProvider.self) { _ in
            return NavigationControllerProvider()
        }.inObjectScope(.container)
        
        defaultContainer.register(AuthenticationVCRouting.self) { resolver in
            let storyboardProvider = resolver.resolve(StoryboardProvider.self)!
            let navigationControllerProvider = resolver.resolve(NavigationControllerProvider.self)!
            return AuthenticationVCStoryboardRouter(storyboardProvider: storyboardProvider, navigationControllerProvider: navigationControllerProvider)
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

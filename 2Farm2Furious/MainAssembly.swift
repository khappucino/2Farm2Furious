import Foundation
import UIKit
import Swinject
import SwinjectStoryboard

class MainAssembly: Assembly {
    
    func assemble(container: Container) {
        
        container.storyboardInitCompleted(AuthenticationViewController.self) { resolver, controller in
            let authenticationKitchener = resolver.resolve(AuthenticationKitchener.self)!
            let router = resolver.resolve(AuthenticationVCRouting.self)!
            let loginView = resolver.resolve(LoginView.self)!
            controller.inject(authenticationKitchener: authenticationKitchener, router: router, loginView: loginView)
        }
        
        container.register(StoryboardProvider.self) { _ in
            return StoryboardProvider()
            }.inObjectScope(.container)
        
        container.register(NavigationControllerProvider.self) { _ in
            return NavigationControllerProvider()
            }.inObjectScope(.container)
        
        container.register(AuthenticationVCRouting.self) { resolver in
            let storyboardProvider = resolver.resolve(StoryboardProvider.self)!
            let navigationControllerProvider = resolver.resolve(NavigationControllerProvider.self)!
            return AuthenticationVCStoryboardRouter(storyboardProvider: storyboardProvider, navigationControllerProvider: navigationControllerProvider)
        }
        
        container.register(LoginView.self) { _ in
            return LoginView(frame: .zero)
        }
        
        container.register(FieldValidating.self) { _ in
            return StandardFieldValidator()
        }
        
        container.register(AuthenticationKitchener.self) { resolver in
            let fnfValidator = resolver.resolve(FieldValidating.self)!
            let coronaService = resolver.resolve(CoronaService.self)!
            return AuthenticationKitchen(fieldValidating: fnfValidator, coronaService: coronaService)
        }
        
        container.register(CoronaService.self) { _ in
            return CoronaService()
        }
        

    }
}

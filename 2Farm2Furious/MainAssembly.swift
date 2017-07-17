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
        
        container.storyboardInitCompleted(QuestionsViewController.self) { resolver, controller in
            let questionsKitchener = resolver.resolve(QuestionsKitchener.self)!
            controller.inject(kitchen: questionsKitchener)
        }
        
        container.storyboardInitCompleted(UINavigationController.self) { _,_ in
            
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
            let coronaService = resolver.resolve(CoronaDomainModelServicing.self)!
            return AuthenticationKitchen(fieldValidating: fnfValidator, coronaService: coronaService)
        }
        
        container.register(QuestionsKitchener.self) { resolver in
            let questionsService = resolver.resolve(QuestionsDomainModelServicing.self)!
            return QuestionsKitchen(questionsDomainService: questionsService)
        }
        
        container.register(QuestionsDomainModelServicing.self) { resolver in
            return QuestionsService()
        }
        
        container.register(CoronaDomainModelServicing.self) { _ in
            return CoronaService()
        }
        
    }
}

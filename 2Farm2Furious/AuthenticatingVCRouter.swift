import Foundation
import SwinjectStoryboard

class AuthenticationVCStoryboardRouter: AuthenticationVCRouting {
    let storyboardProvider: StoryboardProvider
    let navigationControllerProvider: NavigationControllerProvider
    init(storyboardProvider: StoryboardProvider, navigationControllerProvider: NavigationControllerProvider) {
        self.storyboardProvider = storyboardProvider
        self.navigationControllerProvider = navigationControllerProvider
    }
    
    func routeToBeer(title: String) {
        
    }
}

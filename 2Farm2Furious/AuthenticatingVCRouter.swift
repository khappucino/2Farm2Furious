import Foundation
import SwinjectStoryboard

class AuthenticationVCStoryboardRouter: AuthenticationVCRouting {
    let storyboardProvider: StoryboardProvider
    let navigationControllerProvider: NavigationControllerProvider
    
    init(storyboardProvider: StoryboardProvider, navigationControllerProvider: NavigationControllerProvider) {
        self.storyboardProvider = storyboardProvider
        self.navigationControllerProvider = navigationControllerProvider
    }
    
    func routeToAllTheThings(title: String) {
        let storyboardToInflateFrom = self.storyboardProvider.storyBoard
        let allTheThingsViewController = storyboardToInflateFrom.instantiateViewController(withIdentifier: AllTheThingsViewController.ID)
        if let navigationController = self.navigationControllerProvider.getNavigationController() {
            navigationController.pushViewController(allTheThingsViewController, animated: true)
        }
    }
}

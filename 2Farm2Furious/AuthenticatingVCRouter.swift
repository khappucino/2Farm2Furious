import Foundation

class AuthenticationVCStoryboardRouter: AuthenticationVCRouting {
    let storyboardProvider: StoryboardProvider
    let navigationControllerProvider: NavigationControllerProvider
    
    init(storyboardProvider: StoryboardProvider, navigationControllerProvider: NavigationControllerProvider) {
        self.storyboardProvider = storyboardProvider
        self.navigationControllerProvider = navigationControllerProvider
    }
    
    func routeToQuestionsWithQuery(_ query: String) {
        let storyboardToInflateFrom = self.storyboardProvider.storyBoard
        let questionsViewController = storyboardToInflateFrom.instantiateViewController(withIdentifier: QuestionsViewController.ID) as! QuestionsViewController
        questionsViewController.configure(query: query)
        
        if let navigationController = self.navigationControllerProvider.getNavigationController() {
            navigationController.pushViewController(questionsViewController, animated: true)
        }
    }
}

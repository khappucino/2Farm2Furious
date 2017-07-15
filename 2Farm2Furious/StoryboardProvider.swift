import Foundation
import Swinject
import SwinjectStoryboard

class StoryboardProvider {
    lazy var storyBoard = SwinjectStoryboard.create(name: "Main", bundle: nil)
}

import Foundation
import Swinject
import SwinjectStoryboard

extension SwinjectStoryboard {
    class func setup() {
        
        let mainAssembly = MainAssembly()
        mainAssembly.assemble(container: SwinjectStoryboard.defaultContainer)
    }
}

import Foundation
import UIKit

class NavigationControllerProvider {
    func getNavigationController() -> UINavigationController? {
        return UIApplication.shared.delegate?.window??.rootViewController as? UINavigationController
    }
}

import Foundation

class Questions {
    private let titles: [String]
    
    init(titles: [String]) {
        self.titles = titles
    }
    
    public func numberOfTitles() -> Int {
        return titles.count
    }
    
    public func titleForIndex(index: Int) -> String {
        if index > 0 && index < titles.count {
            return titles[index]
        }
        return ""
    }
}

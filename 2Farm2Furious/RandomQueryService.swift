import Foundation
import RxSwift

class RandomQueryService: RandomQueryDomainModelServicing {
    fileprivate let javaService = JavaService()
    fileprivate let swiftService = SwiftService()
    fileprivate let haskellService = HaskellService()
    
    func getRandomQuery(seedValue: String) -> Observable<RandomQuery> {
        let javaObs: Observable<String> = javaService.getJava()
        let swiftObs: Observable<String> = swiftService.getSwift()
        let haskellObs: Observable<String> = haskellService.getHaskell()
        
        let hashValue = seedValue.hashValue
        let randomIndex = hashValue % 3
        
        return Observable.zip(javaObs, swiftObs, haskellObs) { (java, swift, haskell) in
            switch randomIndex {
            case 0:
                return java
            case 1:
                return swift
            case 2:
                return haskell
            default:
                return "ada"
            }
            }.map({ (queryString) in
                return RandomQuery(queryString: queryString)
            }).delay(2, scheduler: MainScheduler.instance)
    }
}

fileprivate class JavaService {
    func getJava() -> Observable<String> {
        return Observable.just("java")
    }
}

fileprivate class SwiftService {
    func getSwift() -> Observable<String> {
        return Observable.just("swift")
    }
}

fileprivate class HaskellService {
    func getHaskell() -> Observable<String> {
        return Observable.just("haskell")
    }
}

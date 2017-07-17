import Foundation
import RxSwift

class RandomQueryService: RandomQueryDomainModelServicing {
    fileprivate let javaService = JavaService()
    fileprivate let swiftService = SwiftService()
    fileprivate let haskellService = HaskellService()
    
    func getRandomQuery(seedValue: String) -> Observable<RandomQuery> {
        let javaObs: Observable<String> = javaService.getWaterIngredient()
        let swiftObs: Observable<String> = swiftService.getBarleyMaltIngredient()
        let haskellObs: Observable<String> = haskellService.getYeast()
        
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
    func getWaterIngredient() -> Observable<String> {
        return Observable.just("water")
    }
}

fileprivate class SwiftService {
    func getBarleyMaltIngredient() -> Observable<String> {
        return Observable.just("barleyMalt")
    }
}

fileprivate class HaskellService {
    func getYeast() -> Observable<String> {
        return Observable.just("yeast")
    }
}

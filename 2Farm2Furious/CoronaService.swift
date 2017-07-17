import Foundation
import RxSwift

class CoronaService: CoronaDomainModelServicing {
    fileprivate let waterService = WaterService()
    fileprivate let barleyMaltService = BarleyMaltService()
    fileprivate let yeastService = YeastService()
    
    func getCorona() -> Observable<CoronaBeer> {
        let waterObs: Observable<String> = waterService.getWaterIngredient()
        let bareleyOs: Observable<String> = barleyMaltService.getBarleyMaltIngredient()
        let yeastObs: Observable<String> = yeastService.getYeast()
        
        return Observable.zip(waterObs, bareleyOs, yeastObs) { (water, barley, yeast) in
                return water + "," + barley + "," + yeast
            }.map({ (ingredientList) in
                return CoronaBeer(ingredients: ingredientList)
            }).delay(2, scheduler: MainScheduler.instance)
    }
}

fileprivate class WaterService {
    func getWaterIngredient() -> Observable<String> {
        return Observable.just("water")
    }
}

fileprivate class BarleyMaltService {
    func getBarleyMaltIngredient() -> Observable<String> {
        return Observable.just("barleyMalt")
    }
}

fileprivate class YeastService {
    func getYeast() -> Observable<String> {
        return Observable.just("yeast")
    }
}

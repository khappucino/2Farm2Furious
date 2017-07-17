import Foundation
import RxSwift

class QuestionsService: QuestionsDomainModelServicing {
    fileprivate let stackOverflowQuestionService = StackOverflowQuestionService()
    func getQuestions(query: String) -> Observable<Questions> {
        return stackOverflowQuestionService.getQuestions(query: query).map({ (titles) in
            return Questions(titles: titles)
        })
    }
}

fileprivate class StackOverflowQuestionService {
    func getQuestions(query: String) -> Observable<[String]> {
        let pubsub = PublishSubject<[String]>()
        let session = URLSession(configuration: .default)
        guard var baseComponent = URLComponents(string: "https://api.stackexchange.com/2.2/search/advanced") else {
            return Observable.just([])
        }

        baseComponent.queryItems = [URLQueryItem(name: "order", value: "desc"),
                                    URLQueryItem(name: "sort", value: "activity"),
                                    URLQueryItem(name: "q", value: query),
                                    URLQueryItem(name: "site", value: "stackoverflow")]
                                    
        guard let url = baseComponent.url else {
            return Observable.just([])
        }
        
        let task = session.dataTask(with: url) { [pubsub] (data, response, error) in
            guard let data = data, error == nil else {
                pubsub.onNext(["Something went wrong"])
                return
            }
            do {
                let json = try JSONSerialization.jsonObject(with: data, options: .allowFragments)
                if let json = json as? [String:Any],
                    let items = json["items"] as? [[String:Any]] {
                    var titles = [String]()
                    for item in items {
                        if let title = item["title"] as? String {
                            titles.append(title)
                        }
                    }
                    pubsub.onNext(titles)
                }
                else {
                    pubsub.onNext(["Something went wrong"])
                }
            }
            catch {
                pubsub.onNext(["Something went wrong"])
            }
        }
        task.resume()
        return pubsub.asObservable()
    }
    
}

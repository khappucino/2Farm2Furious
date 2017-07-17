import Foundation
import RxSwift

class QuestionsKitchen: QuestionsKitchener {
    let _outputPublishSubject = PublishSubject<QuestionsVCState>()
    let questionsService: QuestionsDomainModelServicing
    let disposeBag = DisposeBag()
    
    init(questionsDomainService: QuestionsDomainModelServicing) {
        self.questionsService = questionsDomainService
    }
    
    func input(event: QuestionsEvent) {
        switch event {
        case .load(let query):
            
            _outputPublishSubject.onNext(.startedLoading)
            
            questionsService.getQuestions(query: query)
                .observeOn(MainScheduler.instance)
                .subscribe(onNext: { [weak self] (questions) in
                    
                    self?._outputPublishSubject.onNext(.loaded(questions))
                    self?._outputPublishSubject.onNext(.finishedLoading)
                    
                }).disposed(by: disposeBag)
        }
    }
    
    func vcStateStream() -> Observable<QuestionsVCState> {
        return _outputPublishSubject.asObservable()
    }
}

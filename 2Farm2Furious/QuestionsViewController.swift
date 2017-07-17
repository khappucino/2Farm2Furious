import Foundation
import UIKit
import RxSwift

class QuestionsViewController: UIViewController {
    
    public static let ID = "QuestionsViewController"
    
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    @IBOutlet weak var tableView: UITableView!
    
    var kitchen: QuestionsKitchener!
    
    let disposeBag = DisposeBag()
    
    var query = ""
    var questions = Questions(titles: [])
    
    func inject(kitchen: QuestionsKitchener) {
        self.kitchen = kitchen
    }
    
    func configure(query: String) {
        self.query = query
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        
        kitchen.vcStateStream().subscribe(onNext: { [weak self] (vcState) in
            switch vcState {
            case .startedLoading:
                self?.loadingIndicator.isHidden = false
            case .finishedLoading:
                self?.loadingIndicator.isHidden = true
            case .loaded(let questions):
                self?.questions = questions
                self?.tableView.reloadData()
                break
            }
        }).disposed(by: disposeBag)
        
        kitchen.input(event: .load(query))
    }
}

extension QuestionsViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return questions.numberOfTitles()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = questions.titleForIndex(index: indexPath.row)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}




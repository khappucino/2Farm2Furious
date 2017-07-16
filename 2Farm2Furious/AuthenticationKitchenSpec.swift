import Quick
import Nimble
import Swinject
import SwinjectStoryboard
import RxSwift

@testable import _Farm2Furious

class AuthenticationKitchenSpec: QuickSpec {
    override func spec() {
        
        describe("AuthenticationKitchen") {
            var subject: AuthenticationKitchen!
            var fakeFieldValidating: FakeFieldValidating!
            var fakeCoronaService: FakeCoronaService!
            var inputEventSource: PublishSubject<LoginViewEvent>!
            var outputEvents: [LoginViewState]!
            let disposeBag = DisposeBag()
            
            beforeEach {
                outputEvents = [LoginViewState]()
                
                fakeFieldValidating = FakeFieldValidating()
                fakeCoronaService = FakeCoronaService()
                
                inputEventSource = PublishSubject<LoginViewEvent>()
                
                subject = AuthenticationKitchen(fieldValidating: fakeFieldValidating, coronaService: fakeCoronaService)
                
                subject.bindTo(events: inputEventSource.asObservable()).subscribe(onNext: { (outputViewState) in
                    outputEvents.append(outputViewState)
                }).disposed(by: disposeBag)
            }
            
            describe("when responding to input events") {
                context("when we receive the textChanged event on the username field") {
                    beforeEach {
                        fakeFieldValidating.stubbedUsernameResult = true
                        inputEventSource.onNext(.textChanged(.username("moo")))
                    }
                    
                    it("should have output a password validity output state") {
                        let expectedOutput: [LoginViewState] = [.username(true)]
                        let isValid = expectedOutput == outputEvents
                        expect(isValid).to(beTrue())
                    }
                }
                
                context("when we receive the textChanged event on the password field") {
                    beforeEach {
                        fakeFieldValidating.stubbedPasswordResult = true
                        inputEventSource.onNext(.textChanged(.password("cow")))
                    }
                    
                    it("should have output a password validity output state") {
                        let expectedOutput: [LoginViewState] = [.password(true)]
                        let isValid = expectedOutput == outputEvents
                        expect(isValid).to(beTrue())
                    }
                }
                
                context("when we receive the submitButtonPressed event") {
                    context("when the fields pass validation") {
                        beforeEach {
                            fakeFieldValidating.stubbedUsernameResult = true
                            fakeFieldValidating.stubbedPasswordResult = true
                            fakeCoronaService.stubbedReturn = "FakeCorona"
                            inputEventSource.onNext(.submitButtonPressed(.username("goodstuff"), .password("moregoodstuff")))
                        }
                        
                        it("should have output a startedLoading, followed by a success() state followed by a finishedLoading state") {
                            let expectedOutput: [LoginViewState] = [.startedLoading, .success("FakeCorona"), .finishedLoading]
                            let isValid = expectedOutput == outputEvents
                            expect(isValid).to(beTrue())
                        }
                    }
                    
                    context("when either field does not pass valiadation") {
                        beforeEach {
                            fakeFieldValidating.stubbedUsernameResult = true
                            fakeFieldValidating.stubbedPasswordResult = false
                            inputEventSource.onNext(.submitButtonPressed(.username("goodstuff"), .password("badstuff")))
                        }
                        
                        it("should have output a validity state for the username field followed by the password field") {
                            let expectedOutput: [LoginViewState] = [.username(true), .password(false)]
                            let isValid = expectedOutput == outputEvents
                            expect(isValid).to(beTrue())
                        }
                        
                    }
                    
                }
            }
        }
    }
}

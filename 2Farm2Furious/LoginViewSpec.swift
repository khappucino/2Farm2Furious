import Quick
import Nimble
import RxSwift
import UIKit
import KIF_Quick

@testable import _Farm2Furious

class LoginViewSpec: KIFSpec {
    override func spec() {
        describe("LoginView") {
            var subject: LoginView!
            var outputEvents: [LoginViewEvent]!
            let disposeBag = DisposeBag()
            var window: UIWindow!
            beforeEach {
                window = UIApplication.shared.delegate!.window!
                
                outputEvents = [LoginViewEvent]()
                
                subject = LoginView(frame: .zero)
                
                attachViewToScreen(window: window , viewToBeAttached: subject)
                
                subject.validatedTextStream().subscribe(onNext: { (outputEvent) in
                    outputEvents.append(outputEvent)
                }).disposed(by: disposeBag)
                
                viewTester().usingIdentifier(LoginView.usernameTextfieldID).waitForView()
                
            }
            
            describe("username text field") {
                context("when we enter text into the username textfield ") {
                    beforeEach {
                        viewTester().usingIdentifier(LoginView.usernameTextfieldID).enterText("xyz")
                    }
                    
                    it("should emit a LoginViewEvent") {
                        let expectedEvents: [LoginViewEvent] = [.textChanged(.username("x")),
                                                               .textChanged(.username("xy")),
                                                               .textChanged(.username("xyz"))]
                        let isValid = expectedEvents == outputEvents
                        expect(isValid).to(beTrue())
                    }
                }
                
                context("when we leave the textfield") {
                    context("when the textfield still has stuff in it") {
                        beforeEach {
                            viewTester().usingIdentifier(LoginView.usernameTextfieldID).enterText("x")
                            subject.usernameTextField.resignFirstResponder()
                        }
                        
                        it("should emit a LoginViewEvent") {
                            let expectedEvents: [LoginViewEvent] = [.textChanged(.username("x")), // entering text
                                .textChanged(.username("x")), // fires on exit
                                .textChanged(.username("x"))] // fires on exit
                            let isValid = expectedEvents == outputEvents
                            expect(isValid).to(beTrue())
                        }
                    }
                    
                    context("when the textfield is empty when we end editing") {
                        beforeEach {
                            viewTester().usingIdentifier(LoginView.usernameTextfieldID).enterText("")
                            subject.usernameTextField.resignFirstResponder()
                        }
                        
                        it("should emit a LoginViewEvent") {
                            let expectedEvents: [LoginViewEvent] = [.textChanged(.username(""))] // fires on exit
                            let isValid = expectedEvents == outputEvents
                            expect(isValid).to(beTrue())
                        }
                    }
                }
            }
        }
    }
}


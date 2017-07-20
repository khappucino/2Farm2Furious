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
            var outputEvents: [LoginViewAction]!
            let disposeBag = DisposeBag()
            var window: UIWindow!
            beforeEach {
                window = UIApplication.shared.delegate!.window!
                
                outputEvents = [LoginViewAction]()
                
                subject = LoginView(frame: .zero)
                
                attachViewToScreen(window: window , viewToBeAttached: subject)
                
                subject.validatedTextStream().subscribe(onNext: { (outputEvent) in
                    outputEvents.append(outputEvent)
                }).disposed(by: disposeBag)
                
                viewTester().usingIdentifier(LoginView.usernameTextfieldID).waitForView()
                
            }
            
            describe("username text field") {
                describe("when we enter text into the username textfield ") {
                    beforeEach {
                        outputEvents = [LoginViewAction]()
                        viewTester().usingIdentifier(LoginView.usernameTextfieldID).enterText("xyz")
                    }
                    
                    it("should emit a LoginViewAction") {
                        let expectedEvents: [LoginViewAction] = [.textChanged(.username("x")),
                                                               .textChanged(.username("xy")),
                                                               .textChanged(.username("xyz"))]
                        let isValid = expectedEvents == outputEvents
                        expect(isValid).to(beTrue())
                    }
                }
                
                describe("when we leave the textfield") {
                    context("when the textfield still has text in it") {
                        beforeEach {
                            outputEvents = [LoginViewAction]()
                            viewTester().usingIdentifier(LoginView.usernameTextfieldID).enterText("x")
                            subject.usernameTextField.resignFirstResponder()
                        }
                        
                        it("should emit a LoginViewAction") {
                            let expectedEvents: [LoginViewAction] = [.textChanged(.username("x")), // entering text
                                                                    .textChanged(.username("x")), // fires on exit
                                                                    .textChanged(.username("x"))] // fires on exit
                            let isValid = expectedEvents == outputEvents
                            expect(isValid).to(beTrue())
                        }
                    }
                    
                    context("when the textfield is empty when we end editing") {
                        beforeEach {
                            outputEvents = [LoginViewAction]()
                            viewTester().usingIdentifier(LoginView.usernameTextfieldID).enterText("")
                            subject.usernameTextField.resignFirstResponder()
                        }
                        
                        it("should emit a LoginViewAction") {
                            let expectedEvents: [LoginViewAction] = [.textChanged(.username(""))] // fires on exit
                            let isValid = expectedEvents == outputEvents
                            expect(isValid).to(beTrue())
                        }
                    }
                }
            }
            describe("password text field") {
                describe("when we enter text into the username textfield ") {
                    beforeEach {
                        outputEvents = [LoginViewAction]()
                        viewTester().usingIdentifier(LoginView.passwordTextfieldID).enterText("xyz")
                    }
                    
                    it("should emit a LoginViewAction") {
                        let expectedEvents: [LoginViewAction] = [.textChanged(.password("x")),
                                                                .textChanged(.password("xy")),
                                                                .textChanged(.password("xyz"))]
                        let isValid = expectedEvents == outputEvents
                        expect(isValid).to(beTrue())
                    }
                }
                
                describe("when we leave the textfield") {
                    context("when the textfield still has text in it") {
                        beforeEach {
                            outputEvents = [LoginViewAction]()
                            viewTester().usingIdentifier(LoginView.passwordTextfieldID).enterText("x")
                            subject.passwordTextField.resignFirstResponder()
                        }
                        
                        it("should emit a LoginViewAction") {
                            let expectedEvents: [LoginViewAction] = [.textChanged(.password("x")), // entering text
                                                                    .textChanged(.password("x")), // fires on exit
                                                                    .textChanged(.password("x"))] // fires on exit
                            let isValid = expectedEvents == outputEvents
                            print(outputEvents)
                            expect(isValid).to(beTrue())
                        }
                    }
                    
                    context("when the textfield is empty when we end editing") {
                        beforeEach {
                            outputEvents = [LoginViewAction]()
                            viewTester().usingIdentifier(LoginView.passwordTextfieldID).enterText("")
                            subject.passwordTextField.resignFirstResponder()
                        }
                        
                        it("should emit a LoginViewAction") {
                            let expectedEvents: [LoginViewAction] = [.textChanged(.password(""))] // fires on exit
                            let isValid = expectedEvents == outputEvents
                            expect(isValid).to(beTrue())
                        }
                    }
                }
            }
            
            describe("the submit button") {
                describe("when we tap the submit button") {
                    beforeEach {
                        
                        // no matter what is in the textfields we just propagate the values
                        viewTester().usingIdentifier(LoginView.usernameTextfieldID).enterText("whatever value")
                        viewTester().usingIdentifier(LoginView.passwordTextfieldID).enterText("")
                        
                        outputEvents = [LoginViewAction]()
                        
                        viewTester().usingIdentifier(LoginView.submitButtonID).tap()
                    }
                    
                    it("should emit a LoginViewAction") {
                        let expectedEvents: [LoginViewAction] = [.submitButtonPressed(.username("whatever value"), .password(""))]
                        let isValid = expectedEvents == outputEvents
                        expect(isValid).to(beTrue())
                    }
                }
            }
        }
    }
}


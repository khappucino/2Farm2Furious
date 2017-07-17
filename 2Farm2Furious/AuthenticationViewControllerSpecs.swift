import Quick
import Nimble
import Swinject
import SwinjectStoryboard

@testable import _Farm2Furious

class AuthenticationViewControllerSpecs: QuickSpec {
    override func spec() {
        
        describe("AuthenticationViewController") {
            var subject: AuthenticationViewController!
            var testContainer: Container!
            var fakeKitchen: FakeAuthenticationKitchener!
            var fakeRouter: FakeAuthenticationVCRouting!
            var fakeLoginView: FakeLoginView!
            
            beforeEach {
                fakeKitchen = FakeAuthenticationKitchener()
                fakeRouter = FakeAuthenticationVCRouting()
                fakeLoginView = FakeLoginView()
                
                testContainer = Container()
                applyMainAssemblyToContainer(container: testContainer)
                
                testContainer.register(AuthenticationKitchener.self) { _ in
                    return fakeKitchen
                }
                testContainer.register(AuthenticationVCRouting.self) { _ in
                    return fakeRouter
                }
                testContainer.register(LoginView.self) { _ in
                    return fakeLoginView
                }
            }
            
            context("when the controller receives events from the loginview") {
                var sentEvents: [LoginViewEvent]!
                beforeEach {
                    subject = createViewControllerWithIdentifier(AuthenticationViewController.ID, container: testContainer) as! AuthenticationViewController
                    subject.loadViewIfNeeded()
                  
                    sentEvents = [.textChanged(.username("username")),
                                                    .textChanged(.password("password")),
                                                    .submitButtonPressed(.username("username1"), .password("password1"))]
                    fakeLoginView.sendFakeEvents(events: sentEvents)
                }
                
                it("should have sent all the events to the kitchen") {
                    let receivedEvents = fakeKitchen.receivedEvents
                    let isEqual = receivedEvents == sentEvents
                    expect(isEqual).toEventually(beTrue())
                }
            }
            
            context("when the kitchen emits vcstate events") {
                
                beforeEach {
                    subject = createViewControllerWithIdentifier(AuthenticationViewController.ID, container: testContainer) as! AuthenticationViewController
                    subject.loadViewIfNeeded()
                }
                
                context("when we receive the startedLoading vcstate event") {
                    beforeEach {
                        fakeKitchen.pumpVCState(vcState: .startedLoading)
                    }
                    it("should have made the loading indicator visible") {
                        expect(subject.loadingIndicator.isHidden).to(beFalse())
                    }
                }
                
                context("when we receive the finishedLoading vcstate event") {
                    beforeEach {
                        fakeKitchen.pumpVCState(vcState: .finishedLoading)
                    }
                    it("should have made the loading indicator visible") {
                        expect(subject.loadingIndicator.isHidden).to(beTrue())
                    }
                }
                
                context("when we receice the routeToAllTheThings vcstate event") {
                    beforeEach {
                        fakeKitchen.pumpVCState(vcState: .success("cow"))
                    }
                    it("should have made the loading indicator visible") {
                        expect(fakeRouter.recordedQuery).to(equal("cow"))
                    }
                }
                
                context("when we receive usernameState vcstate event") {
                    beforeEach {
                        fakeKitchen.pumpVCState(vcState: .username(true))
                    }
                    it("should have updated the loginview with the username vcstate event") {
                        expect(fakeLoginView.recordedState!).to(equal( .username(true)))
                    }
                }
                
                context("when we receive usernameState vcstate event") {
                    beforeEach {
                        fakeKitchen.pumpVCState(vcState: .password(true))
                    }
                    it("should have updated the loginview with the username vcstate event") {
                        expect(fakeLoginView.recordedState!).to(equal( .password(true)))
                    }
                }
            }
        }
    }
}

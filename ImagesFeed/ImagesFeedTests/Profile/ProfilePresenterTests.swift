//
//  ProfilePresenterTests.swift
//  ImagesFeedTests
//
//  Created by Lolita Chernysheva on 05.02.2024.
//  
//

import XCTest
@testable import ImagesFeed

final class ProfilePresenterTests: XCTestCase {
    
    private var coordinator: DummyCoordinator!
    private var view: MockProfileViewController!
    private var sut: ProfilePresenter!
    
    override func setUp() {
        view = MockProfileViewController()
        coordinator = DummyCoordinator()
        sut = ProfilePresenter(view: view, coordinator: coordinator)
        OAuth2TokenStorage.shared.token = "Foo"
    }
    
    override func tearDown() {
        view = nil
        sut = nil
        AccountData.shared.userProfile = nil
        OAuth2TokenStorage.shared.token = nil
    }
    
    func testFetchUserInfo() {
        AccountData.shared.userProfile = .init(userName: "Bar", fullName: "Baz", bio: "Foo", avatar: "")
        sut.fetchUserInfo()
        XCTAssertEqual(view.model.fullName, "Baz")
    }
    
    func testLogoutRemoveToken() {
        sut.logout()
        XCTAssertFalse(OAuth2TokenStorage.shared.hasToken())
    }
    
    func testLogoutMoveToRootSplash() {
        sut.logout()
        XCTAssertTrue(coordinator.didCallGoToSplash)
    }
}

private extension ProfilePresenterTests {
    
    class MockProfileViewController: ProfileViewProtocol {
        var model = ProfileModel.empty
        func displayProfile(with model: ProfileModel) {
            self.model = model
        }
    }
    
    class DummyCoordinator: CoordinatorProtocol {
        
        var didCallGoToSplash: Bool = false
        
        func start(window: UIWindow) {}
        
        func showMainTabbarController() {}
        
        func showDetail(forImageNamed imageName: String) {}
        
        func showWebView(delegate: ImagesFeed.WebViewViewControllerDelegate) {}
        
        func showAuthController(delegate: ImagesFeed.AuthViewControllerDelegate) {}
        
        func goToRootSplash() {
            didCallGoToSplash = true
        }
    }
}

//
//  ImagesListPresenterTests.swift
//  ImagesFeedTests
//
//  Created by Lolita Chernysheva on 06.02.2024.
//  
//

import XCTest
@testable import ImagesFeed

final class ImagesListPresenterTests: XCTestCase {
    
    private var view: MockImagesListViewController!
    private var sut: ImagesListPresenter!
    private var coordinator: DummyCoordinator!

    override func setUp() {
        view = MockImagesListViewController()
        coordinator = DummyCoordinator()
        sut = .init(view: view, coordinator: coordinator)
    }

    override func tearDown() {
        view = nil
        sut = nil
    }
    
    func testFetchPhotosNextPage() {
        
    }
    
}

private extension ImagesListPresenterTests {
    
    class MockImagesListViewController: ImagesListViewProtocol {
        func displayData(data: ImagesFeed.ImagesListScreenModel, reloadData: Bool) { }
        
        func showActivityIndicator() {}
        
        func hideActivityIndicator() {}
    }
    
    class DummyCoordinator: CoordinatorProtocol {
        
        func start(window: UIWindow) {}
        
        func showMainTabbarController() {}
        
        func showDetail(forImageNamed imageName: String) {}
        
        func showWebView(delegate: ImagesFeed.WebViewViewControllerDelegate) {}
        
        func showAuthController(delegate: ImagesFeed.AuthViewControllerDelegate) {}
        
        func goToRootSplash() {}
    }
}

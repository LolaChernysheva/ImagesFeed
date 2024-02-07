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
    private var imagesService: MockImagesListService!

    override func setUp() {
        view = MockImagesListViewController()
        coordinator = DummyCoordinator()
        imagesService = MockImagesListService()
        sut = .init(view: view, coordinator: coordinator, imagesService: imagesService)
        OAuth2TokenStorage.shared.token = "Foo"
    }

    override func tearDown() {
        view = nil
        sut = nil
        coordinator = nil
        imagesService = nil
        OAuth2TokenStorage.shared.token = nil
    }
    
    func testFetchPhotosNextPage() {
        // Создание ожидания
        let expectation = XCTestExpectation(description: "fetchPhotosNextPage completes")
        
        // Установка колбэка для удовлетворения ожидания
        imagesService.fetchPhotosNextPageHandler = {
            expectation.fulfill()
        }
        
        // Вызов асинхронного метода
        sut.fetchPhotosNextPage()
        
        // Ожидание выполнения с таймаутом
        wait(for: [expectation], timeout: 5.0)
    }
    
    func testWhenFetchPhotosNextPageCallsThenViewReceivedModel() {
        // Создание ожидания
        let expectation = XCTestExpectation(description: "view model completes")
        
        view.displayDataHandler = { [self] in
            if view.model.tableData.sections.count > 0,
               view.model.tableData.sections[0].cells.count > 0 {
                switch view.model.tableData.sections[0].cells[0] {
                case let .imageCell(model):
                    XCTAssertEqual(model.imageString, "Foo")
                    expectation.fulfill()
                }
            } else {
                XCTFail()
            }
        }
        
        // Вызов асинхронного метода
        sut.fetchPhotosNextPage()
        
        // Ожидание выполнения с таймаутом
        wait(for: [expectation], timeout: 5.0)
    }
    
}

private extension ImagesListPresenterTests {
    
    class MockImagesListService: ImagesListServiceProtocol {
        
        
        var fetchPhotosNextPageHandler: () -> Void = {}
        
        func fetchPhotosNextPage(_ token: String, completion: @escaping (Result<[ImagesFeed.PhotoResult], Error>) -> Void) {
            completion(.success([
                .init(
                    id: "Baz",
                    createdAt: "",
                    width: 0,
                    height: 0,
                    description: nil,
                    likes: 0,
                    isLiked: false,
                    user: .init(profileImage: .init(small: "")),
                    urls: .init(raw: "", full: "", regular: "", small: "Foo", thumb: ""))
                ])
            )
            fetchPhotosNextPageHandler()
        }
        
        func changeLike(photoId: String, isLike: Bool, _completion: @escaping (Result<ImagesFeed.PhotoLikeResponce, Error>) -> Void) {}
    }
    
    class MockImagesListViewController: ImagesListViewProtocol {
        
        var model = ImagesListScreenModel.empty
        var displayDataHandler: () -> Void = {}
        
        func displayData(data: ImagesFeed.ImagesListScreenModel, reloadData: Bool) {
            self.model = data
            displayDataHandler()
        }
        
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

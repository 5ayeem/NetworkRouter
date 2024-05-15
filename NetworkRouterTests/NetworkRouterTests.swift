//
//  NetworkRouterTests.swift
//  NetworkRouterTests
//
//  Created by Sayeem Hussain on 10/8/19.
//  Copyright © 2019 sayeem. All rights reserved.
//

import XCTest
@testable import NetworkRouter

final class NetworkRouterTests: XCTestCase {
    
    var sut: Router!
    
    override func setUpWithError() throws {
        let mockSession = MockURLSession()
        let mockSettings = MockNetworkSettings()
        self.sut = Router(
            session: mockSession,
            responseQueue: .main,
            networkConfigurations: mockSettings, 
            authManager: MockSessionManager()
        )
    }
    
    override func tearDownWithError() throws {
        self.sut = nil
        
        try super.tearDownWithError()
    }
    
    func testInit_setsSession() throws {
        _ = try XCTUnwrap(sut.session as? MockURLSession)
    }
    
    func testInit_setsDataTask() throws {
        _ = try XCTUnwrap(
            sut.request(MockAPI.getTest) { (result: Result<MockModel, NetworkResponse>) in } as? MockURLSessionDataTask
        )
    }
    
    func testInit_setsResponseQueueAsMain() {
        XCTAssertEqual(DispatchQueue.main, sut.responseQueue)
    }
    
    func testRequest_calls_correctURL() {
        // GIVEN
        let url = givenURLString()
        // WHEN
        let task = sut.request(MockAPI.getTest) { (result: Result<MockModel, NetworkResponse>) in } as! MockURLSessionDataTask
        // THEN
        XCTAssertEqual(url, task.url!.absoluteString)
    }
    
    func testCancel_isCalled() {
        // GIVEN
        let task = sut.request(MockAPI.getTest) { (result: Result<MockModel, NetworkResponse>) in } as! MockURLSessionDataTask
        // WHEN
        sut.cancel()
        // THEN
        XCTAssertTrue(task.cancelCalled)
    }
    
    func testHandle_given500_returnsFailureResultAndError() {
        // GIVEN
        let route = MockAPI.getTest
        let mockData: Data? = nil
        let response: URLResponse? = given500Response()
        let error: Error? = nil
        
        let expectation = expectation(
            description: "500 did not trigger failure result"
        )
        // WHEN
        sut.handleResponse(
            for: route,
            data: mockData,
            response: response,
            error: error
        ) { (result: Result<MockModel, NetworkResponse>) in
            switch result {
            case .failure(let error):
                // THEN
                XCTAssertTrue(error == NetworkResponse.serverError(500))
                expectation.fulfill()
            default: break
            }
        }
        
        wait(for: [expectation], timeout: 0.5)
    }
    
    func testHandle_given200_returnsSuccessResultAndMockModel() throws {
        // GIVEN
        let route = MockAPI.getTest
        let mockModel = MockModel(text: "Hello test")
        let response: URLResponse? = given200Response()
        let error: Error? = nil
        
        let expectation = expectation(
            description: "200 did not trigger success result"
        )
        // WHEN
        sut.handleResponse(
            for: route,
            data: try mockModel.toData(),
            response: response,
            error: error
        ) { (result: Result<MockModel, NetworkResponse>) in
            switch result {
            case .success(let model):
                // THEN
                XCTAssertEqual(mockModel, model)
                expectation.fulfill()
            default: break
            }
        }
        
        wait(for: [expectation], timeout: 0.5)
    }
    
    func testHandle_givenError_returnsFailureAndError() throws {
        // GIVEN
        let route = MockAPI.getTest
        let mockModel = MockModel(text: "Hello test")
        let response: URLResponse? = nil
        let fakeError: Error = MockError.fakeError
        
        let expectation = expectation(
            description: "Error did not trigger failure result"
        )
        // WHEN
        sut.handleResponse(
            for: route,
            data: try mockModel.toData(),
            response: response,
            error: fakeError
        ) { (result: Result<MockModel, NetworkResponse>) in
            switch result {
            case .failure(let error):
                // THEN
                XCTAssertEqual(
                    error, NetworkResponse.noNetwork
                )
                expectation.fulfill()
            default: break
            }
        }
        
        wait(for: [expectation], timeout: 0.5)
    }
    
    func testHandle_given200_dispatchesToResponseQueue() {
        // GIVEN
        let route = MockAPI.getTest
        let mockData: Data? = Data()
        let response: URLResponse? = given200Response()
        let error: Error? = nil
        
        // WHEN THEN
        thenHandleTriggersResponseQueue(
            route,
            mockData,
            response,
            error
        )
    }
    
    func testHandle_given500_dispatchesToResponseQueue() {
        // GIVEN
        let route = MockAPI.getTest
        let mockData: Data? = nil
        let response: URLResponse? = given500Response()
        let error: Error? = nil
        
        // WHEN THEN
        thenHandleTriggersResponseQueue(
            route,
            mockData,
            response,
            error
        )
    }
    
    func testHandle_givenError_dispatchesToResponseQueue() {
        // GIVEN
        let route = MockAPI.getTest
        let mockData: Data? = nil
        let response: URLResponse? = nil
        let error: Error? = MockError.fakeError
        
        // WHEN THEN
        thenHandleTriggersResponseQueue(
            route,
            mockData,
            response,
            error
        )
    }
    
    func testBuildRequest_givenMockService_createsExpectedRequest() throws {
        // GIVEN
        let urlString = givenURLString()
        let mockService = MockAPI.getTest
        
        // WHEN
        let request = try sut.buildRequest(from: mockService)
        
        // THEN
        XCTAssertEqual(urlString, request.url!.absoluteString)
        XCTAssertEqual(request.httpMethod!.description, mockService.httpMethod.rawValue)
    }
}


// MARK: - Private Helpers

private extension NetworkRouterTests {
    
    func givenURLString() -> String {
        return MockNetworkSettings().baseURLString + MockAPI.getTest.path
    }
    
    func givenURL() -> URL {
        let string = givenURLString()
        return URL(string: string)!
    }
    
    func given200Response() -> HTTPURLResponse {
        let url = givenURL()
        return HTTPURLResponse(
            url: url,
            statusCode: 200,
            httpVersion: nil,
            headerFields: nil
        )!
    }
    
    func given500Response() -> HTTPURLResponse {
        let url = givenURL()
        return HTTPURLResponse(
            url: url,
            statusCode: 500,
            httpVersion: nil,
            headerFields: nil
        )!
    }
    
    func thenHandleTriggersResponseQueue(
        _ route: MockAPI,
        _ data: Data?,
        _ response: URLResponse?,
        _ error: Error?,
        line: UInt = #line
    ) {
        let expectation = expectation(
            description: "Completion wasn't called"
        )
        var currentThread: Thread!
        sut.handleResponse(for: route, data: data, response: response, error: error) { (result: Result<MockModel, NetworkResponse>) in
            currentThread = Thread.current
            expectation.fulfill()
        }
        waitForExpectations(timeout: 0.5) { _ in
            XCTAssertTrue(currentThread.isMainThread, line: line)
        }
    }
}

enum MockError: String, Error {
    case fakeError = "fake error"
}

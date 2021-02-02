//
//  MockURLSession.swift
//  OpenMarketTests
//
//  Created by Jinho Choi on 2021/01/28.
//

import UIKit

class MockURLSessionDataTask: URLSessionDataTask {
    override init() { }
    var resumeDidCall: () -> Void = {}
    
    override func resume() {
        resumeDidCall()
    }
}

class MockURLSession: URLSessionProtocol {
    enum MockAPI {
        case test
        
        static let baseURL = URL(string: "https://camp-open-market.herokuapp.com")!
        var sampleItems: NSDataAsset {
            NSDataAsset.init(name: "items")!
        }
        var sampleItem: NSDataAsset {
            NSDataAsset.init(name: "item")!
        }
    }
    
    var isSuccess = true
    var sessionDataTask: MockURLSessionDataTask?
    var apiRequestType = APIRequestType.loadPage(page: 1)
    var data: Data {
        switch apiRequestType {
        case .loadPage(page: 1):
            return MockAPI.test.sampleItems.data
        default:
            return MockAPI.test.sampleItem.data
        }
    }
    
    init(isSuccess: Bool = true, apiRequestType: APIRequestType) {
        self.isSuccess = isSuccess
        self.apiRequestType = apiRequestType
    }
    
    func dataTask(with request: URLRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
        let successResponse = HTTPURLResponse(url: MockAPI.baseURL,
                                              statusCode: 200,
                                              httpVersion: "2",
                                              headerFields: nil)
        let failureResponse = HTTPURLResponse(url: MockAPI.baseURL,
                                              statusCode: 410,
                                              httpVersion: "2",
                                              headerFields: nil)
        let sessionDataTask = MockURLSessionDataTask()
        
        sessionDataTask.resumeDidCall = {
            if self.isSuccess {
                completionHandler(self.data, successResponse, nil)
            } else {
                completionHandler(nil, failureResponse, nil)
            }
        }
        self.sessionDataTask = sessionDataTask
        return sessionDataTask
    }
}

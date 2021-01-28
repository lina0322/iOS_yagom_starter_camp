//
//  MockURLSession.swift
//  OpenMarketTests
//
//  Created by Jinho Choi on 2021/01/28.
//

import Foundation
import UIKit

class McokURLSessionDataTask: URLSessionDataTask {
    override init() { }
    var resumeDidCall: () -> Void = {}
    
    override func resume() {
        resumeDidCall()
    }
}

class MockURLSession: URLSessionProtocol {
    enum MockAPI {
        case test
        
        static let baseURL = URL(string: "https://camp-open-market.herokuapp.com/")!
        
        var sampleItems: NSDataAsset {
            NSDataAsset.init(name: "items")!
        }
        var sampleItem: NSDataAsset {
            NSDataAsset.init(name: "item")!
        }
    }
    
    var makeRequestSuccess = true
    var apiType = APIType.loadPage(page: 1)
    var data: Data {
        switch apiType {
        case .loadPage(page: 1):
            return MockAPI.test.sampleItems.data
        default:
            return MockAPI.test.sampleItem.data
        }
    }
    
    init(makeRequestSuccess: Bool = true, apiType: APIType) {
        self.makeRequestSuccess = makeRequestSuccess
        self.apiType = apiType
    }
    
    var sessionDataTask: McokURLSessionDataTask?
    
    func dataTask(with request: URLRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
        
        
        let successResponse = HTTPURLResponse(url: MockAPI.baseURL,
                                              statusCode: 200,
                                              httpVersion: "2",
                                              headerFields: nil)
        let failureResponse = HTTPURLResponse(url: MockAPI.baseURL,
                                              statusCode: 410,
                                              httpVersion: "2",
                                              headerFields: nil)
        let sessionDataTask = McokURLSessionDataTask()
        
        sessionDataTask.resumeDidCall = {
            if self.makeRequestSuccess {
                completionHandler(self.data, successResponse, nil)
            } else {
                completionHandler(nil, failureResponse, nil)
            }
        }
        self.sessionDataTask = sessionDataTask
        return sessionDataTask
    }
}

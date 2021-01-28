//
//  MockURLSession.swift
//  OpenMarketTests
//
//  Created by Jinho Choi on 2021/01/28.
//

import Foundation
import UIKit
@testable import OpenMarket


class McokURLSessionDataTask: URLSessionDataTask {
    override init() { }
    var resumeDidCall: () -> Void = {}
    
    override func resume() {
        resumeDidCall()
    }
}

// MARK: -MockAPI
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

class MockURLSession: URLSessionProtocol {
    
    var makeRequestSuccess = true
    init(makeRequestSuccess: Bool = true) {
        self.makeRequestSuccess = makeRequestSuccess
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
                completionHandler(MockAPI.test.sampleItems.data, successResponse, nil)
            } else {
                completionHandler(nil, failureResponse, nil)
            }
        }
        self.sessionDataTask = sessionDataTask
        return sessionDataTask
    }
}

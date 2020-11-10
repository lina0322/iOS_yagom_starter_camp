//
//  WebBrowser - ViewController.swift
//  Created by yagom. 
//  Copyright © yagom. All rights reserved.
// 

import UIKit
import WebKit

class ViewController: UIViewController {

    @IBOutlet weak var webView: WKWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        webView.load(favoriteWebPage: .google)
    }
}

extension WKWebView {
    /// 즐겨찾는 웹페이지
    enum FavoriteWebPage: String {
        case google = "https://www.google.com/"
        case yagomdDotNet = "https://yagom.net/"
        case naver = "https://www.naver.com/"
    }
    
    /// 즐겨찾는 웹페이지 불러오기
    func load(favoriteWebPage: FavoriteWebPage) {
        guard let url = URL(string: favoriteWebPage.rawValue) else {
            fatalError("URL 변환 실패")
        }
        
        let request: URLRequest = URLRequest(url: url)
        
        load(request)
    }
}

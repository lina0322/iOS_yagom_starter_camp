//
//  WebBrowser - ViewController.swift
//  Created by yagom. 
//  Copyright © yagom. All rights reserved.
// 

import UIKit
import WebKit

final class ViewController: UIViewController {

    @IBOutlet weak var webView: WKWebView!
    @IBOutlet weak var goForwardButton: UIBarButtonItem!
    @IBOutlet weak var goBackButton: UIBarButtonItem!
    @IBOutlet weak var reloadButton: UIBarButtonItem!
    @IBOutlet weak var inputText: UITextField! // 텍스트 필드로할지, 서치바로할지 고민하다가 일단 텍스트필드로 했어요!
    @IBOutlet weak var goInputUrlButton: UIButton!
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        // viewDidLoad()에서는 view가 아직 view hierarchy에 추가되지 않아서 alert을 present할 수 없다.
        // viewDidApear()는 view가 view hierarchy에 추가된 후 호출되므로 alert을 present할 수 있다.
        guard webView.load(favoriteWebPageURL: .google) else {
            return showError()
        }
    }
    
    func showError() {
        let errorAlert = UIAlertController(title: "Error!", message: "입력한 주소가 올바른 형태가 아닙니다.", preferredStyle: .alert)
        let ok = UIAlertAction(title: "확인", style: .default, handler: nil)
        errorAlert.addAction(ok)
        
        self.present(errorAlert, animated: false)
    }
    
    @IBAction func goForwardButton(_ sender: UIBarButtonItem) {
        if webView.canGoForward { webView.goForward() }
    }
    
    @IBAction func goBackButton(_ sender: UIBarButtonItem) {
        if webView.canGoBack { webView.goBack() }
    }
    
    @IBAction func reloadButton(_sender: UIBarButtonItem) {
        webView.reload()
    }
    
    @IBAction func goInputUrlButton(_ sender: UIBarButtonItem) {
        guard let newUrl = inputText.text, let validUrl = makeValidUrl(url: newUrl), webView.load(urlString: validUrl) else {
            return showError()
        }
    }
    
    func validateyUrl(url: String?) -> Bool {
        let urlRegEx = "^https?://[\\w]+.[\\w]+"
        
        return NSPredicate(format: "SELF MATCHES %@", urlRegEx).evaluate(with: url)
    }
    
    // 이것만으로 주소값이 유효하다고 볼 수는 없을 것 같음. 실제로 열리는 url인지 확인하는 방법이 필요함
    // 우선 https://를 붙이는 작업만 시도!
    func makeValidUrl(url: String) -> String? {
        if !validateyUrl(url: url) {
            return "https://" + url
        }
        return url
    }
}

extension WKWebView {
    enum FavoriteWebPageURL: String {
        case google = "https://www.google.com/"
        case yagomDotNet = "https://yagom.net/"
        case naver = "https://www.naver.com/"
    }
    
    /// 즐겨찾는 웹페이지 불러오기
    func load(favoriteWebPageURL: FavoriteWebPageURL) -> Bool {
        guard load(urlString: favoriteWebPageURL.rawValue) else {
            print("즐겨찾는 웹페이지의 URL값이 잘못됨")
            return false
        }
        
        return true
    }
    
    /// URL 불러오기
    func load(urlString: String) -> Bool {
        guard let url = URL(string: urlString) else {
            print("URL값이 잘못됨")
            return false
        }
        
        let request: URLRequest = URLRequest(url: url)
        load(request)
        
        return true
    }
}

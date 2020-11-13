//
//  WebBrowser - ViewController.swift
//  Created by yagom. 
//  Copyright © yagom. All rights reserved.
// 

import UIKit
import WebKit

final class ViewController: UIViewController {
    // MARK: - IBOutlets
    @IBOutlet weak var webView: WKWebView!
    @IBOutlet weak var urlTextField: UITextField!
    @IBOutlet weak var goBackButton: UIBarButtonItem!
    @IBOutlet weak var goForwardButton: UIBarButtonItem!
    
    // MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        webView.navigationDelegate = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        // viewDidLoad()에서는 view가 아직 view hierarchy에 추가되지 않아서 alert을 present할 수 없다.
        // viewDidApear()는 view가 view hierarchy에 추가된 후 호출되므로 alert을 present할 수 있다.
        guard webView.load(favoriteWebPageURL: .google) else {
            return showError(error: .url)
        }
    }
    
    // MARK: - Types & IBActions & Methods
    enum ErrorMessage: String {
        case url = "입력한 주소가 올바른 형태가 아닙니다."
    }
    
    func showError(error: ErrorMessage) {
        let errorAlert = UIAlertController(title: "Error!", message: error.rawValue, preferredStyle: .alert)
        let ok = UIAlertAction(title: "확인", style: .default, handler: nil)
        errorAlert.addAction(ok)
        
        self.present(errorAlert, animated: false)
    }
    
    @IBAction func goForwardPage(_ sender: UIBarButtonItem) {
        webView.goForward()
    }
    
    @IBAction func goBackPage(_ sender: UIBarButtonItem) {
        webView.goBack()
    }
    
    @IBAction func reloadPage(_sender: UIBarButtonItem) {
        webView.reload()
    }
    
    @IBAction func loadPage(_ sender: UIBarButtonItem) {
        guard let newUrl = urlTextField.text, validateUrl(newUrl), webView.load(urlString: newUrl) else {
            return showError(error: .url)
        }
    }
    
    func makeValidUrl(url: String) -> String? {
        if !validateyUrl(url: url) {
            return "https://" + url
        }
        return url
    
	func validateUrl(_ url: String?) -> Bool {
        // 정규표현식으로 URL 검증
        let urlRegex = "((http|https)://)[\\S]+"
        
        return NSPredicate(format: "SELF MATCHES %@", urlRegex).evaluate(with: url)
    }
}

// MARK: - WKNavigationDelegate Methods
extension ViewController: WKNavigationDelegate {
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        // 주소 입력 필드에 현재 URL 표시
        urlTextField.text = webView.url?.absoluteString
 
        // 앞/뒤로 갈 수 있을때 버튼 활성화, 못가면 비활성화
        goForwardButton.isEnabled = webView.canGoForward
        goBackButton.isEnabled = webView.canGoBack
    }
}

// MARK: - WKWebView Extension
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

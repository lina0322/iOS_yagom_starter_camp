//
//  WebBrowser - ViewController.swift
//  Created by yagom. 
//  Copyright © yagom. All rights reserved.
// 

import UIKit
import WebKit

final class ViewController: UIViewController {

    @IBOutlet weak var webView: WKWebView!
    @IBOutlet weak var userInput: UITextField! // 텍스트 필드로할지, 서치바로할지 고민하다가 일단 텍스트필드로 했어요!
    @IBOutlet weak var goInputUrlButton: UIButton!
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        // viewDidLoad()에서는 view가 아직 view hierarchy에 추가되지 않아서 alert을 present할 수 없다.
        // viewDidApear()는 view가 view hierarchy에 추가된 후 호출되므로 alert을 present할 수 있다.
        guard webView.load(favoriteWebPageURL: .google) else {
            return showError(error: .urlError)
        }
    }
    
    enum ErrorMessage: String {
        case urlError = "입력한 주소가 올바른 형태가 아닙니다."
        case noBackePage = "이전 페이지가 없습니다."
        case noForwardPage = "돌아갈 페이지가 없습니다."
    }
    
    func showError(error: ErrorMessage) {
        let errorAlert = UIAlertController(title: "Error!", message: error.rawValue, preferredStyle: .alert)
        let ok = UIAlertAction(title: "확인", style: .default, handler: nil)
        errorAlert.addAction(ok)
        
        self.present(errorAlert, animated: false)
    }
    
    @IBAction func goForwardPage(_ sender: UIBarButtonItem) {
        if webView.canGoForward { webView.goForward() }
        else { showError(error: .noForwardPage)  }
    }
    
    @IBAction func goBackPage(_ sender: UIBarButtonItem) {
        if webView.canGoBack { webView.goBack() }
        else { showError(error: .noBackePage)  }
    }
    
    @IBAction func reloadPage(_sender: UIBarButtonItem) {
        webView.reload()
    }
    
    @IBAction func goInputUrlButton(_ sender: UIBarButtonItem) {
        guard validateyUrl(url: inputText.text), let newURL = inputText.text,  webView.load(urlString: newURL) else {
            return showError()
        }
    }
    
    func validateyUrl(url: String?) -> Bool {
        let UrlRegex = "^https?://[\\w]+.[\\w]+"
        
        return NSPredicate(format: "SELF MATCHES %@", UrlRegex).evaluate(with: url)
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

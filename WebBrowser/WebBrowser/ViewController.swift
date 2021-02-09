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
    
    // MARK: - Types
    enum ErrorMessage: String {
        case url = "입력한 주소가 올바른 형태가 아닙니다."
    }
    
    // MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        webView.navigationDelegate = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        openPage(url: "https://www.google.com/")
    }
    
    // MARK: - IBActions & Methods
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
        guard var newUrl = urlTextField.text else {
            return showError(error: .url)
        }
        
        if !checkFront(of: newUrl) {
            newUrl = addHttpsFront(of: newUrl)
        }
        
        openPage(url: newUrl)
    }
    
    func openPage(url: String) {
        guard let url = URL(string: url) else {
            return showError(error: .url)
        }
        
        let request: URLRequest = URLRequest(url: url)
        webView.load(request)
    }
    
    func showError(error: ErrorMessage) {
        let errorAlert = UIAlertController(title: "Error!", message: error.rawValue, preferredStyle: .alert)
        let ok = UIAlertAction(title: "확인", style: .default, handler: nil)
        errorAlert.addAction(ok)
        
        self.present(errorAlert, animated: false)
    }
    
    func addHttpsFront(of url: String) -> String {
        return "https://" + url
    }
    
    func checkFront(of url: String?) -> Bool {
        let urlRegex = "((http|https)://)[\\S]+"
        
        return NSPredicate(format: "SELF MATCHES %@", urlRegex).evaluate(with: url)
    }
}

// MARK: - WKNavigationDelegate Methods
extension ViewController: WKNavigationDelegate {
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        // 주소 입력 필드에 현재 URL 표시
        urlTextField.text = webView.url?.absoluteString
        
        goForwardButton.isEnabled = webView.canGoForward
        goBackButton.isEnabled = webView.canGoBack
    }
    
    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        showError(error: .url)
    }
}

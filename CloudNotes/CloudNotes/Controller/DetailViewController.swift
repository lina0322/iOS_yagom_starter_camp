//
//  DetailViewController.swift
//  CloudNotes
//
//  Created by 김태형 on 2021/02/19.
//

import UIKit

class DetailViewController: UIViewController, UITextViewDelegate {
    let textView = UITextView()
    var memoTitle: String = ""
    var memoBody: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpTextView()
    }
    
    func setUpTextView() {
        view.addSubview(textView)
        textView.delegate = self
        textView.translatesAutoresizingMaskIntoConstraints = false
        let content = NSMutableAttributedString(string: "\(memoTitle) \n \(memoBody)")
        content.addAttribute(NSAttributedString.Key.font, value: UIFont.systemFont(ofSize: 20.0), range: NSMakeRange(0, memoTitle.count))
        textView.attributedText = content
        
        let safeLayoutGuide = view.safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            textView.leadingAnchor.constraint(equalTo: safeLayoutGuide.leadingAnchor),
            textView.trailingAnchor.constraint(equalTo: safeLayoutGuide.trailingAnchor),
            textView.topAnchor.constraint(equalTo: safeLayoutGuide.topAnchor),
            textView.bottomAnchor.constraint(equalTo: safeLayoutGuide.bottomAnchor)
        ])
    }
}


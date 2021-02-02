//
//  SecondViewController.swift
//  AutoLayoutStudy
//
//  Created by 리나 on 2021/01/12.
//

import UIKit

class SecondViewController: UIViewController {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var topViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var label: UILabel!
    @IBOutlet var views: [UIView]!
    
    let topViewMinHeight: CGFloat = 100
    let topViewMaxHeight: CGFloat = 190
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpAllViewRoundCorner()

        tableView.contentInset = UIEdgeInsets(top: topViewHeightConstraint.constant, left: 0, bottom: 0, right: 0)
        tableView.scrollIndicatorInsets = tableView.contentInset
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.navigationBar.setNavigationBarTranslucent()
    }
    
    private func setUpAllViewRoundCorner() {
        for view in views {
            view.setUpRoundCorner()
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let yOffset = scrollView.contentOffset.y
        if yOffset < -topViewMaxHeight {
            topViewHeightConstraint.constant = topViewMaxHeight
        } else if yOffset < -topViewMinHeight {
            topViewHeightConstraint.constant = yOffset * -1
        } else {
            topViewHeightConstraint.constant = topViewMinHeight
        }
    }
}

extension SecondViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 10
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        var content = cell.defaultContentConfiguration()

        content.text = "content"
        cell.contentConfiguration = content
        return cell
    }
}

extension UINavigationBar {
    func setNavigationBarTranslucent() {
        setBackgroundImage(UIImage(), for: .default)
        shadowImage = UIImage()
        isTranslucent = true
    }
}

extension UIView {
    func setUpRoundCorner() {
        self.layer.cornerRadius = 7
    }
}

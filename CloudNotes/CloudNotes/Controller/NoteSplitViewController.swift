//
//  NoteSplitViewController.swift
//  CloudNotes
//
//  Created by 김태형 on 2021/02/19.
//

import UIKit

final class NoteSplitViewController: UISplitViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
        view.backgroundColor = .white
        setControllers()
    }
    
    private func setControllers() {
        let tableView:UIViewController = NoteTableViewController()
        let detailView:UIViewController = DetailViewController()
        let navigationController = UINavigationController(rootViewController: tableView)
        
        self.preferredDisplayMode = .oneBesideSecondary
        self.viewControllers = [navigationController, detailView]
    }
}

extension NoteSplitViewController: UISplitViewControllerDelegate {
    func splitViewController(_ splitViewController: UISplitViewController, collapseSecondary secondaryViewController: UIViewController, onto primaryViewController: UIViewController) -> Bool {
        return true
    }
}

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
        delegate = self
        view.backgroundColor = .white
        setControllers()
    }
    
    private func setControllers() {
        let tableView = NoteTableViewController()
        let navigationController = UINavigationController(rootViewController: tableView)
        
        preferredDisplayMode = .oneBesideSecondary
        viewControllers = [navigationController]
    }
}

extension NoteSplitViewController: UISplitViewControllerDelegate {
    func splitViewController(_ splitViewController: UISplitViewController, collapseSecondary secondaryViewController: UIViewController, onto primaryViewController: UIViewController) -> Bool {
        return true
    }
}

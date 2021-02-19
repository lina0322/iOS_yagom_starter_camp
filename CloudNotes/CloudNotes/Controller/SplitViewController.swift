//
//  SplitViewController.swift
//  CloudNotes
//
//  Created by 김태형 on 2021/02/19.
//

import UIKit

class SplitViewController: UISplitViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
        self.preferredDisplayMode = .oneBesideSecondary
        view.backgroundColor = .white
        let tableView:UIViewController = NoteViewController()
        let detailView:UIViewController = DetailViewController()
        let navigationController = UINavigationController(rootViewController: tableView)
        self.viewControllers = [navigationController, detailView]
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

extension SplitViewController: UISplitViewControllerDelegate {
    func splitViewController(_ splitViewController: UISplitViewController, collapseSecondary secondaryViewController: UIViewController, onto primaryViewController: UIViewController) -> Bool {
        return true
    }
}

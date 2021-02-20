//
//  SplitViewController.swift
//  CloudNotes
//
//  Created by 리나 on 2021/02/19.
//

import UIKit

final class NoteSplitViewController: UISplitViewController, UISplitViewControllerDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
        view.backgroundColor = .white
        setControllers()
    }

    private func setControllers() {
        let noteViewController = NoteViewController()
        let detailViewController = DetailViewController()
        let NoteNavigationController = UINavigationController(rootViewController: noteViewController)
        
        viewControllers = [NoteNavigationController, detailViewController]
        preferredPrimaryColumnWidthFraction = 1/3
        preferredDisplayMode = .oneBesideSecondary
    }
    
    func splitViewController(_ splitViewController: UISplitViewController, collapseSecondary secondaryViewController: UIViewController, onto primaryViewController: UIViewController) -> Bool {
        return true
    }
}

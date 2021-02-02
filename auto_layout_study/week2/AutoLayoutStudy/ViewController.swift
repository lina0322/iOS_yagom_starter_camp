//
//  ViewController.swift
//  AutoLayoutStudy
//
//  Created by Yeon on 2020/12/23.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var totalContactCount: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpSearchBar()
        totalContactCount.text = "\(Data.list.count) Contacts"
    }
    
    private func setUpSearchBar() {
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchBar.placeholder = "Search"
        self.navigationItem.searchController = searchController
        self.navigationItem.hidesSearchBarWhenScrolling = false
    }
}

extension ViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return Data.firstCharactors.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section < Data.firstCharactors.count {
            let rowData = Data.list.filter{ $0.first == Data.firstCharactors[section].first }
            return rowData.count
        } else {
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var index = 0
        for i in 0..<Data.sortedList.count {
            if Data.sortedList[i].first == Data.firstCharactors[indexPath.section].first {
                index = i
                break
            }
        }
        let selectedData = Data.sortedList[index + indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        var content = cell.defaultContentConfiguration()
        
        content.text = selectedData
        cell.contentConfiguration = content
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section < Data.firstCharactors.count {
            return Data.firstCharactors[section]
        } else {
            return nil
        }
    }
}

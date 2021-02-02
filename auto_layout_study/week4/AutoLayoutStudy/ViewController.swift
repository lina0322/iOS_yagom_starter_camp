//
//  ViewController.swift
//  AutoLayoutStudy
//
//  Created by Yeon on 2020/12/23.
//

import UIKit

class ViewController: UIViewController {
    
    let tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(CustomCell.self, forCellReuseIdentifier: CustomCell.identifier)
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()
    }
    
    private func configureTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        
        addTableViewToView()
        addTableViewConstraint()
    }
    
    private func addTableViewToView() {
        view.addSubview(tableView)
    }
    
    private func addTableViewConstraint() {
        let safeArea = view.safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: safeArea.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor)
        ])
    }
}

// MARK: - Table View
extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ContactsList.data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CustomCell.identifier, for: indexPath) as? CustomCell else {
            return UITableViewCell()
        }
        
        cell.titleLabel.text = ContactsList.keyList[indexPath.row]
        cell.accessoryType = .detailButton
        cell.selectionStyle = .none
        
        if cell.detailLabel.text == String.empty {
            cell.detailLabel.text = ContactsList.data[ContactsList.keyList[indexPath.row]]
        } else {
            cell.detailLabel.text = String.empty
        }
        return cell
    }
}

extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {
        tableView.reloadRows(at: [indexPath], with: .none)
    }
}

// MARK: - Custom Cell
class CustomCell: UITableViewCell {
    static var identifier: String {
        return "\(self)"
    }
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.preferredFont(forTextStyle: .body)
        label.adjustsFontForContentSizeCategory = true
        return label
    }()
    
    let detailLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.preferredFont(forTextStyle: .body)
        label.adjustsFontForContentSizeCategory = true
        label.textColor = .gray
        label.textAlignment = .right
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.addSubview(titleLabel)
        contentView.addSubview(detailLabel)
        
        titleLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
        titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10).isActive = true
        titleLabel.trailingAnchor.constraint(equalTo: detailLabel.leadingAnchor).isActive = true
        titleLabel.setContentHuggingPriority(.defaultLow, for: .horizontal)
        titleLabel.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        
        detailLabel.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        detailLabel.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
        detailLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
        detailLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10).isActive = true
    }
    
    
    override func prepareForReuse() {
        titleLabel.text = ""
        detailLabel.text = ""
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Data
struct ContactsList {
    static let data: [String : String] = ["거문도닥나무 (Geo-mun-do-dak-na-mu)" :  "Geomundo false ohelo",
                                          "거문천남성 (Geo-mun-cheon-nam-seong)" :  "Geomun jack-in-the-pulpit",
                                          "한라산참꽃나무 (Han-ra-san-cham-kkot-na-mu)" : "Hallasan azalea",
                                          "한라고들빼기 (Han-ra-go-deul-ppae-gi)" : "Halla lettuce",
                                          "섬시호 (Seom-si-ho)" : "Ulleungdo hare's ear",
                                          "섬매발톱나무 (Seom-mae-bal-top-na-mu)" : "Jejudo barberry"
    ]
    
    static let keyList = data.map { $0.0 }.sorted()
}

// MARK: - Extension
extension String {
    static let empty = ""
}

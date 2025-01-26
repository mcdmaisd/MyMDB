//
//  ProfileViewController.swift
//  MyMDB
//
//  Created by ilim on 2025-01-25.
//

import UIKit

class ProfileViewController: BaseViewController {
    
    private let tableView = UITableView()
    
    override func configureHierarchy() {
        addSubView(tableView)
    }
    
    override func configureLayout() {
        tableView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
    }
    
    override func configureView() {
        tableView.backgroundColor = .clear
        tableView.tableHeaderView = UIView()
        tableView.separatorInset = UIEdgeInsets.zero
        tableView.separatorColor = .customDarkGray.withAlphaComponent(C.unselectedAlpha)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavigationBar(self, C.settingTitle)
        initTableView()
    }
    
    private func initTableView() {
        tableView.isScrollEnabled = false
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(SettingTableViewCell.self, forCellReuseIdentifier: SettingTableViewCell.id)
    }
}

extension ProfileViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        C.settingTitles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let row = indexPath.row
        let cell = tableView.dequeueReusableCell(withIdentifier: SettingTableViewCell.id, for: indexPath) as! SettingTableViewCell
        
        cell.configureLabel(C.settingTitles[row])
        cell.selectionStyle = .none
        cell.tag = row
        
        if cell.tag != C.settingTitles.count - 1 {
            cell.isUserInteractionEnabled = false
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        presentAlert(C.alertTitle, C.alertMessage)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        C.tableViewCellHeight
    }
}

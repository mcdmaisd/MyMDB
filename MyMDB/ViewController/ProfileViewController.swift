//
//  ProfileViewController.swift
//  MyMDB
//
//  Created by ilim on 2025-01-25.
//

import UIKit

final class ProfileViewController: BaseViewController {
    
    private let infoView = UserInfoView()
    private let tableView = UITableView()
    
    override func configureHierarchy() {
        addSubView(infoView)
        addSubView(tableView)
    }
    
    override func configureLayout() {
        infoView.setInfoConstraint(self)
        
        tableView.snp.makeConstraints { make in
            make.top.equalTo(infoView.snp.bottom).offset(10)
            make.horizontalEdges.equalTo(infoView)
            make.bottom.equalToSuperview()
        }
    }
    
    override func configureView() {
        infoView.delegate = self
        
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
        presentAlert(C.alertTitle, C.alertMessage, true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        C.tableViewCellHeight
    }
}

//
//  BaseViewController.swift
//  MyMDB
//
//  Created by ilim on 2025-01-24.
//
import Network
import UIKit
import Alamofire
import SnapKit

class BaseViewController: UIViewController {
    var loaded = false
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    override func loadView() {
        super.loadView()
//        NetworkMonitor.shared.startCheckingNetwork()
//        NetworkMonitor.shared.status = { data in
//            DispatchQueue.main.async {
//                if data == .unsatisfied {
//                    self.view.presentToast("인터넷 연결이 불안정 합니다.")
//                } else {
//                    self.view.presentToast("인터넷이 다시 연결 되었습니다.")
//                }
//            }
//        }
    }
        
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .customBlack
        configureHierarchy()
        configureLayout()
        configureView()
    }
    
    func configureHierarchy() {}
    func configureLayout() {}
    func configureView() {}
    func addSubView(_ view: UIView) {
        self.view.addSubview(view)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

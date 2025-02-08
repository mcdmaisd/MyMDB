//
//  OverViewLabel.swift
//  MyMDB
//
//  Created by ilim on 2025-01-28.
//
import UIKit

final class OverViewLabel: UILabel {
    func configureData(_ title: String = "", _ line: Int = 1, _ target: String = "") {
        let text = title.isEmpty ? C.emptyOverView : title
        configureLabel(text, line, target, C.sizeMd)
    }
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

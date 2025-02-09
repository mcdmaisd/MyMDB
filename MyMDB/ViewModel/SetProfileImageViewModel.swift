//
//  SetProfileImageViewModel.swift
//  MyMDB
//
//  Created by ilim on 2025-02-08.
//

import Foundation

class SetProfileImageViewModel {
    let image: Observable<String?> = .init(nil)
    let imageCell: Observable<Int?> = .init(nil)
    let collectionViewReload: Observable<Void> = .init(())
    let isEdit = U.shared.get(C.firstKey, false)

    var contents: ((String) -> Void)?
    var selectedIndex = 0

    init() {
        image.bind { [weak self] name in
            self?.selectedIndex = Int(name?.filter { $0.isNumber } ?? "") ?? 0
        }
        
        imageCell.bind { [weak self] index in
            guard let index else { return }
            self?.changeImage(index)
        }
    }
    
    private func changeImage(_ index: Int) {
        if selectedIndex == index { return }
        selectedIndex = index
        image.value = makeImageName()
        contents?(makeImageName())
        collectionViewReload.value = ()
    }
    
    private func makeImageName() -> String {
        "\(C.profileImagePrefix)\(selectedIndex)"
    }
}

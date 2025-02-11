//
//  SetProfileImageViewModel.swift
//  MyMDB
//
//  Created by ilim on 2025-02-08.
//

import Foundation

class SetProfileImageViewModel: BaseViewModel {
    var input: Input
    var output: Output
    var profileImage: ((String) -> Void)?
    
    struct Input {
        let imageName = Observable("")
        let imageIndex = Observable(0)
    }
    
    struct Output {
        let selectedImage = Observable("")
        let collectionViewReload: Observable<Void> = .init(())
        let isEdit = Observable(U.shared.get(C.firstKey, false))
        let selectedIndex = Observable(0)
    }

    init() {
        input = Input()
        output = Output()
        
        transform()
    }
    
    func transform() {
        input.imageName.lazyBind { [weak self] name in
            self?.input.imageIndex.value = Int(name.filter { $0.isNumber }) ?? 0
        }
        
        input.imageIndex.lazyBind { [weak self] index in
            self?.changeImage(index)
        }
    }
    
    private func changeImage(_ index: Int) {
        output.selectedIndex.value = index
        output.selectedImage.value = makeImageName()
        output.collectionViewReload.value = ()
        
        profileImage?(makeImageName())
    }
    
    private func makeImageName() -> String {
        "\(C.profileImagePrefix)\(input.imageIndex.value)"
    }
}

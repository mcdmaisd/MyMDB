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
    
    struct Input {
        let imageName = Observable("")
        let imageIndex = Observable(0)
    }
    
    struct Output {
        let selectedImage = Observable("")
        let collectionViewReload: Observable<Void> = .init(())
    }
    
    let isEdit = U.shared.get(C.firstKey, false)

    var contents: ((String) -> Void)?
    
    private(set) var selectedIndex = 0

    init() {
        input = Input()
        output = Output()
        
        transform()
    }
    
    func transform() {
        input.imageName.bind { [weak self] name in
            self?.input.imageIndex.value = Int(name.filter { $0.isNumber }) ?? 0
        }
        
        input.imageIndex.lazyBind { [weak self] index in
            self?.changeImage(index)
        }
    }
    
    private func changeImage(_ index: Int) {
        if selectedIndex == index { return }
        selectedIndex = index
        output.selectedImage.value = makeImageName()
        contents?(makeImageName())
        output.collectionViewReload.value = ()
    }
    
    private func makeImageName() -> String {
        "\(C.profileImagePrefix)\(selectedIndex)"
    }
}

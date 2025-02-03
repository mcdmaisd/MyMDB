//
//  CellType.swift
//  MyMDB
//
//  Created by ilim on 2025-02-02.
//

import UIKit

enum CellType: Int {
    case cast
    case poster
    
    var id: String {
        switch self {
        case .cast:
            return CastCollectionViewCell.id
        case .poster:
            return PosterCollectionViewCell.id
        }
    }
}

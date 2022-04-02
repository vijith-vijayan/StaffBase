//
//  CollectionViewCell.swift
//  LuluHyperMarket
//
//  Created by Vijith TV on 05/02/22.
//

import UIKit

extension UICollectionViewCell {
    
    //MARK: - UINIB FROM IDENTIFIER
    static var nib: UINib {
        return UINib(nibName: name, bundle: nil)
    }
    
    //MARK: - COLLECTIONVIEW CELL IDENTIFIER
    static var name: String {
        return String(describing: self)
    }
}

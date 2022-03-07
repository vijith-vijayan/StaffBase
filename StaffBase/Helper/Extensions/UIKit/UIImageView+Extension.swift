//
//  UIImageView+Extension.swift
//  StaffBase
//
//  Created by Vijith TV on 06/03/22.
//

import UIKit
import SDWebImage

extension UIImageView {
    
    //MARK: - SET IMAGE AND CACHE

    func setImage(from URL: URL, mode: ContentMode = .scaleAspectFit) {
        contentMode = mode
        self.sd_setImage(with: URL, placeholderImage: UIImage(named: "placeholder"), options: .continueInBackground) { image, error, cacheType, url in
            //TODO: -
        }
    }
    
    
}

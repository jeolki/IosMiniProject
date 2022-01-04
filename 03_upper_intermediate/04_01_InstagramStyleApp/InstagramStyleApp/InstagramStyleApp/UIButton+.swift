//
//  UIButton+.swift
//  InstagramStyleApp
//
//  Created by Jeonggi Hong on 2022/01/04.
//

import UIKit

// 이미지의 크기를 맞추기 위한 helper
extension UIButton {
    func setImage(systemName: String) {
        contentHorizontalAlignment = .fill
        contentVerticalAlignment = .fill
        
        imageView?.contentMode = .scaleAspectFit
        imageEdgeInsets = .zero
        
        setImage(UIImage(systemName: systemName), for: .normal)
    }
}

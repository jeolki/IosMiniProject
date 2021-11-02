//
//  DiaryCell.swift
//  Diary
//
//  Created by Jeonggi Hong on 2021/10/31.
//

import UIKit

class DiaryCell: UICollectionViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    // 생성자
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        // cell에 테두리
        self.contentView.layer.cornerRadius = 3.0
        self.contentView.layer.borderWidth = 1.0
        self.contentView.layer.borderColor = UIColor.black.cgColor
    }
    
    
}

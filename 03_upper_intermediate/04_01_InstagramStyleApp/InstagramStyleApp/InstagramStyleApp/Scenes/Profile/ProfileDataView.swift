//
//  ProfileDataView.swift
//  InstagramStyleApp
//
//  Created by Jeonggi Hong on 2022/01/05.
//

import SnapKit
import UIKit

final class ProfileDataView: UIView {
    
    private let title: String
    private let count: Int
    
    private lazy var titleLable: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14.0, weight: .medium)
        label.text = title
        
        return label
    }()
    
    private lazy var countLable: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16.0, weight: .bold)
        label.text = "\(count)"
        
        return label
    }()
    
    init(title: String, count: Int) {
        self.title = title
        self.count = count
        super.init(frame: .zero)
        
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private extension ProfileDataView {
    
    func setupLayout() {
        let stackView = UIStackView(arrangedSubviews: [countLable, titleLable])
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.spacing = 4.0
        
        addSubview(stackView)
        stackView.snp.makeConstraints { $0.edges.equalToSuperview() }
    }

}

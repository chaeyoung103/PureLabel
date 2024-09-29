//
//  NavigationBar.swift
//  PureLabel
//
//  Created by 송채영 on 9/27/24.
//

import UIKit
import Then
import SnapKit

class NavigationBar: UIView {
    
    // MARK: - UI Elements
    
    private let titleLabel = UILabel().then {
        $0.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        $0.textColor = .black
        $0.textAlignment = .center
    }
    
    private let leftButton = UIButton(type: .system).then {
        $0.setImage(UIImage(systemName: "chevron.left"), for: .normal)
        $0.tintColor = .black
    }
    
    // MARK: - Initialization
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        setupConstraints()
        self.leftButton.addTarget(self, action: #selector(leftButtonTapped), for: .touchUpInside)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup
    
    private func setupViews() {
        backgroundColor = .bgColor
        addSubview(titleLabel)
        addSubview(leftButton)
    }
    
    private func setupConstraints() {
        self.snp.makeConstraints { make in
            make.height.equalTo(42)  // 여기서 높이를 42로 고정합니다.
        }
        
        titleLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        
        leftButton.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(8)
            make.centerY.equalToSuperview()
            make.size.equalTo(24)
        }
    }
    
    // MARK: - Public Methods
    
    func setTitle(_ title: String) {
        titleLabel.text = title
    }
    
    func setLeftButtonAction(_ action: @escaping () -> Void) {
        leftButtonAction = action
    }
    
    func setLeftButton(_ isUsed: Bool) {
        if !isUsed {
            leftButton.isHidden = true
        }else {
            leftButton.isHidden = false
        }
    }
    
    // MARK: - Private Methods
    
    private var leftButtonAction: (() -> Void)?
    
    @objc private func leftButtonTapped() {
        leftButtonAction?()
    }
}

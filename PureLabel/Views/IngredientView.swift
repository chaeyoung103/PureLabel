//
//  IngredientView.swift
//  PureLabel
//
//  Created by 송채영 on 9/30/24.
//

import UIKit
import Then
import SnapKit

class IngredientView: UIView {
    
    // MARK: - UI Elements
    
    private let gradeLabel = UILabel().then {
        $0.font = UIFont.systemFont(ofSize: 12, weight: .bold)
        $0.textColor = .white
        $0.backgroundColor = .green
        $0.textAlignment = .center
        $0.layer.cornerRadius = 8
        $0.layer.masksToBounds = true
    }
    
    private let titleLabel = UILabel().then {
        $0.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        $0.textColor = .lightDarkBrown
        $0.textAlignment = .center
    }
    
    private let rightButton = UIButton(type: .system).then {
        $0.setImage(UIImage(systemName: "chevron.right"), for: .normal)
        $0.tintColor = .black
    }
    
    // MARK: - Initialization
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        setupConstraints()
        self.rightButton.addTarget(self, action: #selector(leftButtonTapped), for: .touchUpInside)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup
    
    private func setupViews() {
        backgroundColor = .bgColor
        addSubview(gradeLabel)
        addSubview(titleLabel)
        addSubview(rightButton)
    }
    
    private func setupConstraints() {
        self.snp.makeConstraints { make in
            make.height.equalTo(34)  // 여기서 높이를 42로 고정합니다.
        }
        
        gradeLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().offset(20)
            make.size.equalTo(20)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.centerY.equalTo(gradeLabel)
            make.leading.equalTo(gradeLabel.snp.trailing).offset(10)
        }
        
        rightButton.snp.makeConstraints { make in
            make.centerY.equalTo(gradeLabel)
            make.trailing.equalToSuperview().offset(-20)
            make.size.equalTo(18)
        }
    }
    
    // MARK: - Public Methods
    
    func setTitle(_ title: String) {
        titleLabel.text = title
    }
    
//    func setLeftButtonAction(_ action: @escaping () -> Void) {
//        leftButtonAction = action
//    }
    
    func setGrade(_ gradeIngredient: GradeIngredient) {
        if gradeIngredient.grade >= 0 && gradeIngredient.grade < 3 {
            gradeLabel.backgroundColor = .green
        }else if gradeIngredient.grade >= 3 && gradeIngredient.grade < 7 {
            gradeLabel.backgroundColor = .orange
        }else if (gradeIngredient.grade >= 7 && gradeIngredient.grade < 11) {
            gradeLabel.backgroundColor = .red
        }
        gradeLabel.text = String(gradeIngredient.grade)
    }
    
    // MARK: - Private Methods
    
    private var leftButtonAction: (() -> Void)?
    
    @objc private func leftButtonTapped() {
        leftButtonAction?()
    }
}

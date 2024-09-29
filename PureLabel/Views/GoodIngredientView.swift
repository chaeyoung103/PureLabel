//
//  GoodIngredientView.swift
//  PureLabel
//
//  Created by 송채영 on 9/29/24.
//

import UIKit
import Then
import SnapKit
import Kingfisher

class GoodIngredientView: UIView {
    
    // MARK: - UI Elements
    
    private let image = UIImageView().then {
        $0.image = UIImage(named: "default")
        $0.contentMode = .scaleAspectFit
        $0.layer.cornerRadius = 5
    }
    
    private let numLabel = UILabel().then {
        $0.font = UIFont.systemFont(ofSize: 14, weight: .bold)
        $0.textColor = .black
        $0.textAlignment = .center
        $0.text = "1"
    }
    
    private let titleLabel = UILabel().then {
        $0.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        $0.textColor = .black
        $0.textAlignment = .center
        $0.text = "그라운드 시소"
    }
    
    private let levelTag = UIImageView().then {
        $0.image = UIImage(named: "goodTag")
        $0.contentMode = .scaleAspectFit
    }
    
    private let tagLabel = UILabel().then {
        $0.font = UIFont.systemFont(ofSize: 10, weight: .ultraLight)
        $0.textColor = .black
        $0.textAlignment = .center
        $0.text = "#아토피 #건성 #민감성"
    }
    
    // MARK: - Initialization
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup
    
    private func setupViews() {
        backgroundColor = .bgColor
        addSubview(image)
        addSubview(numLabel)
        addSubview(titleLabel)
        addSubview(levelTag)
        addSubview(tagLabel)
    }
    
    private func setupConstraints() {
        self.snp.makeConstraints { make in
            make.height.equalTo(50)  // 여기서 높이를 42로 고정합니다.
        }
        
        image.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview()
            make.size.equalTo(50)
        }
        
        numLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalTo(image.snp.trailing).offset(10)
            make.width.equalTo(10)
            make.height.equalTo(21)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(image.snp.top).offset(7)
            make.leading.equalTo(numLabel.snp.trailing).offset(21)
            make.height.equalTo(18)
        }
        
        levelTag.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom)
            make.leading.equalTo(numLabel.snp.trailing).offset(21)
            make.height.equalTo(17)
            make.width.equalTo(28)
        }
        
        tagLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(3)
            make.leading.equalTo(levelTag.snp.trailing).offset(10)
        }
    }
    
    // MARK: - Public Methods
    
    func setTitle(_ title: String) {
        titleLabel.text = title
    }
    
    func setNum(_ num: String) {
        numLabel.text = num
    }
    
    func setImage(_ imageUrl: String) {
        let url = URL(string: imageUrl)
        self.image.kf.setImage(with: url)
    }
    
    func setHashTag(_ hashTag: [String],_ skinType: String) {
        var str = ""
        for i in hashTag {
            str += "#\(i) "
        }
        str += "#\(skinType)"
        
        self.tagLabel.text = str
    }
    
    func setTag(_ level: String) {
        print(level)
        if level == "좋음" {
            self.levelTag.image = UIImage(named: "goodTag")
        }else if level == "보통"{
            self.levelTag.image = UIImage(named: "normalTag")
        }else if level == "나쁨"{
                self.levelTag.image = UIImage(named: "badTag")
            }
    }
}

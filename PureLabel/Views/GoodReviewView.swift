//
//  GoodReviewView.swift
//  PureLabel
//
//  Created by 송채영 on 9/29/24.
//

import UIKit
import Then
import SnapKit

class GoodReviewView: UIView {
    
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
    
    private let star = UIImageView().then {
        $0.image = UIImage(named: "star5")
        $0.contentMode = .scaleAspectFit
    }
    
    private let scoreLabel = UILabel().then {
        $0.font = UIFont.systemFont(ofSize: 9, weight: .thin)
        $0.textColor = .black
        $0.textAlignment = .center
        $0.text = "4.8"
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
        addSubview(star)
        addSubview(scoreLabel)
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
        
        star.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(3)
            make.leading.equalTo(numLabel.snp.trailing).offset(21)
            make.height.equalTo(11)
            make.width.equalTo(76)
        }
        
        scoreLabel.snp.makeConstraints { make in
            make.centerY.equalTo(star).offset(1)
            make.leading.equalTo(star.snp.trailing).offset(4)
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
    
    func setStarLabel(_ score: String) {
        self.scoreLabel.text = score
    }
    
    func setStar(_ star: Float) {
        if star < 0.5 {
            self.star.image = UIImage(named: "star0")
        }else if (star >= 0.5 && star < 1.5){
            self.star.image = UIImage(named: "star1")
        }else if (star >= 1.5 && star < 2.5){
            self.star.image = UIImage(named: "star2")
        }else if (star >= 2.5 && star < 3.5){
            self.star.image = UIImage(named: "star3")
        }else if (star >= 3.5 && star < 4.5){
            self.star.image = UIImage(named: "star4")
        }else{
            self.star.image = UIImage(named: "star5")
        }
    }
}

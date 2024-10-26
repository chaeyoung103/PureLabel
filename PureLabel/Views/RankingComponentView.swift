//
//  RankingComponentView.swift
//  PureLabel
//
//  Created by 송채영 on 9/30/24.
//


import UIKit
import Then
import SnapKit
import Kingfisher

class RankingComponentView: UIView {
    
    // MARK: - UI Elements
    
    private let image = UIImageView().then {
        $0.image = UIImage(named: "default")
        $0.contentMode = .scaleAspectFit
        $0.layer.cornerRadius = 5
    }
    
    private let titleLabel = UILabel().then {
        $0.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
        $0.textColor = .black
        $0.textAlignment = .center
        $0.text = "그라운드 시소"
    }
    
    private let star = UIImageView().then {
        $0.image = UIImage(named: "star5")
        $0.contentMode = .scaleAspectFit
    }
    
    private let scoreLabel = UILabel().then {
        $0.font = UIFont.systemFont(ofSize: 11, weight: .thin)
        $0.textColor = .black
        $0.textAlignment = .center
        $0.text = "4.8"
    }
    
    private let levelTag = UIImageView().then {
        $0.image = UIImage(named: "goodTag")
        $0.contentMode = .scaleAspectFit
    }
    
    private let tagLabel = UILabel().then {
        $0.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        $0.textColor = .black
        $0.textAlignment = .center
        $0.text = "#아토피   #건성   #민감성"
    }
    
    // MARK: - Initialization
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.layer.cornerRadius = 10
        self.backgroundColor = .white
        self.isUserInteractionEnabled = true
        setupViews()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup
    
    private func setupViews() {
        backgroundColor = .white
        addSubview(image)
        addSubview(star)
        addSubview(scoreLabel)
        addSubview(titleLabel)
        addSubview(levelTag)
        addSubview(tagLabel)
    }
    
    private func setupConstraints() {
        self.snp.makeConstraints { make in
            make.height.equalTo(110)
        }
        
        image.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(16)
            make.leading.equalToSuperview().offset(20)
            make.size.equalTo(50)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(image.snp.top).offset(4)
            make.leading.equalTo(image.snp.trailing).offset(12)
            make.height.equalTo(21)
        }
        
        star.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(5)
            make.leading.equalTo(image.snp.trailing).offset(12)
            make.height.equalTo(11)
            make.width.equalTo(76)
        }
        
        scoreLabel.snp.makeConstraints { make in
            make.centerY.equalTo(star).offset(1)
            make.leading.equalTo(star.snp.trailing).offset(4)
        }
        
        levelTag.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-22)
            make.height.equalTo(21)
            make.width.equalTo(36)
        }
        
        tagLabel.snp.makeConstraints { make in
            make.top.equalTo(image.snp.bottom).offset(12)
            make.leading.equalToSuperview().offset(20)
        }
    }
    
    // MARK: - Public Methods
    
    func setTitle(_ title: String) {
        titleLabel.text = title
    }
    
    func setImage(_ imageUrl: String) {
        let url = URL(string: imageUrl)
        self.image.kf.setImage(with: url)
    }
    
    func setHashTag(_ hashTag: [String],_ skinType: String) {
        var str = ""
        for i in hashTag {
            str += "#\(i)   "
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

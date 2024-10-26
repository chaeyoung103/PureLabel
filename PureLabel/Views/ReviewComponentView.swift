//
//  ReviewComponentView.swift
//  PureLabel
//
//  Created by 송채영 on 10/26/24.
//



import UIKit
import Then
import SnapKit
import Kingfisher

class ReviewComponentView: UIView {
    
    // MARK: - UI Elements
    
    private let profileImage = UIImageView().then {
        $0.image = UIImage(named: "default_profile")
        $0.contentMode = .scaleAspectFit
        $0.layer.cornerRadius = 12
    }
    
    private let profileName = UILabel().then {
        $0.font = UIFont.systemFont(ofSize: 10, weight: .regular)
        $0.textColor = .black
        $0.textAlignment = .center
        $0.text = "익명1"
    }
    
    private let date = UILabel().then {
        $0.font = UIFont.systemFont(ofSize: 10, weight: .regular)
        $0.textColor = .textButtonColor
        $0.textAlignment = .center
        $0.text = "2023.08.16"
    }
    
    private let title = UILabel().then {
        $0.font = UIFont.systemFont(ofSize: 12, weight: .semibold)
        $0.textColor = .black
        $0.textAlignment = .center
        $0.text = "여드름에 효과가 좋아요!"
    }
    
    private let content = UILabel().then {
        $0.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        $0.textColor = .buttonBgColor
        $0.textAlignment = .left
        $0.text = "성분믿고 열심히 사용했는데 이거 쓰고 정말 여드름이 줄었어요!!! 성인여드름으로 고생하시는 분들한테 정말 강추합니다 특히 이 화장품에 ...성분이 저한텐 잘 맞았어요!다들 써보세요!"
        $0.numberOfLines = 0
    }
    
    // MARK: - Initialization
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.layer.cornerRadius = 10
        self.backgroundColor = .subBgColor
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
        addSubview(profileImage)
        addSubview(profileName)
        addSubview(date)
        addSubview(title)
        addSubview(content)
    }
    
    private func setupConstraints() {
        self.snp.makeConstraints { make in
            make.height.equalTo(150)
        }
        
        profileImage.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(13)
            make.leading.equalToSuperview().offset(15)
            make.size.equalTo(24)
        }
        
        profileName.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(10)
            make.leading.equalTo(profileImage.snp.trailing).offset(10)
            make.height.equalTo(15)
        }
        
        date.snp.makeConstraints { make in
            make.top.equalTo(profileName.snp.bottom)
            make.leading.equalTo(profileImage.snp.trailing).offset(10)
            make.height.equalTo(15)
        }
        
        title.snp.makeConstraints { make in
            make.top.equalTo(date.snp.bottom).offset(10)
            make.leading.equalToSuperview().offset(15)
        }
        
        content.snp.makeConstraints { make in
            make.top.equalTo(title.snp.bottom).offset(10)
            make.leading.equalToSuperview().offset(15)
            make.trailing.equalToSuperview().offset(-15)
        }
    }
    
    // MARK: - Public Methods
    
    func setTitle(_ title: String) {
        self.title.text = title
    }
    
    func setName(_ name: String) {
        self.profileName.text = name
    }
    
    func setImage(_ imageUrl: String) {
        let url = URL(string: imageUrl)
        self.profileImage.kf.setImage(with: url)
    }
    
    func setContent(_ content: String) {
        self.content.text = content
    }
}


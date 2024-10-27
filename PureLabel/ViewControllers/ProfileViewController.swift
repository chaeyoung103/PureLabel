//
//  ProfileViewController.swift
//  PureLabel
//
//  Created by 송채영 on 9/28/24.
//

import UIKit

class ProfileViewController: UIViewController {
    
    let navigationBar = NavigationBar()
    
    let profileView = UIView().then {
        $0.backgroundColor = .white
        $0.layer.cornerRadius = 10
    }
    
    let profileImage = UIImageView().then {
        $0.backgroundColor = .profileBgColor
        $0.layer.cornerRadius = 18
    }
    
    let name = UILabel().then{
        $0.font = UIFont.systemFont(ofSize: 18, weight: .regular)
        $0.textColor = UIColor.black
        $0.text = "송채영"
        $0.textAlignment = .center
    }
    
    let tagLabel = UILabel().then{
        $0.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        $0.textColor = UIColor.textButtonColor
        $0.text = "#여드름 #수부지 #지성"
        $0.textAlignment = .center
    }
    
    let profileModifyBtn = UIButton().then {
        $0.setImage(UIImage(named: "pencil"), for: .normal)
        $0.contentMode = .scaleAspectFit
    }
    
    let postLabel = UIButton().then{
        $0.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        $0.setTitle("게시물", for: .normal)
        $0.setTitleColor(.buttonBgColor, for: .normal)
    }
    
    let reviewLabel = UIButton().then{
        $0.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        $0.setTitle("리뷰", for: .normal)
        $0.setTitleColor(.buttonBgColor, for: .normal)
    }
    
    let emptyLabel = UIButton().then{
        $0.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        $0.setTitle("작성된 게시물이 없어요!", for: .normal)
        $0.setTitleColor(.buttonBgColor, for: .normal)
    }
    
    let selectdLine = UIView().then {
        $0.backgroundColor = .buttonBgColor
        $0.layer.cornerRadius = 2
    }
    
    let line = UIView().then {
        $0.backgroundColor = .textButtonColor
    }
    
    
    let isSeletedReview = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .bgColor
        
        hierarchy()
        layout()
        
        navigationBar.setTitle("프로필")
        navigationBar.setLeftButton(false)
        
        self.reviewLabel.addTarget(self, action: #selector(reviewBtnDidTab), for: .touchUpInside)
        self.postLabel.addTarget(self, action: #selector(postBtnDidTab), for: .touchUpInside)
    }
    
    @objc func reviewBtnDidTab() {
        emptyLabel.setTitle("작성된 리뷰가 없어요!", for: .normal)
        UIView.animate(withDuration: 0.3) {
            self.selectdLine.snp.remakeConstraints { make in
                make.centerX.equalTo(self.reviewLabel)
                make.bottom.equalTo(self.line.snp.bottom)
                make.width.equalTo(32)
                make.height.equalTo(4)
            }
            self.view.layoutIfNeeded()
        }
    }
    
    @objc func postBtnDidTab() {
        emptyLabel.setTitle("작성된 게시물이 없어요!", for: .normal)
        UIView.animate(withDuration: 0.3) {
        
            self.selectdLine.snp.remakeConstraints { make in
                make.centerX.equalTo(self.postLabel)
                make.bottom.equalTo(self.line.snp.bottom)
                make.width.equalTo(32)
                make.height.equalTo(4)
            }
            self.view.layoutIfNeeded()
        }
    }
    
    func hierarchy(){
        self.view.addSubview(navigationBar)
        self.view.addSubview(profileView)
        self.view.addSubview(profileImage)
        self.view.addSubview(name)
        self.view.addSubview(tagLabel)
        self.view.addSubview(profileModifyBtn)
        self.view.addSubview(line)
        self.view.addSubview(postLabel)
        self.view.addSubview(reviewLabel)
        self.view.addSubview(selectdLine)
        self.view.addSubview(emptyLabel)
    }
    
    func layout(){
        navigationBar.snp.makeConstraints{ make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.left.right.equalToSuperview()
            make.height.equalTo(42)
        }
        
        profileView.snp.makeConstraints{ make in
            make.top.equalTo(navigationBar.snp.bottom).offset(30)
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
            make.height.equalTo(80)
        }
        
        profileImage.snp.makeConstraints{ make in
            make.centerY.equalTo(profileView)
            make.leading.equalTo(profileView.snp.leading).offset(11)
            make.size.equalTo(36)
        }
        
        name.snp.makeConstraints{ make in
            make.top.equalTo(profileView.snp.top).offset(16)
            make.leading.equalTo(profileImage.snp.trailing).offset(20)
            make.height.equalTo(27)
        }
        
        tagLabel.snp.makeConstraints{ make in
            make.top.equalTo(name.snp.bottom)
            make.leading.equalTo(profileImage.snp.trailing).offset(20)
            make.height.equalTo(27)
        }
        
        profileModifyBtn.snp.makeConstraints{ make in
            make.centerY.equalTo(profileView)
            make.trailing.equalTo(profileView.snp.trailing).offset(-10)
            make.size.equalTo(20)
        }
        line.snp.makeConstraints{ make in
            make.centerY.equalTo(profileView.snp.bottom).offset(76)
            make.leading.trailing.equalToSuperview()
            make.size.equalTo(0.5)
        }
        
        postLabel.snp.makeConstraints{ make in
            make.bottom.equalTo(line.snp.bottom)
            make.leading.equalToSuperview().offset(28)
            make.width.equalTo(154)
            make.height.equalTo(44)
        }
        
        reviewLabel.snp.makeConstraints{ make in
            make.bottom.equalTo(line.snp.bottom)
            make.trailing.equalToSuperview().offset(-28)
            make.width.equalTo(154)
            make.height.equalTo(44)
        }
        
        selectdLine.snp.makeConstraints{ make in
            make.centerX.equalTo(postLabel)
            make.bottom.equalTo(line.snp.bottom)
            make.width.equalTo(32)
            make.height.equalTo(4)
        }
        
        emptyLabel.snp.makeConstraints{ make in
            make.top.equalTo(line.snp.bottom).offset(50)
            make.leading.trailing.equalToSuperview()
            make.width.equalTo(200)
            make.height.equalTo(21)
        }
        
        
    }
}

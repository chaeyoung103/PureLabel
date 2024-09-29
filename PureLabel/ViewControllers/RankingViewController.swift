//
//  RankingViewController.swift
//  PureLabel
//
//  Created by 송채영 on 9/30/24.
//

import UIKit

class RankingViewController: UIViewController, UIScrollViewDelegate {
    
    let navigationBar = NavigationBar()
    
    let searchIcon = UIImageView().then {
        $0.image = UIImage(named: "search")
        $0.contentMode = .scaleAspectFit
    }
    
    let searchBar = UITextField().then{
        let placeholderText = "검색하기"
        let attributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor.textButtonColor,
            .font: UIFont.systemFont(ofSize: 15,weight: .regular) // 원하는 폰트와 사이즈로 설정
        ]
        $0.attributedPlaceholder = NSAttributedString(string: placeholderText, attributes: attributes)
        $0.layer.borderColor = UIColor.lightGray.cgColor
        $0.layer.borderWidth = 1
        $0.layer.cornerRadius = 10
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 46, height: $0.frame.size.height))
        $0.leftView = paddingView
        $0.leftViewMode = .always
        $0.returnKeyType = .done
        $0.backgroundColor = .bgColor
        $0.font = UIFont.systemFont(ofSize: 15, weight: .regular)
        $0.enablesReturnKeyAutomatically = true
    }
    
    let reviewAlignBtn = UIButton().then{
        $0.setTitle("리뷰 좋은 순", for: .normal)
        $0.setTitleColor(.textButtonColor, for: .normal)
        $0.setTitleColor(.buttonBgColor, for: .selected)
        $0.backgroundColor = .clear
        $0.titleLabel?.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        $0.isSelected = true
    }
    
    let gradeAlignBtn = UIButton().then{
        $0.setTitle("성분 좋은 순", for: .normal)
        $0.setTitleColor(.textButtonColor, for: .normal)
        $0.setTitleColor(.buttonBgColor, for: .selected)
        $0.backgroundColor = .clear
        $0.titleLabel?.font = UIFont.systemFont(ofSize: 13, weight: .regular)
    }
    
    let scrollView = UIScrollView().then {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.showsVerticalScrollIndicator = true
        $0.backgroundColor = .bgColor
    }
    
    let contentView = UIView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .bgColor
        
        scrollView.delegate = self
        searchBar.delegate = self
        
        hierarchy()
        layout()
        
        navigationBar.setTitle("랭킹")
        navigationBar.setLeftButtonAction { [weak self] in
            self?.navigationController?.popViewController(animated: true)
        }
        
        self.reviewAlignBtn.addTarget(self, action: #selector(reviewAlignBtnDidTab), for: .touchUpInside)
        self.gradeAlignBtn.addTarget(self, action: #selector(gradeAlignBtnDidTab), for: .touchUpInside)
        
        apiSetting(sort:"rating")
    }
    
    @objc func reviewAlignBtnDidTab() {
        apiSetting(sort:"rating")
        reviewAlignBtn.isSelected = true
        gradeAlignBtn.isSelected = false
    }
    
    @objc func gradeAlignBtnDidTab() {
        apiSetting(sort:"grade")
        reviewAlignBtn.isSelected = false
        gradeAlignBtn.isSelected = true
    }
    
    func apiSetting(sort:String) {
        self.contentView.subviews.forEach { $0.removeFromSuperview() }
        var previousView: RankingComponentView?
        ApiClient().getRanking(count: 50,sort: sort){ result in
            for i in 0..<result.count {
                let view = RankingComponentView()
                self.contentView.addSubview(view)
                
                // SnapKit을 이용한 오토레이아웃 설정
                view.snp.makeConstraints { make in
                    make.leading.trailing.equalToSuperview()  // 좌우를 contentView에 맞춤
                    make.width.equalTo(self.view).offset(-40)  // 각 뷰의 너비를 부모 뷰에 맞춤
                    
                    if let previous = previousView {
                        make.top.equalTo(previous.snp.bottom).offset(10)  // 이전 뷰 아래에 배치
                    } else {
                        make.top.equalToSuperview()  // 첫 뷰는 contentView의 상단에 배치
                    }
                }
                
                view.setHashTag(result[i].skinWorries!, result[i].skinType!)
                view.setImage(result[i].imageUrl!)
                view.setStar(result[i].rating!)
                view.setStarLabel(String(result[i].rating!))
                view.setTag(result[i].grade!)
                view.setTitle(result[i].name!)
                
                previousView = view
                
                
            }
            
            // 마지막 뷰의 bottom을 contentView의 bottom에 맞춤으로써 스크롤 가능하게 함
            previousView?.snp.makeConstraints { make in
                make.bottom.equalToSuperview().offset(-10)
            }
            
        }
    }
    
    func hierarchy(){
        self.view.addSubview(navigationBar)
        self.view.addSubview(searchBar)
        self.view.addSubview(searchIcon)
        self.view.addSubview(reviewAlignBtn)
        self.view.addSubview(gradeAlignBtn)
        
        self.view.addSubview(scrollView)
        scrollView.addSubview(contentView)
    }
    
    func layout(){
        navigationBar.snp.makeConstraints{ make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.left.right.equalToSuperview()
            make.height.equalTo(42)
        }
        searchBar.snp.makeConstraints{ make in
            make.top.equalTo(navigationBar.snp.bottom).offset(11)
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
            make.height.equalTo(40)
        }
        searchIcon.snp.makeConstraints{ make in
            make.centerY.equalTo(searchBar)
            make.leading.equalTo(searchBar.snp.leading).offset(20)
            make.width.equalTo(17.18)
            make.height.equalTo(16.23)
        }
        
        reviewAlignBtn.snp.makeConstraints{ make in
            make.top.equalTo(searchBar.snp.bottom).offset(23)
            make.leading.equalToSuperview().offset(26)
            make.width.equalTo(65)
            make.height.equalTo(16)
        }
        
        gradeAlignBtn.snp.makeConstraints{ make in
            make.top.equalTo(searchBar.snp.bottom).offset(23)
            make.leading.equalTo(reviewAlignBtn.snp.trailing).offset(11)
            make.width.equalTo(65)
            make.height.equalTo(16)
        }
        
        scrollView.snp.makeConstraints{ make in
            make.top.equalTo(gradeAlignBtn.snp.bottom).offset(13)
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
            make.bottom.equalToSuperview().offset(-26)
            make.width.equalToSuperview()
        }
        contentView.snp.makeConstraints{ make in
            make.top.leading.trailing.equalToSuperview()
            make.bottom.equalToSuperview()
            make.width.equalToSuperview()
        }
        
        
    }
}

//MARK: - Keyboard

extension RankingViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == searchBar{
            searchBar.resignFirstResponder()
            self.contentView.subviews.forEach { $0.removeFromSuperview() }
            var previousView: RankingComponentView?
            ApiClient().getSearch(search: searchBar.text ?? ""){ result in
                for i in 0..<result.count {
                    let view = RankingComponentView()
                    self.contentView.addSubview(view)
                    
                    // SnapKit을 이용한 오토레이아웃 설정
                    view.snp.makeConstraints { make in
                        make.leading.trailing.equalToSuperview()  // 좌우를 contentView에 맞춤
                        make.width.equalTo(self.view).offset(-40)  // 각 뷰의 너비를 부모 뷰에 맞춤
                        make.height.equalTo(110)
                        
                        if let previous = previousView {
                            make.top.equalTo(previous.snp.bottom).offset(10)  // 이전 뷰 아래에 배치
                        } else {
                            make.top.equalToSuperview()  // 첫 뷰는 contentView의 상단에 배치
                        }
                    }
                    
                    view.setHashTag(result[i].skinWorries!, result[i].skinType!)
                    view.setImage(result[i].imageUrl!)
                    view.setStar(result[i].rating!)
                    view.setStarLabel(String(result[i].rating!))
                    view.setTag(result[i].grade!)
                    view.setTitle(result[i].name!)
                    previousView = view
                }
                
                // 마지막 뷰의 bottom을 contentView의 bottom에 맞춤으로써 스크롤 가능하게 함
                previousView?.snp.makeConstraints { make in
                    make.bottom.equalToSuperview().offset(-10)
                }
                
            }
            
        }
        return true
    }
}

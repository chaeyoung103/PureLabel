//
//  DetailViewController.swift
//  PureLabel
//
//  Created by 송채영 on 10/23/24.
//


import UIKit

class DetailViewController: UIViewController, UIScrollViewDelegate {
    
    let navigationBar = NavigationBar()
    
    let productImage = UIImageView().then {
        $0.image = UIImage(named: "default2")
        $0.contentMode = .scaleAspectFit
        $0.backgroundColor = .imgBgColor
    }

    
    let scrollView = UIScrollView().then {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.showsVerticalScrollIndicator = true
        $0.backgroundColor = .bgColor
    }
    
    let contentView = UIView()
    
    let brandLabel = UILabel().then{
        $0.font = UIFont.systemFont(ofSize: 9, weight: .thin)
        $0.textColor = UIColor.buttonBgColor
        $0.text = "Ampoule"
        $0.textAlignment = .center
    }
    
    let nameLabel = UILabel().then{
        $0.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        $0.textColor = UIColor.black
        $0.text = "그라운드시소"
        $0.textAlignment = .center
    }
    
    let priceTitle = UILabel().then{
        $0.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        $0.textColor = UIColor.black
        $0.text = "가격"
        $0.textAlignment = .center
    }
    let typeTitle = UILabel().then{
        $0.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        $0.textColor = UIColor.black
        $0.text = "종류"
        $0.textAlignment = .center
    }
    
    let ingredientTitle = UILabel().then{
        $0.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        $0.textColor = UIColor.black
        $0.text = "성분"
        $0.textAlignment = .center
    }
    let reviewTitle = UILabel().then{
        $0.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        $0.textColor = UIColor.black
        $0.text = "리뷰"
        $0.textAlignment = .center
    }
    
    let price = UILabel().then{
        $0.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        $0.textColor = UIColor.lightDarkBrown
        $0.text = "38,000원"
        $0.textAlignment = .center
    }
    let type = UILabel().then{
        $0.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        $0.textColor = UIColor.lightDarkBrown
        $0.text = "앰플,모공"
        $0.textAlignment = .center
    }
    
    let ingredient = UILabel().then {
        $0.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        $0.textColor = UIColor.lightDarkBrown
        $0.textAlignment = .center
        $0.numberOfLines = 0  // 여러 줄 지원

        // 줄 간격 설정
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 7  // 원하는 줄 간격 값으로 설정

        let attributedString = NSAttributedString(
            string: "정제수, 증류수, 물\n글리세린\n다이프로필렌글라이콜,\n디프로필렌글라이콜,\n나이아신아마이드, \n니코틴산아마이드,\n자일리톨,\n헥산다이올, 헥산디올,\n하이드록아세토페논",
            attributes: [
                .font: UIFont.systemFont(ofSize: 12, weight: .regular),
                .foregroundColor: UIColor.lightDarkBrown,
                .paragraphStyle: paragraphStyle
            ]
        )
        
        $0.attributedText = attributedString
    }
    
    private let star = UIImageView().then {
        $0.image = UIImage(named: "star")
        $0.contentMode = .scaleAspectFit
    }
    
    let review = UILabel().then{
        $0.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        $0.textColor = UIColor.lightDarkBrown
        $0.text = "4.8"
        $0.textAlignment = .center
    }
    
    let reviewBtn = UIButton().then {
        $0.setTitle("리뷰 작성하기", for: .normal)
        $0.setTitleColor(.buttonBgColor, for: .normal)
        $0.backgroundColor = .clear
        $0.titleLabel?.font = UIFont.systemFont(ofSize: 12, weight: .regular)
    }
    
    let levelTag = UIImageView().then {
        $0.image = UIImage(named: "goodTag")
        $0.contentMode = .scaleAspectFit
    }
    
    let reviewComponent = ReviewComponentView()
    
    let cosmeticId : Int
    
    
    
    init(id: Int) {
        self.cosmeticId = id
        super.init(nibName: nil, bundle: nil)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .bgColor
        
        scrollView.delegate = self
        
        print(cosmeticId,"아이디아이디")
        
        hierarchy()
        layout()
        
        navigationBar.setTitle("")
        navigationBar.setLeftButtonAction { [weak self] in
            self?.navigationController?.popViewController(animated: true)
        }
        
        apiSetting()
        
       
    }
    
    func apiSetting() {
    
        ApiClient().getCosmeticDetail(id: cosmeticId) { result in
            let detailData: GetCosmeticDetailModel = result
            self.brandLabel.text = result.brand
            self.nameLabel.text = result.name
            self.ingredient.text = result.ingredients?.joined(separator: "\n")
            if result.grade == "좋음" {
                self.levelTag.image = UIImage(named: "goodTag")
            }else if result.grade == "보통"{
                self.levelTag.image = UIImage(named: "normalTag")
            }else if result.grade == "나쁨"{
                    self.levelTag.image = UIImage(named: "badTag")
                }
            if let price = result.price {
                let numberFormatter = NumberFormatter()
                numberFormatter.numberStyle = .decimal
                numberFormatter.locale = Locale(identifier: "ko_KR") // 한국 원화 형식 예시
                
                if let formattedPrice = numberFormatter.string(from: NSNumber(value: price)) {
                    self.price.text = formattedPrice // UILabel에 형식화된 값 설정
                }
            }
            self.review.text = String(result.rating!)
            self.ingredient.snp.makeConstraints { make in
                make.height.equalTo(21*result.ingredients!.count)
            }
            
        }
    }
    
    
    func hierarchy(){
        self.view.addSubview(navigationBar)
        self.view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        self.contentView.addSubview(productImage)
        self.contentView.addSubview(brandLabel)
        self.contentView.addSubview(nameLabel)
        self.contentView.addSubview(priceTitle)
        self.contentView.addSubview(typeTitle)
        self.contentView.addSubview(reviewTitle)
        self.contentView.addSubview(ingredientTitle)
        self.contentView.addSubview(levelTag)
        self.contentView.addSubview(price)
        self.contentView.addSubview(type)
        self.contentView.addSubview(star)
        self.contentView.addSubview(review)
        self.contentView.addSubview(ingredient)
        
        self.contentView.addSubview(reviewBtn)
        self.contentView.addSubview(reviewComponent)
        
    }
    
    func layout(){
        navigationBar.snp.makeConstraints{ make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(42)
        }
        scrollView.snp.makeConstraints{ make in
            make.top.equalTo(navigationBar.snp.bottom)
            make.leading.trailing.bottom.equalToSuperview()
            make.width.equalToSuperview()
        }
        contentView.snp.makeConstraints{ make in
            make.edges.equalToSuperview()
            make.width.equalToSuperview()
        }
        
        productImage.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(375)
        }
        
        brandLabel.snp.makeConstraints { make in
            make.top.equalTo(productImage.snp.bottom).offset(29)
            make.leading.equalToSuperview().offset(20)
        }
        
        nameLabel.snp.makeConstraints { make in
            make.top.equalTo(brandLabel.snp.bottom).offset(5)
            make.leading.equalToSuperview().offset(20)
        }
        
        priceTitle.snp.makeConstraints { make in
            make.top.equalTo(nameLabel.snp.bottom).offset(10)
            make.leading.equalToSuperview().offset(20)
            make.height.equalTo(21)
        }
        
        price.snp.makeConstraints { make in
            make.top.equalTo(nameLabel.snp.bottom).offset(10)
            make.leading.equalTo(priceTitle.snp.trailing).offset(10)
            make.height.equalTo(21)
        }
        
        typeTitle.snp.makeConstraints { make in
            make.top.equalTo(priceTitle.snp.bottom).offset(5)
            make.leading.equalToSuperview().offset(20)
            make.height.equalTo(21)
        }
        
        type.snp.makeConstraints { make in
            make.top.equalTo(priceTitle.snp.bottom).offset(5)
            make.leading.equalTo(typeTitle.snp.trailing).offset(10)
            make.height.equalTo(21)
        }
        
        ingredientTitle.snp.makeConstraints { make in
            make.top.equalTo(typeTitle.snp.bottom).offset(5)
            make.leading.equalToSuperview().offset(20)
            make.height.equalTo(21)
        }
        
        levelTag.snp.makeConstraints { make in
            make.top.equalTo(ingredientTitle.snp.top)
            make.trailing.equalToSuperview().offset(-20)
            make.height.equalTo(21)
            make.width.equalTo(36)
        }
        
        ingredient.snp.makeConstraints { make in
            make.top.equalTo(typeTitle.snp.bottom).offset(5)
            make.leading.equalTo(ingredientTitle.snp.trailing).offset(10)
            make.height.equalTo(21*3)
        }
        
        reviewTitle.snp.makeConstraints { make in
            make.top.equalTo(ingredient.snp.bottom).offset(10)
            make.leading.equalToSuperview().offset(20)
            make.height.equalTo(21)
        }
        
        star.snp.makeConstraints { make in
            make.top.equalTo(ingredient.snp.bottom).offset(10)
            make.leading.equalTo(reviewTitle.snp.trailing).offset(10)
            make.height.equalTo(21)
        }
        
        review.snp.makeConstraints { make in
            make.top.equalTo(ingredient.snp.bottom).offset(10)
            make.leading.equalTo(star.snp.trailing).offset(5)
            make.height.equalTo(21)
        }
        
        reviewBtn.snp.makeConstraints { make in
            make.bottom.equalTo(reviewTitle.snp.bottom)
            make.trailing.equalToSuperview().offset(-25)
            make.height.equalTo(16)
        }
        
        reviewComponent.snp.makeConstraints { make in
            make.top.equalTo(reviewTitle.snp.bottom).offset(6)
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
            make.bottom.equalToSuperview().offset(-20)
        }
        
        
    }
}


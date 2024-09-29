//
//  HomeViewController.swift
//  PureLabel
//
//  Created by 송채영 on 9/28/24.
//

import UIKit
import Kingfisher

class HomeViewController: UIViewController {
    
    let goodReviewView1 = GoodReviewView()
    let goodReviewView2 = GoodReviewView()
    let goodReviewView3 = GoodReviewView()
    
    let goodIngredientView1 = GoodIngredientView()
    let goodIngredientView2 = GoodIngredientView()
    let goodIngredientView3 = GoodIngredientView()
    
    let logo = UIImageView().then {
        $0.image = UIImage(named: "logo_small")
        $0.contentMode = .scaleAspectFit
    }
    
    let analysisBtn = UIButton().then{
        $0.setTitle("화장품 성분 분석하러가기", for: .normal)
        $0.setTitleColor(.white, for: .normal)
        $0.backgroundColor = .buttonBgColor
        $0.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        $0.layer.cornerRadius = 5
    }
    
    private let goReviewBtn = UIButton().then {
        $0.setImage(UIImage(named: "chevron.right"), for: .normal)
        $0.contentMode = .scaleAspectFit
    }
    
    private let reviewTitle = UILabel().then {
        $0.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        $0.textColor = .black
        $0.textAlignment = .center
        $0.text = "리뷰가 좋은"
    }
    
    private let goIngredientBtn = UIButton().then {
        $0.setImage(UIImage(named: "chevron.right"), for: .normal)
        $0.contentMode = .scaleAspectFit
    }
    
    private let ingredientTitle = UILabel().then {
        $0.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        $0.textColor = .black
        $0.textAlignment = .center
        $0.text = "성분이 좋은"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .bgColor
        
        hierarchy()
        layout()
        
        self.analysisBtn.addTarget(self, action: #selector(analysisBtnDidTab), for: .touchUpInside)
        self.goReviewBtn.addTarget(self, action: #selector(goReviewBtnDidTab), for: .touchUpInside)
        self.goIngredientBtn.addTarget(self, action: #selector(goIngredientBtnDidTab), for: .touchUpInside)
        
        apiSetting()
    }
    
    func apiSetting() {
        ApiClient().getRanking(count: 3,sort: "rating"){ result in
            self.goodReviewView1.setImage(result[0].imageUrl!)
            self.goodReviewView1.setNum("1")
            self.goodReviewView1.setTitle(result[0].name!)
            self.goodReviewView1.setStar(result[0].rating!)
            self.goodReviewView1.setStarLabel(String(result[0].rating!))
            self.goodReviewView2.setImage(result[1].imageUrl!)
            self.goodReviewView2.setNum("2")
            self.goodReviewView2.setTitle(result[1].name!)
            self.goodReviewView2.setStar(result[1].rating!)
            self.goodReviewView2.setStarLabel(String(result[1].rating!))
            self.goodReviewView3.setImage(result[2].imageUrl!)
            self.goodReviewView3.setNum("3")
            self.goodReviewView3.setTitle(result[2].name!)
            self.goodReviewView3.setStar(result[2].rating!)
            self.goodReviewView3.setStarLabel(String(result[2].rating!))
        }
        
        ApiClient().getRanking(count: 3,sort: "grade"){ result in
            self.goodIngredientView1.setImage(result[0].imageUrl!)
            self.goodIngredientView1.setNum("1")
            self.goodIngredientView1.setTitle(result[0].name!)
            self.goodIngredientView1.setTag(result[0].grade!)
            self.goodIngredientView1.setHashTag(result[0].skinWorries!,result[0].skinType!)
            self.goodIngredientView2.setImage(result[1].imageUrl!)
            self.goodIngredientView2.setNum("2")
            self.goodIngredientView2.setTitle(result[1].name!)
            self.goodIngredientView2.setTag(result[1].grade!)
            self.goodIngredientView2.setHashTag(result[1].skinWorries!,result[1].skinType!)
            self.goodIngredientView3.setImage(result[2].imageUrl!)
            self.goodIngredientView3.setNum("3")
            self.goodIngredientView3.setTitle(result[2].name!)
            self.goodIngredientView3.setTag(result[2].grade!)
            self.goodIngredientView3.setHashTag(result[2].skinWorries!,result[2].skinType!)
        }
    }
    
    @objc func analysisBtnDidTab() {
        let cameraViewController = CameraViewController()
        self.navigationController?.pushViewController(cameraViewController, animated: true)
    }
    
    @objc func goReviewBtnDidTab() {
        let rankingViewController = RankingViewController()
        self.navigationController?.pushViewController(rankingViewController, animated: true)
    }
    
    @objc func goIngredientBtnDidTab() {
        let rankingViewController = RankingViewController()
        self.navigationController?.pushViewController(rankingViewController, animated: true)
    }
    
    //MARK: - Layout
    func hierarchy(){
        self.view.addSubview(logo)
        self.view.addSubview(analysisBtn)
        self.view.addSubview(goReviewBtn)
        self.view.addSubview(reviewTitle)
        self.view.addSubview(goodReviewView1)
        self.view.addSubview(goodReviewView2)
        self.view.addSubview(goodReviewView3)
        self.view.addSubview(goIngredientBtn)
        self.view.addSubview(ingredientTitle)
        self.view.addSubview(goodIngredientView1)
        self.view.addSubview(goodIngredientView2)
        self.view.addSubview(goodIngredientView3)
        
    }
    
    func layout(){
        logo.snp.makeConstraints{ make in
            make.top.equalToSuperview().offset(100)
            make.leading.trailing.equalToSuperview()
            make.width.equalTo(180)
            make.height.equalTo(60)
        }
        analysisBtn.snp.makeConstraints{ make in
            make.top.equalTo(logo.snp.bottom).offset(30)
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
            make.height.equalTo(56)
        }
        reviewTitle.snp.makeConstraints{ make in
            make.top.equalTo(analysisBtn.snp.bottom).offset(30)
            make.leading.equalToSuperview().offset(20)
            make.height.equalTo(24)
        }
        goReviewBtn.snp.makeConstraints{ make in
            make.centerY.equalTo(reviewTitle)
            make.trailing.equalToSuperview().offset(-20)
            make.size.equalTo(24)
        }
        goodReviewView1.snp.makeConstraints{ make in
            make.top.equalTo(goReviewBtn.snp.bottom).offset(20)
            make.leading.equalToSuperview().offset(20)
        }
        goodReviewView2.snp.makeConstraints{ make in
            make.top.equalTo(goodReviewView1.snp.bottom).offset(10)
            make.leading.equalToSuperview().offset(20)
            make.height.equalTo(50)
        }
        goodReviewView3.snp.makeConstraints{ make in
            make.top.equalTo(goodReviewView2.snp.bottom).offset(10)
            make.leading.equalToSuperview().offset(20)
            make.height.equalTo(50)
        }
        
        ingredientTitle.snp.makeConstraints{ make in
            make.top.equalTo(goodReviewView3.snp.bottom).offset(30)
            make.leading.equalToSuperview().offset(20)
            make.height.equalTo(24)
        }
        goIngredientBtn.snp.makeConstraints{ make in
            make.centerY.equalTo(ingredientTitle)
            make.trailing.equalToSuperview().offset(-20)
            make.size.equalTo(24)
        }
        goodIngredientView1.snp.makeConstraints{ make in
            make.top.equalTo(goIngredientBtn.snp.bottom).offset(20)
            make.leading.equalToSuperview().offset(20)
        }
        goodIngredientView2.snp.makeConstraints{ make in
            make.top.equalTo(goodIngredientView1.snp.bottom).offset(10)
            make.leading.equalToSuperview().offset(20)
            make.height.equalTo(50)
        }
        goodIngredientView3.snp.makeConstraints{ make in
            make.top.equalTo(goodIngredientView2.snp.bottom).offset(10)
            make.leading.equalToSuperview().offset(20)
            make.height.equalTo(50)
        }
    }
}

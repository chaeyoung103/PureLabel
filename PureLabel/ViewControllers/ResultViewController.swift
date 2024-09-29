//
//  ResultViewController.swift
//  PureLabel
//
//  Created by 송채영 on 9/30/24.
//

import UIKit

struct GradeIngredient{
    var grade : Int
    var ingredient : String
}

class ResultViewController: UIViewController, UIScrollViewDelegate {
    
    let resultList = [GradeIngredient(grade: 1, ingredient: "정제수"),GradeIngredient(grade: 1, ingredient: "글리세린"),GradeIngredient(grade: 1, ingredient: "카프릴릭/카프릭트리글리세라이드"),GradeIngredient(grade: 1, ingredient: "카프릴릴메치콘"),GradeIngredient(grade: 1, ingredient: "1,2-헥산디올"),GradeIngredient(grade: 1, ingredient: "나이아신아마이드"),GradeIngredient(grade: 1, ingredient: "펜틸렌글라이콜"),GradeIngredient(grade: 1, ingredient: "소듐하이알루로네이트"),GradeIngredient(grade: 1, ingredient: "세테아릴올리베이트"),GradeIngredient(grade: 1, ingredient: "정제수"),GradeIngredient(grade: 1, ingredient: "정제수"),GradeIngredient(grade: 1, ingredient: "정제수"),GradeIngredient(grade: 1, ingredient: "정제수"),GradeIngredient(grade: 1, ingredient: "정제수")]
    
    let navigationBar = NavigationBar()
    
    let resultImage = UIImageView().then {
        $0.image = UIImage(named: "default")
        $0.contentMode = .scaleAspectFit
        $0.backgroundColor = .imgBgColor
    }
    
    let ewgLabel = UILabel().then{
        $0.font = UIFont.systemFont(ofSize: 10, weight: .medium)
        $0.textColor = UIColor.buttonBgColor
        $0.text = "EWG 등급"
        $0.textAlignment = .center
        $0.isHidden = true
    }
    
    let good = UILabel().then{
        $0.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        $0.textColor = UIColor.lightDarkBrown
        $0.text = "좋음"
        $0.textAlignment = .center
    }
    
    let bad = UILabel().then{
        $0.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        $0.textColor = UIColor.lightDarkBrown
        $0.text = "나쁨"
        $0.textAlignment = .center
    }
    
    let gradeImage = UIImageView().then {
        $0.image = UIImage(named: "ewgGrade")
        $0.contentMode = .scaleAspectFit
        $0.backgroundColor = .clear
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
        
        hierarchy()
        layout()
        
        navigationBar.setTitle("")
        navigationBar.setLeftButton(true)
    }
    
    func hierarchy() {
        self.view.addSubview(navigationBar)
        self.view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        self.contentView.addSubview(resultImage)
        self.contentView.addSubview(ewgLabel)
        self.contentView.addSubview(good)
        self.contentView.addSubview(bad)
        self.contentView.addSubview(gradeImage)
    }

    func layout() {
        // 네비게이션 바 레이아웃 설정
        navigationBar.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.left.right.equalToSuperview()
            make.height.equalTo(42)
        }

        // 스크롤뷰 레이아웃 설정
        scrollView.snp.makeConstraints { make in
            make.top.equalTo(navigationBar.snp.bottom)
            make.trailing.leading.equalToSuperview()
            make.bottom.equalToSuperview()
            make.width.equalToSuperview()
        }

        // contentView 레이아웃 설정
        contentView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.bottom.equalToSuperview()
            make.width.equalToSuperview()
        }

        // resultImage 레이아웃 설정
        resultImage.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(375)
        }

        // ewgLabel 레이아웃 설정
        ewgLabel.snp.makeConstraints { make in
            make.top.equalTo(resultImage.snp.bottom).offset(13)
            make.leading.equalToSuperview().offset(20)
        }

        // gradeImage 레이아웃 설정
        gradeImage.snp.makeConstraints { make in
            make.top.equalTo(ewgLabel.snp.bottom).offset(12)
            make.centerX.equalToSuperview()
            make.height.equalTo(20)
        }

        // good 레이아웃 설정
        good.snp.makeConstraints { make in
            make.centerY.equalTo(gradeImage)
            make.leading.equalToSuperview().offset(20)
        }

        // bad 레이아웃 설정
        bad.snp.makeConstraints { make in
            make.centerY.equalTo(gradeImage)
            make.trailing.equalToSuperview().offset(-20)
        }

        var previousView: IngredientView?

        // IngredientView를 contentView에 추가
        for i in 0..<resultList.count {
            let view = IngredientView()
            self.contentView.addSubview(view)

            // SnapKit을 이용한 오토레이아웃 설정
            view.snp.makeConstraints { make in
                make.leading.trailing.equalToSuperview()  // 좌우를 contentView에 맞춤
                make.width.equalTo(self.view)  // 각 뷰의 너비를 부모 뷰에 맞춤
                make.height.equalTo(34)

                if let previous = previousView {
                    make.top.equalTo(previous.snp.bottom).offset(10)  // 이전 뷰 아래에 배치
                } else {
                    make.top.equalTo(gradeImage.snp.bottom).offset(25)  // 첫 뷰는 gradeImage 아래에 배치
                }
            }

            // IngredientView 내용 설정
            view.setGrade(resultList[i])
            view.setTitle(resultList[i].ingredient)

            // 이전 뷰 업데이트
            previousView = view
        }

        // 마지막 뷰의 bottom을 contentView의 bottom에 맞춤으로써 스크롤 가능하게 설정
        previousView?.snp.makeConstraints { make in
            make.bottom.equalToSuperview().offset(-10)
        }
    }


}

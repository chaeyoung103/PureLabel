//
//  HomeViewController.swift
//  PureLabel
//
//  Created by 송채영 on 9/28/24.
//

import UIKit

class HomeViewController: UIViewController {
    
    let logo = UIImageView().then {
        $0.image = UIImage(named: "logo_small")
        $0.contentMode = .scaleAspectFit
    }
    
    let analysisBtn = UIButton().then{
        $0.setTitle("화장품 성분 분석하러가기", for: .normal)
        $0.setTitleColor(.white, for: .normal)
        $0.backgroundColor = .textButtonColor
        $0.titleLabel?.font = UIFont.systemFont(ofSize: 13, weight: .regular)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .bgColor
        
        hierarchy()
        layout()
        
        self.analysisBtn.addTarget(self, action: #selector(analysisBtnDidTab), for: .touchUpInside)
        
    }
    
    @objc func analysisBtnDidTab() {
        let cameraViewController = CameraViewController()
        self.navigationController?.pushViewController(cameraViewController, animated: true)
    }
    
    //MARK: - Layout
    func hierarchy(){
        self.view.addSubview(logo)
        self.view.addSubview(analysisBtn)
    }
    
    func layout(){
        logo.snp.makeConstraints{ make in
            make.top.equalToSuperview().offset(100)
            make.leading.trailing.equalToSuperview()
            make.width.equalTo(180)
            make.height.equalTo(60)
        }
        analysisBtn.snp.makeConstraints{ make in
            make.top.equalTo(logo.snp.bottom).offset(40)
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
            make.height.equalTo(56)
        }
    }
}

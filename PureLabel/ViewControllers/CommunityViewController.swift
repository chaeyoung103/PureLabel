//
//  CommunityViewController.swift
//  PureLabel
//
//  Created by 송채영 on 9/28/24.
//
import UIKit

class CommunityViewController: UIViewController {
    
    let navigationBar = NavigationBar()
    
    let backGround = UIImageView().then {
        $0.image = UIImage(named: "community")
        $0.contentMode = .scaleAspectFit
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .bgColor
        
        hierarchy()
        layout()
        
        navigationBar.setTitle("커뮤니티")
        navigationBar.setLeftButton(false)
    }
    
    func hierarchy(){
        self.view.addSubview(navigationBar)
        self.view.addSubview(backGround)
    }
    
    func layout(){
        navigationBar.snp.makeConstraints{ make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.left.right.equalToSuperview()
            make.height.equalTo(42)
        }
        
        backGround.snp.makeConstraints{ make in
            make.top.equalTo(navigationBar.snp.bottom).offset(20)
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
            make.height.equalTo(675)
        }
        
        
    }
}

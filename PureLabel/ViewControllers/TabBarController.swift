//
//  TabBarController.swift
//  PureLabel
//
//  Created by 송채영 on 9/28/24.
//

import UIKit


class TabBarController: UITabBarController, UITabBarControllerDelegate {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.delegate = self
        
        let whiteBackgroundView = UIView()
        whiteBackgroundView.backgroundColor = .white
        whiteBackgroundView.translatesAutoresizingMaskIntoConstraints = false
        tabBar.addSubview(whiteBackgroundView)
        
        NSLayoutConstraint.activate([
            whiteBackgroundView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            whiteBackgroundView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            whiteBackgroundView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            whiteBackgroundView.heightAnchor.constraint(equalToConstant: 90) // 원하는 높이로 설정
        ])
        
        self.viewControllers = [createFirstViewController(), createSecondViewController(), createThirdViewController(),createFourViewController()]
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        self.viewControllers = [createFirstViewController(), createSecondViewController(), createThirdViewController(),createFourViewController()]
    }
    
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
            // 세 번째 탭이 선택되면 탭 바 숨김
            if viewController is CameraViewController {
                self.tabBar.isHidden = true
            } else {
                self.tabBar.isHidden = false
            }
        }
    
    func createFirstViewController() -> UIViewController {
        let firstViewController = HomeViewController()
        firstViewController.tabBarItem = UITabBarItem(title: "홈", image: UIImage(named: "home.deselect")?.withRenderingMode(.alwaysOriginal), tag: 0)
        firstViewController.tabBarItem.selectedImage = UIImage(named: "home.select")?.withRenderingMode(.alwaysOriginal)
        let attributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor.textButtonColor,
            .font: UIFont.systemFont(ofSize: 14, weight: .regular)
        ]
        firstViewController.tabBarItem.setTitleTextAttributes(attributes , for: .normal)
        let selectedAttributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor.buttonBgColor,
            .font: UIFont.systemFont(ofSize: 14, weight: .regular)
        ]
        firstViewController.tabBarItem.setTitleTextAttributes(selectedAttributes, for: .selected)
        firstViewController.tabBarItem.imageInsets = UIEdgeInsets(top: 5, left: 0, bottom: -5, right: 0)
        firstViewController.tabBarItem.titlePositionAdjustment = UIOffset(horizontal: 0, vertical: 10)
        return firstViewController
    }
    
    func createSecondViewController() -> UIViewController {
        let secondViewController = CameraViewController()
        secondViewController.tabBarItem = UITabBarItem(title: "분석", image: UIImage(named: "camera.deselect")?.withRenderingMode(.alwaysOriginal), tag:1)
        secondViewController.tabBarItem.selectedImage = UIImage(named: "camera.select")?.withRenderingMode(.alwaysOriginal)
        let attributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor.textButtonColor,
            .font: UIFont.systemFont(ofSize: 14, weight: .regular)
        ]
        secondViewController.tabBarItem.setTitleTextAttributes(attributes , for: .normal)
        let selectedAttributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor.buttonBgColor,
            .font: UIFont.systemFont(ofSize: 14, weight: .regular)
        ]
        secondViewController.tabBarItem.setTitleTextAttributes(selectedAttributes, for: .selected)
        secondViewController.tabBarItem.imageInsets = UIEdgeInsets(top: 5, left: 0, bottom: -5, right: 0)
        secondViewController.tabBarItem.titlePositionAdjustment = UIOffset(horizontal: 0, vertical: 10)
        return secondViewController
    }
    
    func createThirdViewController() -> UIViewController {
        let thirdViewController = CommunityViewController()
        thirdViewController.tabBarItem = UITabBarItem(title: "커뮤니티", image: UIImage(named: "community.deselect")?.withRenderingMode(.alwaysOriginal), tag:2)
        thirdViewController.tabBarItem.selectedImage = UIImage(named: "community.select")?.withRenderingMode(.alwaysOriginal)
        let attributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor.textButtonColor,
            .font: UIFont.systemFont(ofSize: 14, weight: .regular)
        ]
        thirdViewController.tabBarItem.setTitleTextAttributes(attributes , for: .normal)
        let selectedAttributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor.buttonBgColor,
            .font: UIFont.systemFont(ofSize: 14, weight: .regular)
        ]
        thirdViewController.tabBarItem.setTitleTextAttributes(selectedAttributes, for: .selected)
        thirdViewController.tabBarItem.imageInsets = UIEdgeInsets(top: 5, left: 0, bottom: -5, right: 0)
        thirdViewController.tabBarItem.titlePositionAdjustment = UIOffset(horizontal: 0, vertical: 10)
        return thirdViewController
    }
    
    func createFourViewController() -> UIViewController {
        let fourViewController = ProfileViewController()
        fourViewController.tabBarItem = UITabBarItem(title: "MY", image: UIImage(named: "profile.deselect")?.withRenderingMode(.alwaysOriginal), tag: 3)
        fourViewController.tabBarItem.selectedImage = UIImage(named: "profile.select")?.withRenderingMode(.alwaysOriginal)
        let attributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor.textButtonColor,
            .font: UIFont.systemFont(ofSize: 14, weight: .regular)
        ]
        fourViewController.tabBarItem.setTitleTextAttributes(attributes , for: .normal)
        let selectedAttributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor.buttonBgColor,
            .font: UIFont.systemFont(ofSize: 14, weight: .regular)
        ]
        fourViewController.tabBarItem.setTitleTextAttributes(selectedAttributes, for: .selected)
        fourViewController.tabBarItem.imageInsets = UIEdgeInsets(top: 5, left: 0, bottom: -5, right: 0)
        fourViewController.tabBarItem.titlePositionAdjustment = UIOffset(horizontal: 0, vertical: 10)
        return fourViewController
    }
}

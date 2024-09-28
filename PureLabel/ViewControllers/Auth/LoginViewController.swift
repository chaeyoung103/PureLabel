//
//  LoginViewController.swift
//  PureLabel
//
//  Created by 송채영 on 9/25/24.
//

import UIKit
import Then
import SnapKit

class LoginViewController: UIViewController, UITextFieldDelegate {
    
    //MARK: - UIComponents
    
    let logo = UIImageView().then {
        $0.image = UIImage(named: "logo_small")
        $0.contentMode = .scaleAspectFit
    }
    
    let id = UITextField().then{
        let placeholderText = "아이디를 입력해 주세요"
        let attributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor.textGray,
            .font: UIFont.systemFont(ofSize: 15) // 원하는 폰트와 사이즈로 설정
        ]
        $0.attributedPlaceholder = NSAttributedString(string: placeholderText, attributes: attributes)
        $0.layer.borderColor = UIColor.lightGray.cgColor
        $0.layer.borderWidth = 1
        $0.layer.cornerRadius = 10
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 12, height: $0.frame.size.height))
        $0.leftView = paddingView
        $0.leftViewMode = .always
        $0.returnKeyType = .next
        $0.backgroundColor = .white
        $0.font = UIFont.systemFont(ofSize: 15, weight: .regular)
        $0.enablesReturnKeyAutomatically = true
    }
    
    let password = UITextField().then{
        
        let placeholderText = "비밀번호를 입력해 주세요"
        let attributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor.textGray,
            .font: UIFont.systemFont(ofSize: 15)
        ]
        $0.attributedPlaceholder = NSAttributedString(string: placeholderText, attributes: attributes)
        $0.layer.borderColor = UIColor.lightGray.cgColor
        $0.layer.borderWidth = 1
        $0.layer.cornerRadius = 10
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 12, height: $0.frame.size.height))
        $0.leftView = paddingView
        $0.leftViewMode = .always
        $0.returnKeyType = .done
        $0.backgroundColor = .white
        $0.font = UIFont.systemFont(ofSize: 15, weight: .regular)
        $0.isSecureTextEntry = true
        $0.enablesReturnKeyAutomatically = true
    }
    
    let errMessage = UILabel().then{
        $0.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        $0.textColor = UIColor.errRed
        $0.text = "아이디 또는 비밀번호가 일치하지 않습니다"
        $0.textAlignment = .center
        $0.isHidden = true
    }
    
    let loginBtn = UIButton().then{
        $0.setTitle("로그인", for: .normal)
        $0.backgroundColor = .buttonBgColor
        $0.setTitleColor(.white, for: .normal)
        $0.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        $0.titleLabel?.textAlignment = .center
        $0.layer.cornerRadius = 8
    }
    
    let signUpBtn = UIButton().then{
        $0.setTitle("회원가입", for: .normal)
        $0.setTitleColor(.textButtonColor, for: .normal)
        $0.backgroundColor = .clear
        $0.titleLabel?.font = UIFont.systemFont(ofSize: 13, weight: .regular)
    }

    //MARK: - LifeCycles
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        self.view.backgroundColor = .bgColor
        
        hierarchy()
        layout()
        
        id.delegate = self
        password.delegate = self
        
        self.loginBtn.addTarget(self, action: #selector(loginBtnDidTab), for: .touchUpInside)
        self.signUpBtn.addTarget(self, action: #selector(signUpBtnDidTab), for: .touchUpInside)
        
        // 텍스트 필드의 텍스트 변경을 모니터링
        id.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        password.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        
        // 초기 버튼 상태 설정
        updateLoginButtonState()
    }
    
    //MARK: - Actions
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
        UIView.animate(withDuration: 0.3){
            self.view.window?.frame.origin.y = 0
        }
    }
    
    @objc private func textFieldDidChange() {
        updateLoginButtonState()
    }
    // 로그인 버튼의 활성화 상태를 업데이트하는 메서드
    private func updateLoginButtonState() {
        let isEmailEmpty = id.text?.isEmpty ?? true
        let isPasswordEmpty = password.text?.isEmpty ?? true
        
        loginBtn.isEnabled = !isEmailEmpty && !isPasswordEmpty
        
        if loginBtn.isEnabled {
            loginBtn.backgroundColor = .buttonBgColor // 활성화된 경우 배경색을 파란색으로 설정
        } else {
            loginBtn.backgroundColor = .buttonBgColor_inactive // 비활성화된 경우 배경색을 연한 회색으로 설정
        }
    }
    
    @objc func loginBtnDidTab() {
        
        ApiClient().login(self,LoginInput(id: id.text,password: password.text))
    }
    
    @objc func signUpBtnDidTab() {
        let signUpViewController = SignupViewController()
        self.navigationController?.pushViewController(signUpViewController, animated: true)
    }
    
    func showErr(isErr: Bool) {
        if (isErr){
            errMessage.isHidden = false
        }else {
            errMessage.isHidden = true
        }
    }
    
    //MARK: - Layout
    func hierarchy(){
        self.view.addSubview(logo)
        self.view.addSubview(id)
        self.view.addSubview(password)
        self.view.addSubview(errMessage)
        self.view.addSubview(loginBtn)
        self.view.addSubview(signUpBtn)
    }
    
    func layout(){
        logo.snp.makeConstraints{ make in
            make.top.equalToSuperview().offset(100)
            make.leading.trailing.equalToSuperview()
            make.width.equalTo(180)
            make.height.equalTo(60)
        }
        id.snp.makeConstraints{ make in
            make.top.equalTo(logo.snp.bottom).offset(60)
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
            make.height.equalTo(46)
        }
        password.snp.makeConstraints{ make in
            make.top.equalTo(id.snp.bottom).offset(10)
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
            make.height.equalTo(46)
        }
        errMessage.snp.makeConstraints{ make in
            make.top.equalTo(password.snp.bottom).offset(5)
            make.leading.equalToSuperview().offset(25)
        }
        loginBtn.snp.makeConstraints{ make in
            make.top.equalTo(password.snp.bottom).offset(60)
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
            make.height.equalTo(48)
        }
        
        signUpBtn.snp.makeConstraints{ make in
            make.top.equalTo(loginBtn.snp.bottom).offset(10)
            make.centerX.equalToSuperview()
            make.width.equalTo(56)
            make.height.equalTo(24)
        }

    }
}

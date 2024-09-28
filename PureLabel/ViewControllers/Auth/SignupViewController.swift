//
//  SignupViewController.swift
//  PureLabel
//
//  Created by 송채영 on 9/27/24.
//

import UIKit
import Then
import SnapKit

class SignupViewController: UIViewController {
    //MARK: - UIComponents
    
    let navigationBar = NavigationBar()
    
    let nameLabel = UILabel().then{
        $0.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        $0.textColor = .textBlack
        $0.text = "이름*"
    }
    
    let name = UITextField().then{
        let placeholderText = "이름을 입력해 주세요"
        let attributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor.lightGray,
            .font: UIFont.systemFont(ofSize: 16) // 원하는 폰트와 사이즈로 설정
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
        $0.font = UIFont.systemFont(ofSize: 13, weight: .regular)
    }
    
    let idLabel = UILabel().then{
        $0.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        $0.textColor = .textBlack
        $0.text = "아이디*"

    }
    
    let id = UITextField().then{
        let placeholderText = "아이디를 입력해 주세요"
        let attributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor.lightGray,
            .font: UIFont.systemFont(ofSize: 13) // 원하는 폰트와 사이즈로 설정
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
        $0.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        $0.enablesReturnKeyAutomatically = true
    }
    
    let idErrMessage = UILabel().then{
        $0.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        $0.textColor = .errRed
        $0.text = "중복된 아이디입니다"
        $0.isHidden = false
    }
    
    let passwordLabel = UILabel().then{
        $0.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        $0.textColor = .textBlack
        $0.text = "비밀번호*"
    }
    
    let password = UITextField().then{
        
        let placeholderText = "비밀번호를 입력해 주세요"
        let attributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor.lightGray,
            .font: UIFont.systemFont(ofSize: 13)
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
        $0.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        $0.isSecureTextEntry = true
        $0.enablesReturnKeyAutomatically = true
    }
    
    let passwordErrMessage = UILabel().then{
        $0.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        $0.textColor = .errRed
        $0.text = "영문, 한글이 각 1개이상 포함되어야합니다 "
        $0.isHidden = false
    }
    
    let passwordCheckLabel = UILabel().then{
        $0.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        $0.textColor = .textBlack
        $0.text = "비밀번호 확인*"
    }
    
    let passwordCheck = UITextField().then{
        let placeholderText = "다시한번 입력해 주세요"
        let attributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor.lightGray,
            .font: UIFont.systemFont(ofSize: 13)
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
        $0.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        $0.isSecureTextEntry = true
        $0.enablesReturnKeyAutomatically = true
    }
    
    let passwordCheckErrMessage = UILabel().then{
        $0.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        $0.textColor = .errRed
        $0.text = "비밀번호가 일치하지 않습니다"
        $0.isHidden = false
    }
    
    let signUpBtn = UIButton().then{
        $0.setTitle("다음", for: .normal)
        $0.backgroundColor = .buttonBgColor
        $0.setTitleColor(.white, for: .normal)
        $0.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        $0.titleLabel?.textAlignment = .center
        $0.layer.cornerRadius = 8
        $0.isEnabled = true
    }

    //MARK: - LifeCycles
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        self.view.backgroundColor = .bgColor
        
        hierarchy()
        layout()
        
        navigationBar.setTitle("회원가입")
        navigationBar.setLeftButtonAction { [weak self] in
            self?.navigationController?.popViewController(animated: true)
        }
        
        name.delegate = self
        id.delegate = self
        password.delegate = self
        passwordCheck.delegate = self
        
        self.signUpBtn.addTarget(self, action: #selector(signUpBtnDidTab), for: .touchUpInside)
        
        // 텍스트 필드의 텍스트 변경을 모니터링
        name.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        id.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        password.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        passwordCheck.addTarget(self, action: #selector(passwordCheckTextFieldDidChange), for: .editingChanged)

//        // 초기 버튼 상태 설정
//        updateLoginButtonState()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
        UIView.animate(withDuration: 0.3){
            self.view.window?.frame.origin.y = 0
        }
    }
    
    @objc func signUpBtnDidTab() {
        print("dd")
        let signUpViewController2 = SignupViewController2()
        self.navigationController?.pushViewController(signUpViewController2, animated: true)
        
    }
    
    @objc func passwordCheckTextFieldDidChange() {
        
        if password.text != passwordCheck.text {
            passwordCheckErrMessage.isHidden = false
        }else{
            passwordCheckErrMessage.isHidden = true
        }
        updateLoginButtonState()
        
    }
    
    @objc func textFieldDidChange() {
//        updateLoginButtonState()
        
    }
    
    // 완료 버튼의 활성화 상태를 업데이트하는 메서드
    private func updateLoginButtonState() {
        let isNameEmpty = name.text?.isEmpty ?? true
        let isEmailEmpty = id.text?.isEmpty ?? true
        let isPasswordEmpty = password.text?.isEmpty ?? true
        let isPasswordCheckEmpty = passwordCheck.text?.isEmpty ?? true
        
        signUpBtn.isEnabled = !isNameEmpty && !isEmailEmpty && !isPasswordEmpty && !isPasswordCheckEmpty
        
        if signUpBtn.isEnabled {
            signUpBtn.backgroundColor = .buttonBgColor
        } else {
            signUpBtn.backgroundColor = .buttonBgColor_inactive
        }
    }
    
    func hierarchy(){
        self.view.addSubview(navigationBar)
        self.view.addSubview(nameLabel)
        self.view.addSubview(name)
        self.view.addSubview(idLabel)
        self.view.addSubview(id)
        self.view.addSubview(idErrMessage)
        self.view.addSubview(passwordLabel)
        self.view.addSubview(password)
        self.view.addSubview(passwordErrMessage)
        self.view.addSubview(passwordCheckLabel)
        self.view.addSubview(passwordCheck)
        self.view.addSubview(passwordCheckErrMessage)
        self.view.addSubview(signUpBtn)
    }
    
    func layout(){
        navigationBar.snp.makeConstraints{ make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
                make.left.right.equalToSuperview()
                make.height.equalTo(42)
        }
        nameLabel.snp.makeConstraints{ make in
            make.top.equalTo(navigationBar.snp.bottom).offset(25)
            make.leading.equalToSuperview().offset(24)
            make.height.equalTo(24)
        }
        name.snp.makeConstraints{ make in
            make.top.equalTo(nameLabel.snp.bottom).offset(10)
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
            make.height.equalTo(46)
        }
        idLabel.snp.makeConstraints{ make in
            make.top.equalTo(name.snp.bottom).offset(39)
            make.leading.equalToSuperview().offset(24)
            make.height.equalTo(24)
        }
        id.snp.makeConstraints{ make in
            make.top.equalTo(idLabel.snp.bottom).offset(10)
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
            make.height.equalTo(46)
        }
        idErrMessage.snp.makeConstraints{ make in
            make.top.equalTo(id.snp.bottom).offset(5)
            make.leading.equalToSuperview().offset(25)
            make.height.equalTo(15)
        }
        passwordLabel.snp.makeConstraints{ make in
            make.top.equalTo(id.snp.bottom).offset(39)
            make.leading.equalToSuperview().offset(24)
            make.height.equalTo(24)
        }
        password.snp.makeConstraints{ make in
            make.top.equalTo(passwordLabel.snp.bottom).offset(10)
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
            make.height.equalTo(46)
        }
        passwordErrMessage.snp.makeConstraints{ make in
            make.top.equalTo(password.snp.bottom).offset(5)
            make.leading.equalToSuperview().offset(25)
            make.height.equalTo(15)
        }
        passwordCheckLabel.snp.makeConstraints{ make in
            make.top.equalTo(password.snp.bottom).offset(39)
            make.leading.equalToSuperview().offset(24)
            make.height.equalTo(24)
        }
        passwordCheck.snp.makeConstraints{ make in
            make.top.equalTo(passwordCheckLabel.snp.bottom).offset(10)
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
            make.height.equalTo(46)
        }
        passwordCheckErrMessage.snp.makeConstraints{ make in
            make.top.equalTo(passwordCheck.snp.bottom).offset(5)
            make.leading.equalToSuperview().offset(25)
            make.height.equalTo(15)
        }
        
        signUpBtn.snp.makeConstraints{ make in
            make.bottom.equalToSuperview().offset(-50)
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
            make.height.equalTo(48)
        }

    }
}

//MARK: - Keyboard

extension SignupViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == name {
            id.becomeFirstResponder()
        }
        else if textField == id{
            password.becomeFirstResponder()
        }
        else if textField == password{
            passwordCheck.becomeFirstResponder()
        }
        else if textField == passwordCheck {
            passwordCheck.resignFirstResponder()
        }
        return true
    }
}

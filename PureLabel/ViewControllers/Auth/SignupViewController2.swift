

//
//  SignupViewController.swift
//  PureLabel
//
//  Created by 송채영 on 9/27/24.
//

import UIKit
import Then
import SnapKit

class SignupViewController2: UIViewController {
    
    var selectedGender = "여성"
    var selectedSkinType = ""
    var selectedWorries: [String] = []
    
    let tagList = ["여드름","아토피","피지","민감성","속건조","주름","탄력","모공","홍조","각질","다크서클","미백","잡티","해당없음"]
    //MARK: - UIComponents
    
    let navigationBar = NavigationBar()
    
    let genderLabel = UILabel().then{
        $0.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        $0.textColor = .textBlack
        $0.text = "성별*"
    }
    
    let genderDescription = UILabel().then{
        $0.font = UIFont.systemFont(ofSize: 13, weight: .semibold)
        $0.textColor = .lightGray
        $0.text = "성별을 선택해주세요"
    }
    
    let femaleBtn = UIButton().then{
        $0.setImage(UIImage(named: "selected"), for: .selected)
        $0.setImage(UIImage(named: "deselected"), for: .normal)
        $0.isSelected = true
    }
    
    let femaleLabel = UILabel().then{
        $0.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        $0.textColor = .textDarkBrown
        $0.text = "여성"
    }
    
    let maleBtn = UIButton().then{
        $0.setImage(UIImage(named: "selected"), for: .selected)
        $0.setImage(UIImage(named: "deselected"), for: .normal)
        $0.isSelected = false
    }
    
    let maleLabel = UILabel().then{
        $0.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        $0.textColor = .textDarkBrown
        $0.text = "남성"
    }
    
    let skinType = UILabel().then{
        $0.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        $0.textColor = .textBlack
        $0.text = "피부 타입*"
        
    }
    
    let skinTypeDescription = UILabel().then{
        $0.font = UIFont.systemFont(ofSize: 13, weight: .semibold)
        $0.textColor = .lightGray
        $0.text = "해당하는 타입 1개를 선택해주세요"
    }
    
    let skin1Btn = UIButton().then{
        $0.setImage(UIImage(named: "selected"), for: .selected)
        $0.setImage(UIImage(named: "deselected"), for: .normal)
        $0.isSelected = false
    }
    
    let skin1Label = UILabel().then{
        $0.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        $0.textColor = .textDarkBrown
        $0.text = "복합성"
    }
    
    
    let skin2Btn = UIButton().then{
        $0.setImage(UIImage(named: "selected"), for: .selected)
        $0.setImage(UIImage(named: "deselected"), for: .normal)
        $0.isSelected = false
    }
    let skin2Label = UILabel().then{
        $0.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        $0.textColor = .textDarkBrown
        $0.text = "지성"
    }
    
    let skin3Btn = UIButton().then{
        $0.setImage(UIImage(named: "selected"), for: .selected)
        $0.setImage(UIImage(named: "deselected"), for: .normal)
        $0.isSelected = false
    }
    let skin3Label = UILabel().then{
        $0.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        $0.textColor = .textDarkBrown
        $0.text = "중성"
    }
    
    let skin4Btn = UIButton().then{
        $0.setImage(UIImage(named: "selected"), for: .selected)
        $0.setImage(UIImage(named: "deselected"), for: .normal)
        $0.isSelected = false
    }
    
    let skin4Label = UILabel().then{
        $0.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        $0.textColor = .textDarkBrown
        $0.text = "건성"
    }
    
    let skin5Btn = UIButton().then{
        $0.setImage(UIImage(named: "selected"), for: .selected)
        $0.setImage(UIImage(named: "deselected"), for: .normal)
        $0.isSelected = false
    }
    let skin5Label = UILabel().then{
        $0.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        $0.textColor = .textDarkBrown
        $0.text = "수부지"
    }
    let skinWorries = UILabel().then{
        $0.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        $0.textColor = .textBlack
        $0.text = "피부 고민*"
    }
    
    let skinWorriesDescription = UILabel().then{
        $0.font = UIFont.systemFont(ofSize: 13, weight: .semibold)
        $0.textColor = .lightGray
        $0.text = "피부 고민을 최대 5개까지 선택해주세요"
    }
    
    let skinWorriesCollectionView = UICollectionView(frame: .init(), collectionViewLayout: UICollectionViewLayout()).then{
        $0.allowsSelection = false
        $0.backgroundColor = .bgColor
        $0.showsVerticalScrollIndicator = false
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.isScrollEnabled = false
        $0.register(TagCell.self, forCellWithReuseIdentifier: TagCell.cellIdentifier)
    }
    
    
    let signUpBtn = UIButton().then{
        $0.setTitle("완료", for: .normal)
        $0.backgroundColor = .buttonBgColor
        $0.setTitleColor(.white, for: .normal)
        $0.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        $0.titleLabel?.textAlignment = .center
        $0.layer.cornerRadius = 8
        $0.isEnabled = false
    }
    
    //MARK: - LifeCycles
    
    var receivedData: Props
    
    init(data: Props) {
        self.receivedData = data
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func viewDidLoad() {
        
        super.viewDidLoad()
        self.view.backgroundColor = .bgColor
        
        hierarchy()
        layout()
        
        navigationBar.setTitle("회원가입")
        navigationBar.setLeftButtonAction { [weak self] in
            self?.navigationController?.popViewController(animated: true)
        }
        
        updateSignUpButtonState()
        
        let layout = LeftAlignedCollectionViewFlowLayout()
        layout.minimumLineSpacing = 12
        layout.minimumInteritemSpacing = 8
        self.skinWorriesCollectionView.collectionViewLayout = layout
        self.skinWorriesCollectionView.delegate = self
        self.skinWorriesCollectionView.dataSource = self
        self.skinWorriesCollectionView.allowsMultipleSelection = true
        
        self.femaleBtn.addTarget(self, action: #selector(femaleBtnDidTab), for: .touchUpInside)
        self.maleBtn.addTarget(self, action: #selector(maleBtnDidTab), for: .touchUpInside)
        
        self.skin1Btn.addTarget(self, action: #selector(skin1BtnDidTab), for: .touchUpInside)
        self.skin2Btn.addTarget(self, action: #selector(skin2BtnDidTab), for: .touchUpInside)
        self.skin3Btn.addTarget(self, action: #selector(skin3BtnDidTab), for: .touchUpInside)
        self.skin4Btn.addTarget(self, action: #selector(skin4BtnDidTab), for: .touchUpInside)
        self.skin5Btn.addTarget(self, action: #selector(skin5BtnDidTab), for: .touchUpInside)
        
        self.signUpBtn.addTarget(self, action: #selector(signUpBtnDidTab), for: .touchUpInside)
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
        UIView.animate(withDuration: 0.3){
            self.view.window?.frame.origin.y = 0
        }
    }
    
    func showAlert(message:String) {
        let alertController = UIAlertController(title: message, message: nil, preferredStyle: .alert)
        
        // "확인" 버튼 추가
        let confirmAction = UIAlertAction(title: "확인", style: .default, handler: nil)
        alertController.addAction(confirmAction)
        
        // 알림창을 화면에 표시
        self.present(alertController, animated: true, completion: nil)
    }
    
    // 완료 버튼의 활성화 상태를 업데이트하는 메서드
    private func updateSignUpButtonState() {
        let isSkinType = selectedSkinType.isEmpty
        
        signUpBtn.isEnabled = !isSkinType
        
        if signUpBtn.isEnabled {
            signUpBtn.backgroundColor = .buttonBgColor
        } else {
            signUpBtn.backgroundColor = .buttonBgColor_inactive
        }
    }
    
    @objc func signUpBtnDidTab() {
        let signupData = SignupInput(name:receivedData.name,id: receivedData.id,password: receivedData.password,gender: selectedGender,skinType: selectedSkinType,skinWorries: selectedWorries)
        ApiClient().signup(self,signupData)
        
    }
    
    @objc func femaleBtnDidTab() {
        femaleBtn.isSelected = true
        maleBtn.isSelected = false
        selectedGender = "여성"
        updateSignUpButtonState()
    }
    
    @objc func maleBtnDidTab() {
        femaleBtn.isSelected = false
        maleBtn.isSelected = true
        selectedGender = "남성"
        updateSignUpButtonState()
    }
    
    @objc func skin1BtnDidTab() {
        skin1Btn.isSelected = true
        skin2Btn.isSelected = false
        skin3Btn.isSelected = false
        skin4Btn.isSelected = false
        skin5Btn.isSelected = false
        selectedSkinType = "복합성"
        updateSignUpButtonState()
    }
    
    @objc func skin2BtnDidTab() {
        skin1Btn.isSelected = false
        skin2Btn.isSelected = true
        skin3Btn.isSelected = false
        skin4Btn.isSelected = false
        skin5Btn.isSelected = false
        selectedSkinType = "지성"
        updateSignUpButtonState()
    }
    
    @objc func skin3BtnDidTab() {
        skin1Btn.isSelected = false
        skin2Btn.isSelected = false
        skin3Btn.isSelected = true
        skin4Btn.isSelected = false
        skin5Btn.isSelected = false
        selectedSkinType = "중성"
        updateSignUpButtonState()
    }
    
    @objc func skin4BtnDidTab() {
        skin1Btn.isSelected = false
        skin2Btn.isSelected = false
        skin3Btn.isSelected = false
        skin4Btn.isSelected = true
        skin5Btn.isSelected = false
        selectedSkinType = "건성"
        updateSignUpButtonState()

    }
    
    @objc func skin5BtnDidTab() {
        skin1Btn.isSelected = false
        skin2Btn.isSelected = false
        skin3Btn.isSelected = false
        skin4Btn.isSelected = false
        skin5Btn.isSelected = true
        selectedSkinType = "수부지"
        updateSignUpButtonState()
    }
    
    func hierarchy(){
        self.view.addSubview(navigationBar)
        self.view.addSubview(genderLabel)
        self.view.addSubview(genderDescription)
        self.view.addSubview(femaleBtn)
        self.view.addSubview(femaleLabel)
        self.view.addSubview(maleBtn)
        self.view.addSubview(maleLabel)
        self.view.addSubview(skinType)
        self.view.addSubview(skinTypeDescription)
        self.view.addSubview(skin1Btn)
        self.view.addSubview(skin1Label)
        self.view.addSubview(skin2Btn)
        self.view.addSubview(skin2Label)
        self.view.addSubview(skin3Btn)
        self.view.addSubview(skin3Label)
        self.view.addSubview(skin4Btn)
        self.view.addSubview(skin4Label)
        self.view.addSubview(skin5Btn)
        self.view.addSubview(skin5Label)
        self.view.addSubview(skinWorries)
        self.view.addSubview(skinWorriesDescription)
        self.view.addSubview(skinWorriesCollectionView)
        self.view.addSubview(signUpBtn)
    }
    
    func layout(){
        navigationBar.snp.makeConstraints{ make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.left.right.equalToSuperview()
            make.height.equalTo(42)
        }
        genderLabel.snp.makeConstraints{ make in
            make.top.equalTo(navigationBar.snp.bottom).offset(25)
            make.leading.equalToSuperview().offset(24)
            make.height.equalTo(24)
        }
        genderDescription.snp.makeConstraints{ make in
            make.top.equalTo(genderLabel.snp.bottom).offset(8)
            make.leading.equalToSuperview().offset(24)
            make.height.equalTo(20)
        }
        
        femaleBtn.snp.makeConstraints{ make in
            make.top.equalTo(genderDescription.snp.bottom).offset(16)
            make.leading.equalToSuperview().offset(24)
            make.size.equalTo(16)
        }
        femaleLabel.snp.makeConstraints{ make in
            make.centerY.equalTo(femaleBtn)
            make.leading.equalTo(femaleBtn.snp.trailing).offset(8)
            make.height.equalTo(21)
        }
        maleBtn.snp.makeConstraints{ make in
            make.top.equalTo(femaleBtn.snp.bottom).offset(16)
            make.leading.equalToSuperview().offset(24)
            make.size.equalTo(16)
        }
        maleLabel.snp.makeConstraints{ make in
            make.centerY.equalTo(maleBtn)
            make.leading.equalTo(maleBtn.snp.trailing).offset(8)
            make.height.equalTo(21)
        }
        skinType.snp.makeConstraints{ make in
            make.top.equalTo(maleBtn.snp.bottom).offset(30)
            make.leading.equalToSuperview().offset(24)
            make.height.equalTo(24)
        }
        skinTypeDescription.snp.makeConstraints{ make in
            make.top.equalTo(skinType.snp.bottom).offset(8)
            make.leading.equalToSuperview().offset(24)
            make.height.equalTo(20)
        }
        skin1Btn.snp.makeConstraints{ make in
            make.top.equalTo(skinTypeDescription.snp.bottom).offset(16)
            make.leading.equalToSuperview().offset(24)
            make.size.equalTo(16)
        }
        skin1Label.snp.makeConstraints{ make in
            make.centerY.equalTo(skin1Btn)
            make.leading.equalTo(skin1Btn.snp.trailing).offset(8)
            make.height.equalTo(21)
        }
        skin2Btn.snp.makeConstraints{ make in
            make.top.equalTo(skin1Btn.snp.bottom).offset(16)
            make.leading.equalToSuperview().offset(24)
            make.size.equalTo(16)
        }
        skin2Label.snp.makeConstraints{ make in
            make.centerY.equalTo(skin2Btn)
            make.leading.equalTo(skin1Btn.snp.trailing).offset(8)
            make.height.equalTo(21)
        }
        skin3Btn.snp.makeConstraints{ make in
            make.top.equalTo(skin2Btn.snp.bottom).offset(16)
            make.leading.equalToSuperview().offset(24)
            make.size.equalTo(16)
        }
        skin3Label.snp.makeConstraints{ make in
            make.centerY.equalTo(skin3Btn)
            make.leading.equalTo(skin3Btn.snp.trailing).offset(8)
            make.height.equalTo(21)
        }
        skin4Btn.snp.makeConstraints{ make in
            make.top.equalTo(skin3Btn.snp.bottom).offset(16)
            make.leading.equalToSuperview().offset(24)
            make.size.equalTo(16)
        }
        skin4Label.snp.makeConstraints{ make in
            make.centerY.equalTo(skin4Btn)
            make.leading.equalTo(skin1Btn.snp.trailing).offset(8)
            make.height.equalTo(21)
        }
        skin5Btn.snp.makeConstraints{ make in
            make.top.equalTo(skin4Btn.snp.bottom).offset(16)
            make.leading.equalToSuperview().offset(24)
            make.size.equalTo(16)
        }
        skin5Label.snp.makeConstraints{ make in
            make.centerY.equalTo(skin5Btn)
            make.leading.equalTo(skin5Btn.snp.trailing).offset(8)
            make.height.equalTo(21)
        }
        
        skinWorries.snp.makeConstraints{ make in
            make.top.equalTo(skin5Btn.snp.bottom).offset(30)
            make.leading.equalToSuperview().offset(24)
            make.height.equalTo(24)
        }
        skinWorriesDescription.snp.makeConstraints{ make in
            make.top.equalTo(skinWorries.snp.bottom).offset(8)
            make.leading.equalToSuperview().offset(24)
            make.height.equalTo(20)
        }
        
        skinWorriesCollectionView.snp.makeConstraints{ make in
            make.top.equalTo(skinWorriesDescription.snp.bottom).offset(16)
            make.leading.equalToSuperview().offset(24)
            make.trailing.equalToSuperview().offset(-24)
            make.height.equalTo(110)
        }
        
        signUpBtn.snp.makeConstraints{ make in
            make.bottom.equalToSuperview().offset(-50)
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
            make.height.equalTo(48)
        }
        
    }
}

//MARK: - CollectionViewDelegate
extension SignupViewController2: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return tagList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TagCell.cellIdentifier, for: indexPath) as? TagCell else{
            fatalError()
        }
        cell.tagLabel.layer.borderColor = UIColor.textDarkBrown.cgColor
        cell.tagLabel.text = tagList[indexPath.row]
        cell.tagLabel.textColor = .textDarkBrown
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TagCell.cellIdentifier, for: indexPath) as? TagCell else{
            fatalError()
        }
        
        cell.tagLabel.text = tagList[indexPath.row]
        
        cell.tagLabel.sizeToFit()
        
        let cellWidth = cell.tagLabel.frame.width + 24
        
        let size = CGSize(width: cellWidth, height: 28)
        
        return size
    }
    
    

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedTag = tagList[indexPath.row]
        
        // "해당없음" 선택 시 다른 셀 선택 해제
        if selectedTag == "해당없음" {
            selectedWorries.removeAll()
            for i in 0..<collectionView.numberOfItems(inSection: indexPath.section) {
                let deselectIndexPath = IndexPath(row: i, section: indexPath.section)
                collectionView.deselectItem(at: deselectIndexPath, animated: false)
            }
            selectedWorries.append("해당없음")
            return
        }
        
        // "해당없음" 해제
        if let noneIndex = selectedWorries.firstIndex(of: "해당없음") {
            selectedWorries.remove(at: noneIndex)
            let noneIndexPath = IndexPath(row: 11, section: indexPath.section)
            collectionView.deselectItem(at: noneIndexPath, animated: false)
        }
        
        // 이미 선택된 항목은 해제 처리
        if selectedWorries.contains(selectedTag) {
            if let indexToRemove = selectedWorries.firstIndex(of: selectedTag) {
                selectedWorries.remove(at: indexToRemove)
            }
        } else {
            // 5개 초과 선택 방지
            if selectedWorries.count >= 5 {
                showAlert(message: "5개 이하로 선택해주세요")
                collectionView.deselectItem(at: indexPath, animated: true)
                return
            }
            selectedWorries.append(selectedTag)
        }
        updateSignUpButtonState()
    }

    func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        let selectedTag = tagList[indexPath.row]
        
        // "해당없음" 선택 시 다른 셀 선택 해제 처리
        if selectedTag == "해당없음" {
            return true
        }
        
        // 5개 초과 선택 방지
        if selectedWorries.count >= 5 && !selectedWorries.contains(selectedTag) {
            showAlert(message: "5개 이하로 선택해주세요")
            return false
        }
        updateSignUpButtonState()
        
        return true
    }

}

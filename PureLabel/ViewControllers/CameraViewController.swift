//
//  CameraViewController.swift
//  PureLabel
//
//  Created by 송채영 on 9/28/24.
//

import UIKit
import AVFoundation
import SnapKit
import Then
import VisionKit
import Vision

class CameraViewController: UIViewController, AVCapturePhotoCaptureDelegate, UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    
    // AVCaptureSession 인스턴스 생성
    var captureSession: AVCaptureSession!
    var videoPreviewLayer: AVCaptureVideoPreviewLayer!
    var photoOutput: AVCapturePhotoOutput!
    var currentCameraPosition: AVCaptureDevice.Position = .back
    
    let navigationBar = UIView().then{
        $0.backgroundColor = .buttonBgColor
    }
    
    let backButton = UIButton().then{
        $0.setImage(UIImage(named: "backArrow"), for: .normal)
    }
    
    let menuButton = UIButton().then{
        $0.setImage(UIImage(named: "menu"), for: .normal)
    }
    
    let cameraControlBar = UIView().then{
        $0.backgroundColor = .buttonBgColor
    }
    
    let galleryButton = UIButton().then{
        $0.setImage(UIImage(named: "gallery"), for: .normal)
    }
    
    let turnButton = UIButton().then{
        $0.setImage(UIImage(named: "turn"), for: .normal)
    }
    
    let cameraView = UIView().then{
        $0.backgroundColor = .white
    }
    
    let pictureButton = UIButton().then{
        $0.backgroundColor = .buttonBgColor
        $0.layer.cornerRadius = 35
        $0.layer.borderColor = UIColor.textButtonColor.cgColor
        $0.layer.borderWidth = 3
    }
    
    let sendButton = UIButton().then{
        $0.setImage(UIImage(named: "send"), for: .normal)
        $0.isHidden = true
    }
    
    let resultImage = UIImageView().then {
        $0.image = UIImage(named: "default")
        $0.backgroundColor = .imgBgColor
        $0.contentMode = .scaleAspectFit
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .textButtonColor // 배경색 설정
        
        
        hierarchy()
        layout()
        
        // 카메라 세션 구성
        setupCamera()
        
        self.backButton.addTarget(self, action: #selector(backButtonDidTab), for: .touchUpInside)
        self.pictureButton.addTarget(self, action: #selector(pictureButtonDidTab), for: .touchUpInside)
        self.turnButton.addTarget(self, action: #selector(turnButtonDidTab), for: .touchUpInside)
        self.galleryButton.addTarget(self, action: #selector(galleryButtonDidTab), for: .touchUpInside)
        self.sendButton.addTarget(self, action: #selector(sendButtonDidTab), for: .touchUpInside)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    @objc func backButtonDidTab() {
        if let tabBarController = self.tabBarController {
            tabBarController.selectedIndex = 0 // 원하는 탭 인덱스 설정 (예: 두 번째 탭)
            tabBarController.tabBar.isHidden = false
        }
    }
    
    @objc func galleryButtonDidTab() {
        // UIImagePickerController 초기화
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.sourceType = .photoLibrary
        imagePickerController.allowsEditing = false  // 수정 허용 여부
        
        // 이미지 피커를 표시
        present(imagePickerController, animated: true, completion: nil)
    }
    
    // 이미지 선택 시 호출되는 delegate 메서드
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        // 선택된 이미지를 가져옴
        if let selectedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            // 선택된 이미지를 처리
            // 예: 이미지 뷰에 설정
            self.resultImage.image = selectedImage
        }
        
        // 이미지 피커 닫기
        picker.dismiss(animated: true, completion: nil)
        pictureButton.isEnabled = false
        galleryButton.isHidden = true
        turnButton.isHidden = true
        sendButton.isHidden = false
        recognizeText(image:self.resultImage.image)
        self.view.addSubview(resultImage)
        resultImage.snp.makeConstraints{ make in
            make.top.equalTo(navigationBar.snp.bottom)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalToSuperview().offset(-180)
        }
    }
    
    // 이미지 선택 취소 시 호출되는 delegate 메서드
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        // 이미지 피커 닫기
        picker.dismiss(animated: true, completion: nil)
    }
    
    @objc func turnButtonDidTab() {
        // 현재 카메라 포지션을 전환
        currentCameraPosition = currentCameraPosition == .back ? .front : .back
        
        // 세션을 멈춤
        captureSession.stopRunning()
        
        // 기존 입력 제거
        guard let currentInput = captureSession.inputs.first else { return }
        captureSession.removeInput(currentInput)
        
        // 새로운 카메라 설정
        let newCameraDevice = currentCameraPosition == .back
        ? AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .back)
        : AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .front)
        
        do {
            // 새로운 입력 추가
            let newInput = try AVCaptureDeviceInput(device: newCameraDevice!)
            captureSession.addInput(newInput)
        } catch {
            print("카메라 전환 중 오류 발생: \(error)")
            return
        }
        
        // 세션 다시 시작
        DispatchQueue.global(qos: .userInitiated).async {
            self.captureSession.startRunning()
        }
    }
    
    @objc func pictureButtonDidTab() {
        // Capture a photo when the button is pressed
        let settings = AVCapturePhotoSettings()
        settings.flashMode = .auto
        settings.isAutoStillImageStabilizationEnabled = true
        photoOutput.capturePhoto(with: settings, delegate: self) // Capture photo
        
    }
    
    @objc func sendButtonDidTab() {
        let analysisVC = ResultViewController(data:resultImage.image!)
        self.navigationController?.pushViewController(analysisVC, animated: true)
    }
    
    func setupCamera() {
        // 1. Capture Session 초기화
        captureSession = AVCaptureSession()
        captureSession.sessionPreset = .high
        
        // 2. 디바이스 선택 (기본 후면 카메라)
        guard let backCamera = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .back) else {
            print("후면 카메라를 찾을 수 없습니다.")
            return
        }
        
        do {
            // 3. 카메라를 입력으로 설정
            let input = try AVCaptureDeviceInput(device: backCamera)
            captureSession.addInput(input)
        } catch {
            print("카메라 입력을 추가하는 데 실패했습니다: \(error)")
            return
        }
        
        // 4. 출력 설정 (사진 출력 추가)
        photoOutput = AVCapturePhotoOutput()
        guard captureSession.canAddOutput(photoOutput) else {
            print("사진 출력 추가를 실패했습니다.")
            return
        }
        captureSession.addOutput(photoOutput)
        
        // 5. 출력 설정 (화면에 카메라 프리뷰 표시)
        videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        videoPreviewLayer.videoGravity = .resizeAspectFill
        videoPreviewLayer.frame = view.frame
        self.cameraView.layer.addSublayer(videoPreviewLayer)
        
        // 6. 카메라 세션 시작
        DispatchQueue.global(qos: .userInitiated).async {
            self.captureSession.startRunning()
        }
    }
    
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        guard let imageData = photo.fileDataRepresentation() else {
            print("사진 데이터 생성에 실패했습니다.")
            return
        }
        // 사진 데이터를 UIImage로 변환
        let capturedImage = UIImage(data: imageData)
        
        // Handle the captured image (e.g., save to gallery, display preview, etc.)
        print("사진이 성공적으로 찍혔습니다!")
        pictureButton.isEnabled = false
        galleryButton.isHidden = true
        turnButton.isHidden = true
        sendButton.isHidden = false
        resultImage.image = capturedImage
        recognizeText(image:capturedImage)
        self.view.addSubview(resultImage)
        resultImage.snp.makeConstraints{ make in
            make.top.equalTo(navigationBar.snp.bottom)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalToSuperview().offset(-180)
        }
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
    
    func hierarchy(){
        self.view.addSubview(navigationBar)
        self.view.addSubview(backButton)
        self.view.addSubview(menuButton)
        self.view.addSubview(cameraView)
        self.view.addSubview(cameraControlBar)
        self.view.addSubview(galleryButton)
        self.view.addSubview(turnButton)
        self.view.addSubview(pictureButton)
        self.view.addSubview(sendButton)
    }
    
    func layout(){
        navigationBar.snp.makeConstraints{ make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(50)
        }
        
        backButton.snp.makeConstraints{ make in
            make.centerY.equalTo(navigationBar)
            make.leading.equalToSuperview().offset(12)
            make.size.equalTo(24)
        }
        
        menuButton.snp.makeConstraints{ make in
            make.centerY.equalTo(navigationBar)
            make.trailing.equalToSuperview().offset(-10)
            make.size.equalTo(24)
        }
        
        cameraView.snp.makeConstraints{ make in
            make.top.equalTo(navigationBar.snp.bottom)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalTo(cameraControlBar.snp.top)
        }
        
        cameraControlBar.snp.makeConstraints{ make in
            make.bottom.equalToSuperview()
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(180)
        }
        
        galleryButton.snp.makeConstraints{ make in
            make.centerY.equalTo(cameraControlBar)
            make.trailing.equalTo(pictureButton.snp.leading).offset(-40)
            make.size.equalTo(30)
        }
        
        turnButton.snp.makeConstraints{ make in
            make.centerY.equalTo(cameraControlBar)
            make.leading.equalTo(pictureButton.snp.trailing).offset(40)
            make.size.equalTo(30)
        }
        
        pictureButton.snp.makeConstraints{ make in
            make.centerY.equalTo(cameraControlBar)
            make.centerX.equalToSuperview()
            make.size.equalTo(70)
        }
        
        sendButton.snp.makeConstraints{ make in
            make.center.equalTo(pictureButton)
            make.size.equalTo(40)
        }
    }
    
    fileprivate func recognizeText(image: UIImage?){
        guard let cgImage = image?.cgImage else {
            fatalError("could not get image")
        }
        
        let handler = VNImageRequestHandler(cgImage: cgImage, options: [:])
        let request = VNRecognizeTextRequest{ [weak self]request, error in
            
            guard let observations = request.results as? [VNRecognizedTextObservation],
                  error == nil else{
                return
            }
            
            let text = observations.compactMap({
                $0.topCandidates(1).first?.string
            }).joined(separator: "\n")
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                self!.drawRectanglesOnObservations(observations: observations)
                print(text)
            }
        }
        
        let revision3 = VNRecognizeTextRequestRevision3
        request.revision = revision3
        request.recognitionLevel = .accurate
        request.recognitionLanguages =  ["ko-KR"]
        request.usesLanguageCorrection = true
        
        do {
            var possibleLanguages: Array<String> = []
            possibleLanguages = try request.supportedRecognitionLanguages()
            print(possibleLanguages)
        } catch {
            print("Error getting the supported languages.")
        }
        do{
            try handler.perform([request])
        } catch {
            //            label.text = "\(error)"
            print(error)
        }
    }
    
    func drawRectanglesOnObservations(observations : [VNDetectedObjectObservation]){
           DispatchQueue.main.async {
               guard let image = self.resultImage.image
               else{
                   print("Failure in retrieving image")
                   return
               }
               let imageSize = image.size
               var imageTransform = CGAffineTransform.identity.scaledBy(x: 1, y: -1).translatedBy(x: 0, y: -imageSize.height)
               imageTransform = imageTransform.scaledBy(x: imageSize.width, y: imageSize.height)
               UIGraphicsBeginImageContextWithOptions(imageSize, true, 0)
               let graphicsContext = UIGraphicsGetCurrentContext()
               image.draw(in: CGRect(origin: .zero, size: imageSize))
               
               graphicsContext?.saveGState()
               graphicsContext?.setLineJoin(.round)
               graphicsContext?.setLineWidth(2.0)
               
               graphicsContext?.setFillColor(red: 0, green: 1, blue: 0, alpha: 0.3)
               graphicsContext?.setStrokeColor(UIColor.green.cgColor)
               
               observations.forEach { (observation) in
                   let observationBounds = observation.boundingBox.applying(imageTransform)
                   graphicsContext?.addRect(observationBounds)
               }
               
               graphicsContext?.drawPath(using: CGPathDrawingMode.fillStroke)
               graphicsContext?.restoreGState()
               
               let drawnImage = UIGraphicsGetImageFromCurrentImageContext()
               UIGraphicsEndImageContext()
               self.resultImage.image = drawnImage
           }
       }


}


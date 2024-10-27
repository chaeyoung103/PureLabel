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
    
    var isMobileAnalysis = true
    
    let navigationBar = UIView().then{
        $0.backgroundColor = .buttonBgColor
    }
    
    let backButton = UIButton().then{
        $0.setImage(UIImage(named: "sub.home"), for: .normal)
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
        $0.backgroundColor = .imgBgColor
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
        $0.contentMode = .scaleAspectFill
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
        
        showAnalysisOptionAlert()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    func showAnalysisOptionAlert() {
        // UIAlertController 생성
        let alertController = UIAlertController(title: "분석 방법 선택",
                                                message: "모바일 분석과 서버 분석 중 선택해주세요.",
                                                preferredStyle: .alert)
        
        // 모바일 분석 선택지
        let mobileAnalysisAction = UIAlertAction(title: "모바일 분석", style: .default) { _ in
            self.isMobileAnalysis = true
        }
        
        // 서버 분석 선택지
        let serverAnalysisAction = UIAlertAction(title: "서버 분석", style: .default) { _ in
            // 서버 분석을 수행하는 코드
            self.isMobileAnalysis = false
        }
        
        // UIAlertController에 액션 추가
        alertController.addAction(mobileAnalysisAction)
        alertController.addAction(serverAnalysisAction)
        
        // 알림 표시
        present(alertController, animated: true, completion: nil)
    }

    // 모바일 분석 수행 메서드
    func performMobileAnalysis() {
        // 모바일에서 분석 수행하는 코드
        print("모바일 분석을 수행합니다.")
        // 실제 모바일 분석 코드 추가
    }

    // 서버 분석 수행 메서드
    func performServerAnalysis() {
        // 서버로 요청 보내는 코드
        print("서버 분석을 수행합니다.")
        // 실제 서버 분석 코드 추가
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
        captureSession.sessionPreset = .photo
        
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
        videoPreviewLayer.videoGravity = .resizeAspectFill  // 비율을 유지하며 카메라뷰에 맞춤
        videoPreviewLayer.frame = cameraView.bounds
        cameraView.layer.addSublayer(videoPreviewLayer)
        
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
        let fixedImage = fixedOrientationImage(capturedImage!)
        
        // Handle the captured image (e.g., save to gallery, display preview, etc.)
        print("사진이 성공적으로 찍혔습니다!")
        pictureButton.isEnabled = false
        galleryButton.isHidden = true
        turnButton.isHidden = true
        sendButton.isHidden = false
        if (isMobileAnalysis){
            resultImage.image = fixedImage
            recognizeText(image:fixedImage)
        }else {
            //서버로 이미지 전달
        }
        self.view.addSubview(resultImage)
        resultImage.snp.makeConstraints{ make in
            make.top.equalTo(navigationBar.snp.bottom)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalToSuperview().offset(-180)
        }
        
    }
    
    func fixedOrientationImage(_ image: UIImage) -> UIImage {
        guard let cgImage = image.cgImage else { return image }
        
        if image.imageOrientation == .up {
            return image
        }
        
        let width = image.size.width
        let height = image.size.height
        let colorSpace = cgImage.colorSpace
        let bitmapInfo = cgImage.bitmapInfo
        
        guard let context = CGContext(
            data: nil,
            width: Int(width),
            height: Int(height),
            bitsPerComponent: cgImage.bitsPerComponent,
            bytesPerRow: 0,
            space: colorSpace!,
            bitmapInfo: bitmapInfo.rawValue
        ) else {
            return image
        }
        
        var transform: CGAffineTransform = .identity
        
        // Apply rotation based on image orientation and adjust scale to maintain aspect ratio
        switch image.imageOrientation {
        case .down, .downMirrored:
            transform = transform
                .translatedBy(x: width, y: height)
                .rotated(by: .pi)
        case .left, .leftMirrored:
            transform = transform
                .translatedBy(x: width, y: 0)
                .rotated(by: .pi / 2)
                .scaledBy(x: height / width, y: width / height)  // Scale to maintain aspect ratio
        case .right, .rightMirrored:
            transform = transform
                .translatedBy(x: 0, y: height)
                .rotated(by: -.pi / 2)
                .scaledBy(x: height / width, y: width / height)  // Scale to maintain aspect ratio
        case .up, .upMirrored:
            break
        @unknown default:
            break
        }
        
        context.concatenate(transform)
        
        switch image.imageOrientation {
        case .leftMirrored, .rightMirrored:
            context.draw(cgImage, in: CGRect(x: 0, y: 0, width: height, height: width))
        default:
            context.draw(cgImage, in: CGRect(x: 0, y: 0, width: width, height: height))
        }
        
        guard let newCGImage = context.makeImage() else { return image }
        return UIImage(cgImage: newCGImage)
    }


    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        videoPreviewLayer.frame = cameraView.bounds  // cameraView에 맞게 크기 조정
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
    
    func layout() {
        // 네비게이션 바 설정
        navigationBar.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(50)
        }
        
        // 뒤로 가기 버튼 설정
        backButton.snp.makeConstraints { make in
            make.centerY.equalTo(navigationBar)
            make.leading.equalToSuperview().offset(15)
            make.size.equalTo(24)
        }
        
        // 뒤로 가기 버튼 설정
        menuButton.snp.makeConstraints { make in
            make.centerY.equalTo(navigationBar)
            make.trailing.equalToSuperview().offset(-10)
            make.size.equalTo(24)
        }
        
        // 카메라 프리뷰를 네비게이션 바와 바텀 바 사이에 위치
        cameraView.snp.makeConstraints { make in
            make.top.equalTo(navigationBar.snp.bottom)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalTo(cameraControlBar.snp.top)
        }
        
        // 바텀 바 설정
        cameraControlBar.snp.makeConstraints { make in
            make.bottom.equalToSuperview()
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(180)
        }
        
        // 각 버튼 설정
        galleryButton.snp.makeConstraints { make in
            make.centerY.equalTo(cameraControlBar)
            make.trailing.equalTo(pictureButton.snp.leading).offset(-40)
            make.size.equalTo(30)
        }
        
        turnButton.snp.makeConstraints { make in
            make.centerY.equalTo(cameraControlBar)
            make.leading.equalTo(pictureButton.snp.trailing).offset(40)
            make.size.equalTo(30)
        }
        
        pictureButton.snp.makeConstraints { make in
            make.centerY.equalTo(cameraControlBar)
            make.centerX.equalToSuperview()
            make.size.equalTo(70)
        }
        
        sendButton.snp.makeConstraints { make in
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


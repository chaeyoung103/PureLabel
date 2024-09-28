//
//  ApiClient.swift
//  PureLabel
//
//  Created by 송채영 on 9/28/24.
//

import Alamofire

struct APIResponse<T: Codable>: Codable {
    let code: Int
    let status: Int
    let message: String
    let result: T?
}

class ApiClient {
    func login(_ viewController : LoginViewController, _ parameter: LoginInput){
        AF.request("http://172.20.10.3:9000/user/login", method: .post, parameters: parameter, encoder: JSONParameterEncoder.default, headers: nil).validate().responseDecodable(of: APIResponse<LoginModel>.self) { response in
            print("로그인 ",response)
            switch response.result {
            case .success(let result):
                print("응답 데이터: ", result)
                if result.code == 1000 {
                    print("로그인 성공", result.result ?? "")
                    viewController.showErr(isErr: false)
                    if result.result != nil {
                        UserDefaults.standard.set(result.result?.accessToken, forKey: "accessToken")
                        UserDefaults.standard.set(result.result?.refreshToken, forKey: "refreshToken")
                         let homeVC = TabBarController()
                         viewController.navigationController?.pushViewController(homeVC, animated: true)
                    }
                } else {
                    print("로그인 실패: ", result.message)
                    viewController.showErr(isErr: true)
                }
                
            case .failure(let error):
                print("네트워크 오류: ", error.localizedDescription)
            }
        }
    }
    
    func signup(_ viewController : SignupViewController2, _ parameter: SignupInput){
        AF.request("http://172.20.10.3:9000/user/signUp", method: .post, parameters: parameter, encoder: JSONParameterEncoder.default, headers: nil).validate().responseDecodable(of: APIResponse<String>.self) { response in
            switch response.result {
            case .success(let result):
                print("응답 데이터: ", result)
                if result.code == 1000 {
                    print("회원가입 성공", result.result ?? "")
                    viewController.navigationController?.pushViewController(LoginViewController(), animated: false)
                } else {
                    print("회원가입 실패: ", result.message)
                }
                
            case .failure(let error):
                print("네트워크 오류: ", error.localizedDescription)
            }
        }
    }
    
}

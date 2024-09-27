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
        AF.request("http://192.168.219.210:9000/user/login", method: .post, parameters: parameter, encoder: JSONParameterEncoder.default, headers: nil).validate().responseDecodable(of: APIResponse<LoginModel>.self) { response in
            print("로그인 ",response)
            switch response.result {
            case .success(let result):
                print("응답 데이터: ", result)
                if result.code == 1000 {
                    print("로그인 성공", result.result ?? "")
                    if let loginData = result.result {
                        // loginData 처리
                        // 예: UserDefaults.standard.set(loginData.token, forKey: "token")
                        // let homeVC = TabBarController()
                        // viewController.navigationController?.pushViewController(homeVC, animated: true)
                    }
                } else {
                    print("로그인 실패: ", result.message)
                }
                
            case .failure(let error):
                print("네트워크 오류: ", error.localizedDescription)
            }
        }
    }
    
}


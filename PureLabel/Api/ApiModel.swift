//
//  ApiModel.swift
//  PureLabel
//
//  Created by 송채영 on 9/28/24.
//

struct LoginInput : Codable {
    var id : String?
    var password : String?
}

struct LoginModel : Codable {
    var accessToken : String?
    var refreshToken : String?
}

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

struct SignupInput : Codable {
    var name : String?
    var id : String?
    var password : String?
    var gender : String?
    var skinType : String?
    var skinWorries : [String]?
}

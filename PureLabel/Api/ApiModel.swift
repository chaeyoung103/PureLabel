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

struct UserModel : Codable {
    var name : String?
    var id : String?
    var gender : Int?
    var skinType : Int?
    var skinWorries : [String]?
}

struct LoginModel : Codable {
    var accessToken : String?
    var refreshToken : String?
    var pk : Int?
}

struct SignupInput : Codable {
    var name : String?
    var id : String?
    var password : String?
    var gender : String?
    var skinType : String?
    var skinWorries : [String]?
}

struct GetRankingModel : Codable {
    var pk : Int?
    var name : String?
    var imageUrl: String?
    var grade : String?
    var skinType : String?
    var skinWorries : [String]?
    var rating : Float?
}

struct GetCosmeticDetailModel : Codable {
    var name : String?
    var brand : String?
    var price : Int?
    var imageUrl: String?
    var grade : String?
    var consmeticTypes : [String]?
    var ingredients : [String]?
    var rating : Float?
}

struct GetAnalyzeModel : Codable {
    var analyzeResult : [AnalyzeModel]?
}

struct AnalyzeModel : Codable {
    var pk : String?
    var name : String?
    var ewgGrade : EWGGrade?
}

struct EWGGrade : Codable {
    var grade : Int?
}

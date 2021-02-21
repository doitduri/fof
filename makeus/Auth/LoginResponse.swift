//
//  LoginResponse.swift
//  makeus
//
//  Created by 김두리 on 2021/02/21.
//

import Foundation

class LoginResponse: Decodable {
    
//    var userInfo: String?
//    var jwt: String?
    var isSuccess: Bool?
    var code: Int?
    var message: String?
    
    enum loginKey: String, CodingKey {
//        case userInfo
//        case jwt
        case isSuccess
        case code
        case message
    }
    
    init() {}
    
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: loginKey.self)
        
        message = try? container.decode(String.self, forKey: .message)
    }
}

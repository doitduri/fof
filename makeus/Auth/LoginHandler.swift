//
//  LoginHandler.swift
//  makeus
//
//  Created by 김두리 on 2021/02/21.
//

import Combine
import Alamofire

class LoginHandler: APIHandler {
    
    @Published var loginResponse: LoginResponse?
    @Published var isLoading = false
    
    func userLogin() {
        isLoading = true
       
    
        let param = [
//            "email": email,
//            "password": password
            "email" : "doitduri@gmail.com",
            "password" : "duriTest!123",
            "nickname" : "duri"
        ]
        
        let url = "https://test.fofapp.shop/signup"
    
        AF.request(url, method: .post, parameters: param).responseDecodable { [weak self] (response: DataResponse<LoginResponse, AFError>) in
            guard let weakSelf = self else { return }
            
            guard let response = weakSelf.handleResponse(response) as? LoginResponse else {
                weakSelf.isLoading = false
                return
            }
                            
            weakSelf.isLoading = false
            weakSelf.loginResponse = response
            
            
            print(response)
        }
    }
}

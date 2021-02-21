//
//  APIHandler.swift
//  makeus
//
//  Created by 김두리 on 2021/02/21.
//

import Alamofire
import Combine


class APIHandler{
    
    var statusCode = Int.zero
    
    func handleResponse<T: Decodable>(_ response: DataResponse<T, AFError>) -> Any? {
        switch response.result {
        case .success:
            return response.value
        case .failure:
            return nil
        }
    }
    
}

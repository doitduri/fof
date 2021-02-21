//
//  LoginViewModel.swift
//  makeus
//
//  Created by 김두리 on 2021/02/21.
//

import SwiftUI
import Combine

class LoginViewModel: ObservableObject, Identifiable {
    
    @Published var email = ""
    @Published var password = ""
    
    @Published var isLoggedIn = false
    @Published var isLoading = false
    
    @Published var shouldNavigate = false
    
    private var disposables: Set<AnyCancellable> = []
    
    var loginHandler = LoginHandler()
    
    @Published var loginUrl = ""
    
    private var isLoadingPublisher: AnyPublisher<Bool, Never> {
        loginHandler.$isLoading
            .receive(on: RunLoop.main)
            .map { $0 }
            .eraseToAnyPublisher()
    }
    
    private var isAuthenticatedPublisher: AnyPublisher<String, Never> {
        loginHandler.$loginResponse
            .receive(on: RunLoop.main)
            .map { response in
                guard let response = response else {
                    return ""
                }
                
                return response.message ?? ""
        }
        .eraseToAnyPublisher()
    }
    
    init() {
        isLoadingPublisher
            .receive(on: RunLoop.main)
            .assign(to: \.isLoading, on: self)
            .store(in: &disposables)
        
        isAuthenticatedPublisher
            .receive(on: RunLoop.main)
            .assign(to: \.loginUrl, on: self)
            .store(in: &disposables)
    }
    
    func getUsers() {
//        loginHandler.userLogin(email, password)
        loginHandler.userLogin()
    }
    
}

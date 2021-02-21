//
//  LoginView.swift
//  makeus
//
//  Created by 김두리 on 2021/02/19.
//

import SwiftUI

struct LoginView: View {
    @ObservedObject var viewModel = LoginViewModel()
    
    var loginButton: some View {
        NavigationLink(destination: StaggeredGridView(message: viewModel.loginUrl), isActive: .constant($viewModel.loginUrl.wrappedValue != "")) {
            VStack {
                Spacer()
                HStack {
                    Spacer()
                    Text("Login").foregroundColor(.white).fontWeight(.bold)
                    Spacer()
                }
                Spacer()
            }.frame(minHeight: 55.0, maxHeight: 55.0)
                .background(Color.blue)
                .cornerRadius(2.5)
                .padding(.top, 77.0)
            
        }.simultaneousGesture(TapGesture().onEnded{
            self.loginUser()
        })
    }
    
    var placeHolderTextView: some View {
        PlaceholderTextField(placeholder: Text("Email"), text: $viewModel.email)
            .padding(.top, 32.0)
    }
    
    var passwordTextView: some View {
        SecurePlaceholderTextField(placeholder: Text("Password"), text: $viewModel.password)
            .padding(.top, 32.0)
    }
    
    var titleView: some View {
        VStack(alignment: .leading) {
            Text("FoF")
                .tracking(1.0)
                .fontWeight(.bold)
        }.padding(EdgeInsets(top: 44.0, leading: .zero, bottom: .zero, trailing: .zero))
    }
    
    var body: some View {
        NavigationView {
            LoadingView(isShowing: .constant(viewModel.isLoading)) {
                VStack(alignment: .leading) {
                    self.titleView
                    self.placeHolderTextView
                    self.passwordTextView
                    self.loginButton
                }.padding(22.0)
            }
        }
    
    }
    
    
    private func loginUser() {
        viewModel.getUsers()
    }
    
}


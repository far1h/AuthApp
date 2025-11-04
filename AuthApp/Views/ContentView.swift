//
//  ContentView.swift
//  AuthApp
//
//  Created by Farih Muhammad on 04/11/2025.
//

import SwiftUI

struct ContentView: View {
    @State private var isGettingUser = false
    @StateObject private var loginVM = LoginViewModel(httpClient: HTTPClient())
        
    private var isFormValid: Bool {
        return !loginVM.username.isEmpty && !loginVM.password.isEmpty
    }
    
    
    func login() {
        Task {
            await loginVM.login()
            if loginVM.errorMessage == nil {
                print("Login succeeded")
            } else {
                print("Login failed: \(loginVM.errorMessage!)")
                return
            }
            await loginVM.getUser()
            isGettingUser = true
        }
    }
    
    var body: some View {
        Form {
            Section {
                TextField("User name", text: $loginVM.username)
                    .autocapitalization(.none)
                    .accessibilityIdentifier("usernameTextField")
                
                SecureField("Password", text: $loginVM.password)
                    .accessibilityIdentifier("passwordTextField")
                
                HStack {
                    Spacer()
                    Button {
                        if isFormValid {
                            login()
                        }
                    } label: {
                        Text("Login")
                            .accessibilityIdentifier("loginButton")
                    }.disabled(!isFormValid)
                    Spacer()
                }
            }
            if loginVM.errorMessage != nil {
                Text(loginVM.errorMessage ?? "")
                    .foregroundColor(.red)
                    .accessibilityIdentifier("errorMessageText")
            }
        }
        .sheet(isPresented: $isGettingUser) {
            Text("User: \(loginVM.getUserResponse?.username ?? "")")
                .accessibilityIdentifier("userText")
            Text("Name: \(loginVM.getUserResponse?.name ?? "")")
                .accessibilityIdentifier("nameText")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

//
//  ContentView.swift
//  AuthApp
//
//  Created by Farih Muhammad on 04/11/2025.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var loginVM = LoginViewModel(httpClient: HTTPClient())
        
    private var isFormValid: Bool {
        return !loginVM.username.isEmpty && !loginVM.password.isEmpty
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
                            Task {
                                await loginVM.login()
                            }
                        }
                    } label: {
                        Text("Login")
                            .accessibilityIdentifier("loginButton")
                    }.disabled(!isFormValid)
                    Spacer()
                }
            }
            Section {
                HStack {
                    Spacer()
                    Button {
                        Task {
                            await loginVM.getUser()
                        }
                    } label: {
                        Text("Get User")
                            .accessibilityIdentifier("getUserButton")
                    }
                    Spacer()
                }
            }
            Section {
                HStack {
                    Spacer()
                    Button {
                        loginVM.deleteToken()
                    } label: {
                        Text("Delete Token")
                            .foregroundColor(.red)
                            .accessibilityIdentifier("deleteTokenButton")
                    }
                    Spacer()
                }
            }

            
            if loginVM.errorMessage != nil {
                Text(loginVM.errorMessage ?? "")
                    .foregroundColor(.red)
                    .accessibilityIdentifier("errorMessageText")
            }
        }
        .sheet(isPresented: $loginVM.isGettingUser) {
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

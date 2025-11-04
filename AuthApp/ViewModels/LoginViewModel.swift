//
//  LoginViewModel.swift
//  AuthApp
//
//  Created by Farih Muhammad on 04/11/2025.
//

import Foundation

// ViewModels defined as class and conforming to ObservableObject for SwiftUI compatibility
@MainActor
class LoginViewModel: ObservableObject {
    @Published var username: String = ""
    @Published var password: String = ""
    @Published var getUserResponse: GetUserResponse?
    @Published var errorMessage: String?
    
    private var httpClient: HTTPClient
    
    init(httpClient: HTTPClient) {
        self.httpClient = httpClient
    }
    
    // catch errors from async functions in ViewModel
    func login() async {
        errorMessage = nil
        if username.isEmpty || password.isEmpty {
            return
        }
        
        do {
            let loginResponse = try await httpClient.login(username: username, password: password)
            Keychain.set(loginResponse.accessToken, forKey: "jwttoken")
            print("Login successful, token saved to keychain.")
        } catch {
            errorMessage = "Login failed: \(error)"
        }
    }
    
    func getUser() async {
        do {
            let userResponse = try await httpClient.getUser()
            self.getUserResponse = userResponse
        } catch {
            errorMessage = "Get user failed: \(error)"
        }
    }
    
}

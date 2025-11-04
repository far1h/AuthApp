//
//  HTTPClient.swift
//  AuthApp
//
//  Created by Farih Muhammad on 04/11/2025.
//

import Foundation

enum NetworkError: Error {
    case badURL
    case badRequest
    case decodingError
}

struct HTTPClient {
    
    func login(username: String, password: String) async throws -> LoginResponse {
        
        let body = ["username": username, "password": password]
        
        guard let url = URL(string: "http://localhost:8080/api/auth/login") else {
            throw NetworkError.badURL
        }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "POST"
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.httpBody = try? JSONEncoder().encode(body)
        
        let (data, response) =  try await URLSession.shared.data(for: urlRequest)
        
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw NetworkError.badRequest
        }
        
        guard let loginResponse = try? JSONDecoder().decode(LoginResponse.self, from: data) else {
            throw NetworkError.decodingError
        }
        
        return loginResponse
    }
    
    
    func getUser() async throws -> GetUserResponse {
        
        guard let url = URL(string: "http://localhost:8080/api/auth/me") else {
            throw NetworkError.badURL
        }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "GET"
        
        if let token = Keychain.get("jwttoken") as String? {
            urlRequest.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
            print("Using token: \(token)")
        }
        
        let (data, response) =  try await URLSession.shared.data(for: urlRequest)
        
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw NetworkError.badRequest
        }
        
        guard let getUserResponse = try? JSONDecoder().decode(GetUserResponse.self, from: data) else {
            throw NetworkError.decodingError
        }
        
        return getUserResponse
    }
}

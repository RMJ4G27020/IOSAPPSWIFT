//
//  NetworkService.swift
//  CopilotGuideApp
//
//  Created with GitHub Copilot assistance
//  Copyright © 2025 CopilotGuide. All rights reserved.
//

import Foundation
import Combine

// MARK: - Network Error Types
enum NetworkError: Error, LocalizedError {
    case invalidURL
    case noData
    case decodingError(Error)
    case networkError(Error)
    case serverError(Int)
    
    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "URL inválida"
        case .noData:
            return "No se recibieron datos"
        case .decodingError(let error):
            return "Error al procesar datos: \(error.localizedDescription)"
        case .networkError(let error):
            return "Error de conexión: \(error.localizedDescription)"
        case .serverError(let code):
            return "Error del servidor: \(code)"
        }
    }
}

// MARK: - Network Service
class NetworkService {
    static let shared = NetworkService()
    
    private let baseURL = "https://jsonplaceholder.typicode.com"
    private let session: URLSession
    
    private init() {
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 30
        configuration.timeoutIntervalForResource = 60
        self.session = URLSession(configuration: configuration)
    }
    
    // MARK: - Generic Request Method
    private func fetch<T: Codable>(endpoint: String, type: T.Type) async throws -> T {
        guard let url = URL(string: baseURL + endpoint) else {
            throw NetworkError.invalidURL
        }
        
        do {
            let (data, response) = try await session.data(from: url)
            
            guard let httpResponse = response as? HTTPURLResponse else {
                throw NetworkError.networkError(URLError(.badServerResponse))
            }
            
            guard 200...299 ~= httpResponse.statusCode else {
                throw NetworkError.serverError(httpResponse.statusCode)
            }
            
            guard !data.isEmpty else {
                throw NetworkError.noData
            }
            
            let decoder = JSONDecoder()
            let result = try decoder.decode(type, from: data)
            return result
            
        } catch let decodingError as DecodingError {
            throw NetworkError.decodingError(decodingError)
        } catch let networkError as NetworkError {
            throw networkError
        } catch {
            throw NetworkError.networkError(error)
        }
    }
    
    // MARK: - API Methods
    func fetchUsers() async throws -> [APIUser] {
        return try await fetch(endpoint: "/users", type: [APIUser].self)
    }
    
    func fetchPosts() async throws -> [Post] {
        return try await fetch(endpoint: "/posts", type: [Post].self)
    }
    
    func fetchPhotos() async throws -> [Photo] {
        return try await fetch(endpoint: "/photos", type: [Photo].self)
    }
    
    func fetchUser(id: Int) async throws -> APIUser {
        return try await fetch(endpoint: "/users/\(id)", type: APIUser.self)
    }
    
    func fetchPostsByUser(userId: Int) async throws -> [Post] {
        return try await fetch(endpoint: "/posts?userId=\(userId)", type: [Post].self)
    }
}

// MARK: - API Models
struct APIUser: Codable, Identifiable {
    let id: Int
    let name: String
    let username: String
    let email: String
    let phone: String
    let website: String
    let company: Company
    let address: Address
    
    struct Company: Codable {
        let name: String
        let catchPhrase: String
        let bs: String
    }
    
    struct Address: Codable {
        let street: String
        let suite: String
        let city: String
        let zipcode: String
        let geo: Geo
        
        struct Geo: Codable {
            let lat: String
            let lng: String
        }
    }
}

struct Photo: Codable, Identifiable {
    let id: Int
    let albumId: Int
    let title: String
    let url: String
    let thumbnailUrl: String
}

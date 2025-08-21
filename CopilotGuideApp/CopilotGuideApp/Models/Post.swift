//
//  Post.swift
//  CopilotGuideApp
//
//  Created with GitHub Copilot assistance
//  Copyright © 2025 CopilotGuide. All rights reserved.
//

import Foundation

// MARK: - Post Model
struct Post: Identifiable, Codable {
    let id: Int
    let userId: Int
    let title: String
    let body: String
}

// MARK: - Comment Model
struct Comment: Identifiable, Codable {
    let id: Int
    let postId: Int
    let name: String
    let email: String
    let body: String
}

// MARK: - Photo Model (for Image Gallery)
struct Photo: Identifiable, Codable {
    let id: Int
    let albumId: Int
    let title: String
    let url: String
    let thumbnailUrl: String
}

// MARK: - Album Model
struct Album: Identifiable, Codable {
    let id: Int
    let userId: Int
    let title: String
}

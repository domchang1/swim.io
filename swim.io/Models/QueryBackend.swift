//
//  QueryBackend.swift
//  swim.io
//
//  Created by Dominic Chang on 3/15/25.
//

import Foundation

private let baseURL = "http://localhost:5000"

struct ChatResponse: Codable {
    let response: String
}

func query(message: String) async throws -> String {
    guard let url = URL(string: "\(baseURL)/chat") else {
        fatalError("Url invalid")
    }
    var request = URLRequest(url: url)
    request.httpMethod = "POST"
    let (data, response) = try await URLSession.shared.data(for: request)
        
    guard let httpResponse = response as? HTTPURLResponse,
        httpResponse.statusCode >= 200, httpResponse.statusCode <= 299 else {
            fatalError("Error getting chat response")
    }
    let decoder = JSONDecoder()
    let res = try decoder.decode(ChatResponse.self, from: data)
    print("Returned Chat Message: \(res)")
    return res.response
}

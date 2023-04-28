//
//  LockController.swift
//  UnlockIT
//
//  Created by Jonas Stenhold  on 27/04/2023.
//

import Foundation

func activateLock(id: String) async throws -> String {
    guard let url = URL(string: "http://139.144.66.167:8080/api/activate?id=\(id)") else {
        throw URLError(.badURL)
    }

    let request = URLRequest(url: url)

    let session = URLSession.shared

    let (data, response) = try await session.data(for: request)

    guard let httpResponse = response as? HTTPURLResponse else {
        throw URLError(.badServerResponse)
    }

    guard (200...299).contains(httpResponse.statusCode) else {
        throw URLError(.badServerResponse)
    }

    guard let responseString = String(data: data, encoding: .utf8) else {
        throw URLError(.badServerResponse)
    }

    return responseString
}

func initChallenge(id: String) async throws -> String {
    guard let url = URL(string: "http://139.144.66.167:8080/api/start?id=\(id)") else {
        throw URLError(.badURL)
    }

    let request = URLRequest(url: url)

    let session = URLSession.shared

    let (data, response) = try await session.data(for: request)

    guard let httpResponse = response as? HTTPURLResponse else {
        throw URLError(.badServerResponse)
    }

    guard (200...299).contains(httpResponse.statusCode) else {
        throw URLError(.badServerResponse)
    }

    guard let responseString = String(data: data, encoding: .utf8) else {
        throw URLError(.badServerResponse)
    }

    return responseString
}

func respondChallenge(id: String) async throws -> String {
    guard let url = URL(string: "http://139.144.66.167:8080/api/respond?id=\(id)") else {
        throw URLError(.badURL)
    }

    let request = URLRequest(url: url)

    let session = URLSession.shared

    let (data, response) = try await session.data(for: request)
    
    guard let httpResponse = response as? HTTPURLResponse else {
        throw URLError(.badServerResponse)
    }

    guard (200...299).contains(httpResponse.statusCode) else {
        throw URLError(.badServerResponse)
    }

    guard let responseString = String(data: data, encoding: .utf8) else {
        throw URLError(.badServerResponse)
    }

    return responseString
}


//
//  GeminiService.swift
//  PetCare+
//
//  Created on 26.10.2025.
//

import Foundation

// MARK: - Gemini Response Models

struct GeminiResponse: Codable {
    let candidates: [Candidate]

    struct Candidate: Codable {
        let content: Content

        struct Content: Codable {
            let parts: [Part]

            struct Part: Codable {
                let text: String
            }
        }
    }

    var text: String? {
        candidates.first?.content.parts.first?.text
    }
}

struct GeminiRequest: Codable {
    let contents: [Content]

    struct Content: Codable {
        let parts: [Part]

        struct Part: Codable {
            let text: String
        }
    }
}

// MARK: - Gemini Service

class GeminiService {
    static let shared = GeminiService()

    private let apiKey = "AIzaSyBXpfl2jb46q8fJgUHYH1rrlGTaOliYJxU"
    private let baseURL = "https://generativelanguage.googleapis.com/v1beta/models/gemini-pro:generateContent"

    private init() {}

    /// Gemini AI'dan yanıt al
    func generateResponse(prompt: String) async throws -> String {
        var urlComponents = URLComponents(string: baseURL)
        urlComponents?.queryItems = [URLQueryItem(name: "key", value: apiKey)]

        guard let url = urlComponents?.url else {
            throw GeminiError.invalidURL
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        let geminiRequest = GeminiRequest(
            contents: [
                GeminiRequest.Content(
                    parts: [GeminiRequest.Content.Part(text: prompt)]
                )
            ]
        )

        request.httpBody = try JSONEncoder().encode(geminiRequest)

        let (data, response) = try await URLSession.shared.data(for: request)

        guard let httpResponse = response as? HTTPURLResponse else {
            throw GeminiError.invalidResponse
        }

        guard httpResponse.statusCode == 200 else {
            throw GeminiError.apiError(statusCode: httpResponse.statusCode)
        }

        let geminiResponse = try JSONDecoder().decode(GeminiResponse.self, from: data)

        guard let text = geminiResponse.text else {
            throw GeminiError.noResponse
        }

        return text
    }

    /// Pet davranış analizi için özel prompt
    func analyzePetBehavior(
        petName: String,
        species: String,
        age: String,
        behavior: String
    ) async throws -> String {
        let prompt = """
        Sen bir veteriner ve evcil hayvan davranış uzmanısın. Türkçe cevap ver.

        Evcil Hayvan: \(petName)
        Tür: \(species)
        Yaş: \(age)

        Davranış/Soru: \(behavior)

        Lütfen bu davranış hakkında profesyonel bir analiz yap ve önerilerde bulun.
        Yanıtını şu başlıklar altında ver:
        1. Davranış Analizi
        2. Olası Sebepler
        3. Öneriler
        4. Ne Zaman Veterinere Gidilmeli

        Yanıtını dostça ve anlaşılır bir dille ver.
        """

        return try await generateResponse(prompt: prompt)
    }

    /// Genel pet soruları için
    func askAboutPet(
        petName: String,
        species: String,
        question: String
    ) async throws -> String {
        let prompt = """
        Sen bir veteriner ve evcil hayvan bakım uzmanısın. Türkçe cevap ver.

        Evcil Hayvan: \(petName)
        Tür: \(species)

        Soru: \(question)

        Lütfen bu soruya detaylı ve profesyonel bir şekilde cevap ver.
        Yanıtını dostça ve anlaşılır bir dille ver.
        """

        return try await generateResponse(prompt: prompt)
    }

    /// Sağlık önerileri
    func getHealthAdvice(
        petName: String,
        species: String,
        age: String,
        weight: String
    ) async throws -> String {
        let prompt = """
        Sen bir veteriner ve evcil hayvan sağlık uzmanısın. Türkçe cevap ver.

        Evcil Hayvan: \(petName)
        Tür: \(species)
        Yaş: \(age)
        Kilo: \(weight)

        Bu evcil hayvan için genel sağlık önerileri ver:
        1. Beslenme
        2. Egzersiz
        3. Rutin Kontroller
        4. Dikkat Edilmesi Gerekenler

        Yanıtını dostça ve pratik bir şekilde ver.
        """

        return try await generateResponse(prompt: prompt)
    }
}

// MARK: - Gemini Error

enum GeminiError: Error, LocalizedError {
    case invalidURL
    case invalidResponse
    case apiError(statusCode: Int)
    case noResponse
    case encodingError

    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "Geçersiz URL"
        case .invalidResponse:
            return "Geçersiz yanıt"
        case .apiError(let statusCode):
            return "API hatası (Kod: \(statusCode))"
        case .noResponse:
            return "Yanıt alınamadı"
        case .encodingError:
            return "Veri kodlama hatası"
        }
    }
}

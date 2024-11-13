//
//  MovieAPIService.swift
//  flixpedia-swiftui
//
//  Created by Zin Lin Phyo on 13/11/24.
//

import Combine
import Foundation

class MovieAPIService {
    private let apiKey = ""
    private let baseURL = "https://api.themoviedb.org/3"
    
    func fetchMovies(endpoint: String) -> AnyPublisher<[Movie], Error> {
        guard let url = URL(string: "\(baseURL)/movie/\(endpoint)?api_key=\(apiKey)") else {
            return Fail(error: URLError(.badURL)).eraseToAnyPublisher()
        }

        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase

        return URLSession.shared.dataTaskPublisher(for: url)
            .tryMap { data, response -> Data in
                guard let httpResponse = response as? HTTPURLResponse,
                      httpResponse.statusCode == 200 else {
                    throw URLError(.badServerResponse)
                }
                if let jsonString = String(data: data, encoding: .utf8) {
                    print("Raw JSON Response:", jsonString)
                }
                return data
            }
            .decode(type: MovieResponse.self, decoder: decoder)
            .map { response -> [Movie] in
                if let firstMovie = response.results.first {
                    print("Decoded first movie:", firstMovie.debugDescription())
                }
                return response.results
            }
            .eraseToAnyPublisher()
    }
}

struct MovieResponse: Decodable {
    let results: [Movie]
}


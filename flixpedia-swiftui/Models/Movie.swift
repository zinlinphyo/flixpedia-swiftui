//
//  Movie.swift
//  flixpedia-swiftui
//
//  Created by Zin Lin Phyo on 13/11/24.
//

import RealmSwift

class Movie: Object, Identifiable, Decodable {
    @Persisted(primaryKey: true) var id: Int
    @Persisted var title: String
    @Persisted var overview: String
    @Persisted var posterPath: String?
    @Persisted var isFavorite: Bool = false
    @Persisted var releaseDate: String? = nil
    @Persisted var voteAverage: Double = 0.0
    @Persisted var voteCount: Int = 0
    @Persisted var backdropPath: String? = nil
    @Persisted var movieType: String = "" // "upcoming" or "popular"

    private enum CodingKeys: String, CodingKey {
        case id, title, overview
        case posterPath = "poster_path"
        case releaseDate = "release_date"
        case voteAverage = "vote_average"
        case voteCount = "vote_count"
        case backdropPath = "backdrop_path"
    }

    required convenience init(from decoder: Decoder) throws {
        self.init()
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        id = try container.decode(Int.self, forKey: .id)
        title = try container.decode(String.self, forKey: .title)
        overview = try container.decode(String.self, forKey: .overview)
        posterPath = try container.decodeIfPresent(String.self, forKey: .posterPath)
        releaseDate = try container.decodeIfPresent(String.self, forKey: .releaseDate)
        voteAverage = try container.decodeIfPresent(Double.self, forKey: .voteAverage) ?? 0.0
        voteCount = try container.decodeIfPresent(Int.self, forKey: .voteCount) ?? 0
        backdropPath = try container.decodeIfPresent(String.self, forKey: .backdropPath)
    }

    override class func primaryKey() -> String? {
        return "id"
    }

    func debugDescription() -> String {
        return """
        Movie:
        - ID: \(id)
        - Title: \(title)
        - Poster Path: \(posterPath ?? "nil")
        - Vote Average: \(voteAverage)
        - Vote Count: \(voteCount)
        - Backdrop Path: \(backdropPath ?? "nil")
        """
    }
}

extension Movie {
    static func printDecodingError(_ error: Error) {
        if let decodingError = error as? DecodingError {
            switch decodingError {
            case .keyNotFound(let key, let context):
                print("Key '\(key)' not found:", context.debugDescription)
            case .valueNotFound(let value, let context):
                print("Value '\(value)' not found:", context.debugDescription)
            case .typeMismatch(let type, let context):
                print("Type '\(type)' mismatch:", context.debugDescription)
            case .dataCorrupted(let context):
                print("Data corrupted:", context.debugDescription)
            @unknown default:
                print("Unknown decoding error:", decodingError)
            }
        }
    }
}

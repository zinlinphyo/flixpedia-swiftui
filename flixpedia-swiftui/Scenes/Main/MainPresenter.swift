//
//  MainPresenter.swift
//  flixpedia-swiftui
//
//  Created by Zin Lin Phyo on 13/11/24.
//

class MainPresenter {
    func presentMovies(_ movies: [Movie]) -> [MovieViewModel] {
        movies.map { MovieViewModel(movie: $0) }
    }
}

struct MovieViewModel: Identifiable {
    let id: Int
    let title: String
    let overview: String
    let posterPath: String?
    var isFavorite: Bool
    let releaseDate: String
    let voteAverage: Double
    let voteCount: Int
    
    init(movie: Movie) {
        self.id = movie.id
        self.title = movie.title
        self.overview = movie.overview
        self.posterPath = movie.posterPath
        self.isFavorite = movie.isFavorite
        self.releaseDate = movie.releaseDate ?? ""
        self.voteAverage = movie.voteAverage
        self.voteCount = movie.voteCount
    }
}

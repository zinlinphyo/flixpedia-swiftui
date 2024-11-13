//
//  MainInteractor.swift
//  flixpedia-swiftui
//
//  Created by Zin Lin Phyo on 13/11/24.
//

import Combine
import RealmSwift

class MainInteractor {
    private let apiService: MovieAPIService
    private var cancellables = Set<AnyCancellable>()
    private let realm = try! Realm()

    init(apiService: MovieAPIService) {
        self.apiService = apiService
    }

    func fetchUpcomingMovies() -> AnyPublisher<[Movie], Error> {
        apiService.fetchMovies(endpoint: "upcoming")
            .handleEvents(receiveOutput: { [weak self] movies in
                self?.saveMoviesToRealm(movies, type: "upcoming")
            })
            .eraseToAnyPublisher()
    }

    func fetchPopularMovies() -> AnyPublisher<[Movie], Error> {
        apiService.fetchMovies(endpoint: "popular")
            .handleEvents(receiveOutput: { [weak self] movies in
                self?.saveMoviesToRealm(movies, type: "popular")
            })
            .eraseToAnyPublisher()
    }

    private func saveMoviesToRealm(_ movies: [Movie], type: String) {
        DispatchQueue.main.async { [weak self] in
            do {
                guard let self = self else { return }
                try self.realm.write {
                    movies.forEach { movie in
                        movie.movieType = type
                        self.realm.add(movie, update: .modified)
                    }
                }
            } catch {
                print("Error saving movies to Realm: \(error)")
            }
        }
    }
    
    func updateFavoriteStatus(movieId: Int, isFavorite: Bool) {
        DispatchQueue.main.async {
            do {
                let realm = try Realm()
                if let movieToUpdate = realm.object(ofType: Movie.self, forPrimaryKey: movieId) {
                    try realm.write {
                        movieToUpdate.isFavorite = isFavorite
                    }
                }
            } catch {
                print("Error updating favorite status in Realm: \(error)")
            }
        }
    }

    func getCachedMovies(type: String) -> [Movie] {
        return Array(realm.objects(Movie.self).filter("movieType == %@", type))
    }
}


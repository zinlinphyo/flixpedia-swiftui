//
//  MainViewModel.swift
//  flixpedia-swiftui
//
//  Created by Zin Lin Phyo on 13/11/24.
//

import Combine
import SwiftUI

import Combine
import SwiftUI

class MainViewModel: ObservableObject {
    @Published var upcomingMovies: [MovieViewModel] = []
    @Published var popularMovies: [MovieViewModel] = []
    @Published var isLoading: Bool = false
    @Published var hasError: Bool = false
    @Published var errorMessage: String = ""

    private let interactor: MainInteractor
    private var cancellables = Set<AnyCancellable>()

    init(interactor: MainInteractor) {
        self.interactor = interactor
    }

    func loadMovies() {
        isLoading = true
        loadCachedMovies() // Load cached movies first

        let upcomingPublisher = interactor.fetchUpcomingMovies()
        let popularPublisher = interactor.fetchPopularMovies()

        Publishers.Zip(upcomingPublisher, popularPublisher)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { [weak self] completion in
                self?.isLoading = false
                switch completion {
                case .failure(let error):
                    self?.hasError = true
                    self?.errorMessage = error.localizedDescription
                case .finished:
                    break
                }
            }, receiveValue: { [weak self] upcomingMovies, popularMovies in
                self?.upcomingMovies = upcomingMovies.map { MovieViewModel(movie: $0) }
                self?.popularMovies = popularMovies.map { MovieViewModel(movie: $0) }
                // Print the loaded movies list for debugging
                print("Loaded Upcoming Movies: \(self?.upcomingMovies.map { $0.title } ?? [])")
                print("Loaded Popular Movies: \(self?.popularMovies.map { $0.title } ?? [])")
            })
            .store(in: &cancellables)
    }

    func loadCachedMovies() {
        let cachedUpcomingMovies = interactor.getCachedMovies(type: "upcoming")
        let cachedPopularMovies = interactor.getCachedMovies(type: "popular")
        upcomingMovies = cachedUpcomingMovies.map { MovieViewModel(movie: $0) }
        popularMovies = cachedPopularMovies.map { MovieViewModel(movie: $0) }
        
        print("Cached Upcoming Movies: \(upcomingMovies.map { $0.title })")
        print("Cached Popular Movies: \(popularMovies.map { $0.title })")
    }

    func refreshMovies() {
        loadMovies()
    }

    func toggleFavoriteStatus(for movie: MovieViewModel) {
        if let index = upcomingMovies.firstIndex(where: { $0.id == movie.id }) {
            upcomingMovies[index].isFavorite.toggle()
        } else if let index = popularMovies.firstIndex(where: { $0.id == movie.id }) {
            popularMovies[index].isFavorite.toggle()
        }
        
        interactor.updateFavoriteStatus(movieId: movie.id, isFavorite: movie.isFavorite)
    }
}

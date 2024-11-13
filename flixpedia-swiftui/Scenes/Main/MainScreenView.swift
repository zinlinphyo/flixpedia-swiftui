//
//  MainScreenView.swift
//  flixpedia-swiftui
//
//  Created by Zin Lin Phyo on 13/11/24.
//

import SwiftUI

struct MainScreenView: View {
    @StateObject private var viewModel: MainViewModel

    init(viewModel: MainViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    var body: some View {
        NavigationView {
            VStack {
                if viewModel.isLoading {
                    ProgressView("Loading movies...")
                        .padding()
                } else if viewModel.hasError {
                    VStack {
                        Text("Failed to load movies. Please check your network connection.")
                            .multilineTextAlignment(.center)
                            .padding()

                        Button(action: {
                            viewModel.loadMovies()
                        }) {
                            Text("Retry")
                                .padding()
                                .background(Color.blue)
                                .foregroundColor(.white)
                                .cornerRadius(8)
                        }
                    }
                    .padding()
                } else {
                    ScrollView {
                        VStack(alignment: .leading, spacing: 16) {
                            sectionView(title: "Upcoming Movies", movies: viewModel.upcomingMovies)
                            sectionView(title: "Popular Movies", movies: viewModel.popularMovies)
                        }
                    }
                    .refreshable {
                        viewModel.refreshMovies()
                    }
                }
            }
            .alert(isPresented: $viewModel.hasError) {
                Alert(title: Text("Error"), message: Text(viewModel.errorMessage), dismissButton: .default(Text("OK")))
            }
            .onAppear {
                viewModel.loadMovies()
            }
            .navigationTitle("Movies")
        }
    }

    @ViewBuilder
    private func sectionView(title: String, movies: [MovieViewModel]) -> some View {
        VStack(alignment: .leading) {
            Text(title)
                .font(.title)
                .padding(.horizontal)

            ScrollView(.horizontal) {
                LazyHStack {
                    ForEach(movies) { movie in
                        NavigationLink(destination: MovieDetailView(viewModel: viewModel, movie: movie)) {
                            MovieCardView(movie: movie)
                        }
                    }
                }
                .padding(.horizontal)
            }
        }
    }
}

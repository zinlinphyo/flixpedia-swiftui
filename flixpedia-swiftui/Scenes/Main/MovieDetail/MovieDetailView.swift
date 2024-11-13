//
//  MovieDetailView.swift
//  flixpedia-swiftui
//
//  Created by Zin Lin Phyo on 13/11/24.
//

import SwiftUI

struct MovieDetailView: View {
    @ObservedObject var viewModel: MainViewModel
    @State var movie: MovieViewModel

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            moviePoster
            movieDetails
            favoriteButton
            Spacer()
        }
        .padding()
        .navigationTitle(movie.title)
        .navigationBarTitleDisplayMode(.inline)
    }

    // MARK: - Subviews
    private var moviePoster: some View {
        VStack {
            if let posterPath = movie.posterPath,
               let url = URL(string: "https://image.tmdb.org/t/p/w500\(posterPath)") {
                AsyncImage(url: url) { image in
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                } placeholder: {
                    ProgressView()
                }
                .frame(maxWidth: .infinity)
            }
        }
    }

    private var movieDetails: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(movie.title)
                .font(.largeTitle)
                .fontWeight(.bold)

            Text("Release Date: \(movie.releaseDate)")
                .font(.subheadline)
                .foregroundColor(.gray)

            Text("Rating: \(String(format: "%.1f", movie.voteAverage)) (\(movie.voteCount) votes)")
                .font(.subheadline)

            Text(movie.overview)
                .font(.body)
                .padding(.top, 8)
        }
    }

    private var favoriteButton: some View {
        Button(action: {
            movie.isFavorite.toggle()
            viewModel.toggleFavoriteStatus(for: movie)
        }) {
            HStack {
                Image(systemName: movie.isFavorite ? "heart.fill" : "heart")
                    .foregroundColor(.red)
                Text(movie.isFavorite ? "Remove from Favorites" : "Add to Favorites")
                    .foregroundColor(.primary)
            }
            .padding()
            .background(Color.gray.opacity(0.2))
            .cornerRadius(8)
        }
    }
}


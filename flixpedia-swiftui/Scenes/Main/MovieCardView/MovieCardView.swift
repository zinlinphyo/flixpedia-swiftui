//
//  MovieCardView.swift
//  flixpedia-swiftui
//
//  Created by Zin Lin Phyo on 13/11/24.
//

import SwiftUI

struct MovieCardView: View {
    let movie: MovieViewModel

    var body: some View {
        VStack {
            if let posterPath = movie.posterPath, let url = URL(string: "https://image.tmdb.org/t/p/w500\(posterPath)") {
                AsyncImage(url: url) { image in
                    image.resizable()
                } placeholder: {
                    ProgressView()
                }
                .frame(width: 150, height: 150)
                .cornerRadius(8)
            }

            Text(movie.title)
                .font(.headline)
                .lineLimit(1)
                .frame(width: 150)
        }
    }
}

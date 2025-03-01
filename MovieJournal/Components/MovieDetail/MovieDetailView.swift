//
//  MovieDetailView.swift
//  MovieJournal
//
//  Created by Dylan on 25/02/2025.
//

import SwiftUI

struct MovieDetailView: View {
    var movie: Movie
    @State private var isInWatchlist: Bool = false

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                MoviePoster(
                    movie: movie,
                    posterWidth: 300,
                    posterHeight: 450,
                    cornerRadius: 8
                )

                Text(movie.title)
                    .font(.largeTitle)
                    .fontWeight(.bold)

                if let year = movie.releaseDate.components(separatedBy: "-").first {
                    Text(year)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }

           
                HStack {
                    Image(systemName: "star.fill")
                        .foregroundColor(.yellow)
                    Text("\(String(format: "%.1f", movie.voteAverage))/10")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }

                Text(movie.overview)
                    .font(.body)
                    .lineLimit(nil)
                    .fixedSize(horizontal: false, vertical: true)

                
                Button(action: {
                    isInWatchlist.toggle()
                    if isInWatchlist {
                        MovieStorage.shared.saveMovie(movie, watched: false)
                    } else {
                        if let movieEntity = MovieStorage.shared.fetchMovies().first(where: { $0.id == movie.id }) {
                            MovieStorage.shared.deleteMovie(movieEntity)
                        }
                    }
                }) {
                    Text(isInWatchlist ? "Remove from Watchlist" : "Add to Watchlist")
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(isInWatchlist ? Color.red : Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
            

                if isInWatchlist {
                    ReviewEditorView(movie: movie)
                }
            }
            .padding()
        }
        .navigationTitle(movie.title)
        .onAppear {
            if MovieStorage.shared.fetchMovies().first(where: { $0.id == movie.id }) != nil {
                isInWatchlist = true
            }
        }
    }
}

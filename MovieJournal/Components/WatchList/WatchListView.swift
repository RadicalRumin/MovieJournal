//
//  WatchListView.swift
//  MovieJournal
//
//  Created by Dylan on 01/03/2025.
//

import SwiftUI
import CoreData

struct WatchlistView: View {
    @State private var movies: [Movie] = []

    var body: some View {
        NavigationView {
            VStack {
                if movies.isEmpty {
                    Text("Your watchlist is empty.")
                        .font(.headline)
                        .foregroundColor(.secondary)
                        .padding()
                } else {
                    List(movies) { movie in
                        NavigationLink(destination: MovieDetailView(movie: movie)) {
                            MovieRowView(movie: movie)
                        }
                    }
                }
            }
            .navigationTitle("Watchlist")
            .onAppear {
                fetchMovies()
            }
        }
    }

    private func fetchMovies() {
        let movieEntities = MovieStorage.shared.fetchMovies()
        movies = movieEntities.map { movieEntity in
            Movie(
                id: Int(movieEntity.id),
                title: movieEntity.title ?? "Unknown Title",
                overview: movieEntity.overview ?? "",
                posterPath: movieEntity.posterPath,
                releaseDate: movieEntity.releaseDate ?? "",
                voteAverage: movieEntity.voteAverage,
                voteCount: Int(movieEntity.voteCount),
                adult: movieEntity.adult,
                backdropPath: movieEntity.backdropPath,
                genreIds: movieEntity.genreIds,
                originalLanguage: movieEntity.originalLanguage ?? "",
                originalTitle: movieEntity.originalTitle ?? "",
                popularity: movieEntity.popularity,
                video: movieEntity.video
            )
        }
    }
}

#Preview {
    WatchlistView()
}

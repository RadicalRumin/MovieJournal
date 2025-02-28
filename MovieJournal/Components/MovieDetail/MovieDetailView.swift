//
//  MovieDetailView.swift
//  MovieJournal
//
//  Created by Dylan on 25/02/2025.
//

import SwiftUI

struct MovieDetailView: View {
    var movie: Movie
    var isFromSearch: Bool
    @State private var isInWatchlist: Bool = false
    @State private var isWatched: Bool = false
    @State private var userRating: Int16 = 0
    @State private var notes: String = ""

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

                if isFromSearch {
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
                }

                if !isFromSearch {
                    Toggle(isOn: $isWatched) {
                        Text("Watched")
                            .font(.headline)
                    }
                    .onChange(of: isWatched) { newValue in
                        if let movieEntity = MovieStorage.shared.fetchMovies().first(where: { $0.id == movie.id }) {
                            MovieStorage.shared.updateMovie(movieEntity, watched: newValue)
                        }
                    }

                    // User rating (1-5 stars)
                    RatingView(rating: $userRating, starSize: 24)
                        .onChange(of: userRating) { newValue in
                            if let movieEntity = MovieStorage.shared.fetchMovies().first(where: { $0.id == movie.id }) {
                                MovieStorage.shared.updateMovie(movieEntity, rating: newValue)
                            }
                        }

                    // Notes
                    TextField("Add notes...", text: $notes)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .onChange(of: notes) { newValue in
                            if let movieEntity = MovieStorage.shared.fetchMovies().first(where: { $0.id == movie.id }) {
                                MovieStorage.shared.updateMovie(movieEntity, notes: newValue)
                            }
                        }
                }
            }
            .padding()
        }
        .navigationTitle(movie.title)
        .onAppear {
            // Check if the movie is in the watchlist or watched list
            if let movieEntity = MovieStorage.shared.fetchMovies().first(where: { $0.id == movie.id }) {
                isInWatchlist = true
                isWatched = movieEntity.watched
                userRating = movieEntity.rating
                notes = movieEntity.notes ?? ""
            }
        }
    }
}

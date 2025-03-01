//
//  ReviewEditorView.swift
//  MovieJournal
//
//  Created by Dylan on 25/02/2025.
//

import SwiftUI

struct ReviewEditorView: View {
    var movie: Movie
    @State private var isWatched: Bool = false
    @State private var userRating: Int16 = 0
    @State private var notes: String = ""
    
    
    var body: some View {
        VStack(){
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
        .onAppear() {
            if let movieEntity = MovieStorage.shared.fetchMovies().first(where: { $0.id == movie.id }) {
                isWatched = movieEntity.watched
                userRating = movieEntity.rating
                notes = movieEntity.notes ?? ""
            }
        }
    }
    
    
}



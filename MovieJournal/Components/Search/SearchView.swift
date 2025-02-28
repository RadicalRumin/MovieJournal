//
//  SearchView.swift
//  MovieJournal
//
//  Created by Dylan on 25/02/2025.
//

import SwiftUI
import Combine

struct SearchView: View {
    @State private var searchQuery = ""
    @State private var searchResults: [Movie] = []
    @State private var cancellables = Set<AnyCancellable>()

    var body: some View {
        NavigationView {
            VStack {
                TextField("Search for movies...", text: $searchQuery)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                    .onChange(of: searchQuery) { newQuery in
                        searchMovies(query: newQuery)
                    }

                List(searchResults) { movie in
                    NavigationLink(destination: MovieDetailView(movie: movie, isFromSearch: true), label: {
                        SearchResultRowView(movie: movie)
                    })
                }
            }
            .navigationTitle("Search Movies")
        }
    }

    private func searchMovies(query: String) {
        guard !query.isEmpty else {
            searchResults = []
            return
        }

        MovieService.shared.searchMovies(query: query)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .failure(let error):
                    print("Search failed: \(error)")
                case .finished:
                    break
                }
            }, receiveValue: { movies in
                searchResults = movies
            })
            .store(in: &cancellables)
    }
}

#Preview {
    SearchView()
}

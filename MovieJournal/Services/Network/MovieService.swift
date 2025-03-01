//
//  MovieService.swift
//  MovieJournal
//
//  Created by Dylan on 25/02/2025.
//

import Foundation
import Combine

class MovieService {
    static let shared = MovieService()
    
    // After reviewing the possibilities for securely storing API keys in swift, I've decided it's not worth it for a school assignment
    private let apiKey = "eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiJlNjk2MzVjZTM3OTY0YmVkN2U2ZWU0YmY0YTE3NTIwZCIsIm5iZiI6MTc0MDA1NjczMy44NjcsInN1YiI6IjY3YjcyODlkMTFmZjAzNDA5ZWMzZmY4ZSIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.9m4t8K2mMMQMdjFe4wDp6Hje1WlVkEZfOXKIn1Q_6WA"
    private let baseURL = "https://api.themoviedb.org/3"
    
    private let cacheDirectory: URL
    private let searchCacheDirectory: URL
    private let movieDetailsCacheDirectory: URL


    
    private init() {
        let fileManager = FileManager.default
        guard let cacheDir = fileManager.urls(for: .cachesDirectory, in: .userDomainMask).first else {
            fatalError("Unable to access cache directory")
        }
        self.cacheDirectory = cacheDir
        self.searchCacheDirectory = cacheDir.appendingPathComponent("SearchCache")
        self.movieDetailsCacheDirectory = cacheDir.appendingPathComponent("MovieDetailsCache")

        
        try? fileManager.createDirectory(at: searchCacheDirectory, withIntermediateDirectories: true, attributes: nil)
        try? fileManager.createDirectory(at: movieDetailsCacheDirectory, withIntermediateDirectories: true, attributes: nil)
    }
    
    
    private func fetch<T: Decodable>(endpoint: String, queryItems: [URLQueryItem] = []) -> AnyPublisher<T, Error>
    {
        // Avoid Forced Unwrapping by constructing a constant baseComponents with guard let
        guard let baseComponents = URLComponents(string: "\(baseURL)\(endpoint)")
        else {
            print("ERROR: failed to construct URLComponents")
            return Fail(error: URLError(.badURL)).eraseToAnyPublisher()
        }
        
        var components = baseComponents
        components.queryItems = [
           URLQueryItem(name: "api_key", value: apiKey),
           URLQueryItem(name: "language", value: "en-US")
        ] + queryItems

        guard let url = components.url else {
           return Fail(error: URLError(.badURL)).eraseToAnyPublisher()
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.timeoutInterval = 10
        request.allHTTPHeaderFields = [
            "accept": "application/json",
            "Authorization": "Bearer \(apiKey)"
        ]
        
        return URLSession.shared.dataTaskPublisher(for: request)
               .map(\.data)
               .decode(type: T.self, decoder: JSONDecoder())
               .receive(on: DispatchQueue.main) // Ensure the result is delivered on the main thread
               .eraseToAnyPublisher()
    }
    
    func searchMovies(query: String, page: Int = 1) -> AnyPublisher<[Movie], Error>
    {
        if let cachedResults = loadSearchCache(for: query) {
            return Just(cachedResults)
                .setFailureType(to: Error.self)
                .eraseToAnyPublisher()
        }

        let endpoint = "/search/movie"
        let queryItems = [
            URLQueryItem(name: "query", value: query),
            URLQueryItem(name: "page", value: "\(page)")
        ]

        return fetch(endpoint: endpoint, queryItems: queryItems)
            .map { (response: MovieResponse) -> [Movie] in
                let movies = response.results
                self.saveSearchCache(movies, for: query)
                return movies
            }
            .eraseToAnyPublisher()
    }
    func fetchMovieDetails(movieID: Int) -> AnyPublisher<Movie, Error>
    {
        if let cachedMovie = loadMovieDetailsCache(for: movieID) {
            return Just(cachedMovie)
                .setFailureType(to: Error.self)
                .eraseToAnyPublisher()
        }

        let endpoint = "/movie/\(movieID)"
        return fetch(endpoint: endpoint)
            .map { (movie: Movie) -> Movie in
                self.saveMovieDetailsCache(movie, for: movieID)
                return movie
            }
            .eraseToAnyPublisher()
    }
    
    // MARK: - Disk Caching Methods
    private func saveSearchCache(_ movies: [Movie], for query: String)
    {
        let cacheFile = searchCacheDirectory.appendingPathComponent("\(query).json")
        do {
            let data = try JSONEncoder().encode(movies)
            try data.write(to: cacheFile, options: .atomic)
        } catch {
            print("Failed to save search cache: \(error)")
        }
    }

    private func loadSearchCache(for query: String) -> [Movie]?
    {
        let cacheFile = searchCacheDirectory.appendingPathComponent("\(query).json")
        guard FileManager.default.fileExists(atPath: cacheFile.path) else {
            return nil
        }
        do {
            let data = try Data(contentsOf: cacheFile)
            return try JSONDecoder().decode([Movie].self, from: data)
        } catch {
            print("Failed to load search cache: \(error)")
            return nil
        }
    }

    private func saveMovieDetailsCache(_ movie: Movie, for movieID: Int)
    {
        let cacheFile = movieDetailsCacheDirectory.appendingPathComponent("\(movieID).json")
        do {
            let data = try JSONEncoder().encode(movie)
            try data.write(to: cacheFile, options: .atomic)
        } catch {
            print("Failed to save movie details cache: \(error)")
        }
    }

    private func loadMovieDetailsCache(for movieID: Int) -> Movie?
    {
        let cacheFile = movieDetailsCacheDirectory.appendingPathComponent("\(movieID).json")
        guard FileManager.default.fileExists(atPath: cacheFile.path) else {
            return nil
        }
        do {
            let data = try Data(contentsOf: cacheFile)
            return try JSONDecoder().decode(Movie.self, from: data)
        } catch {
            print("Failed to load movie details cache: \(error)")
            return nil
        }
    }
}

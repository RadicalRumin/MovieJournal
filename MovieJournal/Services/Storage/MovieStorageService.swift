//
//  MovieStorageService.swift
//  MovieJournal
//
//  Created by Dylan on 25/02/2025.
//

import Foundation
import CoreData

class MovieStorage {
    static let shared = MovieStorage()

    private let context: NSManagedObjectContext

    private init() {
        self.context = CoreDataManager.shared.viewContext
    }

    func saveMovie(_ movie: Movie, watched: Bool = false, rating: Int16 = 0, notes: String? = nil) {
        let movieEntity = MovieEntity(context: context)
        movieEntity.id = Int64(movie.id)
        movieEntity.title = movie.title
        movieEntity.overview = movie.overview
        movieEntity.posterPath = movie.posterPath
        movieEntity.releaseDate = movie.releaseDate
        movieEntity.voteAverage = movie.voteAverage
        movieEntity.voteCount = Int64(movie.voteCount)
        movieEntity.adult = movie.adult
        movieEntity.backdropPath = movie.backdropPath
        movieEntity.genreIds = movie.genreIds
        movieEntity.originalLanguage = movie.originalLanguage
        movieEntity.originalTitle = movie.originalTitle
        movieEntity.popularity = movie.popularity
        movieEntity.video = movie.video
        movieEntity.watched = watched
        movieEntity.rating = rating
        movieEntity.notes = notes

        CoreDataManager.shared.saveContext()
    }

    func fetchMovies() -> [MovieEntity] {
        let fetchRequest: NSFetchRequest<MovieEntity> = MovieEntity.fetchRequest()
        do {
            return try context.fetch(fetchRequest)
        } catch {
            print("Failed to fetch movies: \(error)")
            return []
        }
    }

    func updateMovie(_ movieEntity: MovieEntity, watched: Bool? = nil, rating: Int16? = nil, notes: String? = nil) {
        if let watched = watched {
            movieEntity.watched = watched
        }
        if let rating = rating {
            movieEntity.rating = rating
        }
        if let notes = notes {
            movieEntity.notes = notes
        }
        CoreDataManager.shared.saveContext()
    }

    func deleteMovie(_ movieEntity: MovieEntity) {
        context.delete(movieEntity)
        CoreDataManager.shared.saveContext()
    }
}

//
//  Movie.swift
//  MovieJournal
//
//  Created by Dylan on 25/02/2025.
//

import Foundation

struct Movie: Codable, Identifiable {
    let id: Int
    let title: String
    let overview: String
    let posterPath: String?
    let releaseDate: String
    let voteAverage: Double
    let voteCount: Int
    let adult: Bool
    let backdropPath: String?
    let genreIds: [Int]?
    let originalLanguage: String
    let originalTitle: String
    let popularity: Double
    let video: Bool

    enum CodingKeys: String, CodingKey {
        case id, title, overview, adult
        case posterPath = "poster_path"
        case releaseDate = "release_date"
        case voteAverage = "vote_average"
        case voteCount = "vote_count"
        case backdropPath = "backdrop_path"
        case genreIds = "genre_ids"
        case originalLanguage = "original_language"
        case originalTitle = "original_title"
        case popularity, video
    }
}

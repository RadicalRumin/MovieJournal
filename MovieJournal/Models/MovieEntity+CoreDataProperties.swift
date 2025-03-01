//
//  MovieEntity+CoreDataProperties.swift
//  MovieJournal
//
//  Created by Dylan on 25/02/2025.
//

import Foundation
import CoreData

extension MovieEntity {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<MovieEntity> {
        return NSFetchRequest<MovieEntity>(entityName: "MovieEntity")
    }

    @NSManaged public var id: Int64
    @NSManaged public var title: String?
    @NSManaged public var overview: String?
    @NSManaged public var posterPath: String?
    @NSManaged public var releaseDate: String?
    @NSManaged public var voteAverage: Double
    @NSManaged public var voteCount: Int64
    @NSManaged public var adult: Bool
    @NSManaged public var backdropPath: String?
    @NSManaged public var genreIds: [Int]?
    @NSManaged public var originalLanguage: String?
    @NSManaged public var originalTitle: String?
    @NSManaged public var popularity: Double
    @NSManaged public var video: Bool
    @NSManaged public var watched: Bool
    @NSManaged public var rating: Int16
    @NSManaged public var notes: String?
}

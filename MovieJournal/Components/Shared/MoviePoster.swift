//
//  MoviePoster.swift
//  MovieJournal
// 
//  Created by Dylan on 25/02/2025.
//

import SwiftUI

struct MoviePoster: View {
    var movie: Movie
    var posterWidth: CGFloat
    var posterHeight: CGFloat
    var cornerRadius: CGFloat
    
    var body: some View {
        AsyncImage(url: URL(string: "https://image.tmdb.org/t/p/original\(movie.posterPath ?? "")")) { phase in
            switch phase {
            case .empty:
                ProgressView()
            case .success(let image):
                image
                    .resizable()
                    .scaledToFit()
                    .frame(width: posterWidth, height: posterHeight)
                    .cornerRadius(cornerRadius)
            case .failure:
                Image(systemName: "film.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: posterWidth, height: posterHeight)
                    .foregroundColor(.gray)
            @unknown default:
                EmptyView()
            }
        }
    }
}

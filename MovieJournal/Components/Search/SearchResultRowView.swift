//
//  SearchResultRowView.swift
//  MovieJournal
//
//  Created by Dylan on 25/02/2025.
//

import SwiftUI

struct SearchResultRowView: View {
    var movie: Movie
    
    let posterWidth: CGFloat = 60
    let posterHeight: CGFloat = 90
    let cornerRadius: CGFloat = 8
    
    var body: some View {
        HStack() {
            MoviePoster(movie: movie, posterWidth: posterWidth, posterHeight: posterHeight, cornerRadius: cornerRadius)
            
            VStack() {
                Text(movie.title)
                    .font(.headline)
                
                if let year = movie.releaseDate.components(separatedBy: "-").first {
                    Text(year)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
            }
            
            Spacer()
        }
    }
}



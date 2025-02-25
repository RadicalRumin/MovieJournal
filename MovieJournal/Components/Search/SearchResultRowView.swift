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
            AsyncImage(url: URL(string: "https://image.tmdb.org/t/p/w92\(movie.posterPath ?? "")")) { phase in
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



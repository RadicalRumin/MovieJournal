//
//  RatingView.swift
//  MovieJournal
//
//  Created by Dylan on 25/02/2025.
//

import SwiftUI

struct RatingView: View {
    @Binding var rating: Int16
    var starSize: CGFloat = 20 

    var body: some View {
        HStack {
            ForEach(1..<6, id: \.self) { index in
                Image(systemName: index <= Int(rating) ? "star.fill" : "star")
                    .resizable()
                    .frame(width: starSize, height: starSize)
                    .foregroundColor(.yellow)
                    .onTapGesture {
                        rating = Int16(index)
                    }
            }
        }
    }
}

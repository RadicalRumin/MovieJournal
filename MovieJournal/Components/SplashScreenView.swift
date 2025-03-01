//
//  SplashScreenView.swift
//  MovieJournal
//
//  Created by Dylan on 01/03/2025.
//

import SwiftUI

struct SplashScreenView: View {
    var body: some View {
        ZStack {
            Color.blue
                .ignoresSafeArea()

            VStack {
                Image(systemName: "film.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 100, height: 100)
                    .foregroundColor(.white)

                Text("Movie Journal")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .padding(.top, 16)
            }
        }
    }
}

#Preview {
    SplashScreenView()
}

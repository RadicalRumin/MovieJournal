//
//  MovieJournalApp.swift
//  MovieJournal
//
//  Created by Dylan on 24/02/2025.
//

import SwiftUI

@main
struct MovieJournalApp: App {
    var body: some Scene {
        WindowGroup {
            AppContentView()
        }
    }
}

struct AppContentView: View {
    @State private var showSplashScreen = true

    var body: some View {
        Group {
            if showSplashScreen {
                SplashScreenView()
                    .onAppear {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                            withAnimation {
                                showSplashScreen = false
                            }
                        }
                    }
            } else {
                TabView {
                    SearchView()
                        .tabItem {
                            Label("Search", systemImage: "magnifyingglass")
                        }

                    WatchlistView()
                        .tabItem {
                            Label("Watchlist", systemImage: "list.star")
                        }
                }
            }
        }
    }
}

#Preview {
    AppContentView()
}

//
//  SwiftUIView.swift
//  MusicRecordApp
//
//  Created by 신승아 on 4/12/24.
//

import SwiftUI
import MusicKit

struct MusicSearchView: View {
    let musicauthorizationManager = MusicAuthorizationManager()
    @ObservedObject private var searchManager = MusicSearchManager.shared

    var body: some View {
        NavigationView {
            VStack {
                List(searchManager.songs, id: \.id) { song in
                    
                    HStack(spacing: 10) {
                        if let artwork = song.artwork {
                            ArtworkImage(artwork, width: 60)
                                .cornerRadius(8)
                                .frame(width: 60, height: 60)
                        }
                        
                        VStack(alignment: .leading) {
                            Text(song.title)
                                .fontWeight(.bold)
                            Text(song.artistName)
                                .foregroundColor(.secondary)
                        }
                        
                    }
                }
                .listStyle(PlainListStyle())
            }
            .searchable(text: $searchManager.searchTerm, prompt: "오늘 하루를 나타내는 음악 하나를 골라볼까요?")
            .onChange(of: searchManager.searchTerm) {
                Task {
                    await MusicSearchManager.shared.requestUpdatedSearchResults()
                }
            }
            .onAppear {
                musicauthorizationManager.requestCloudServiceAuthorization()
            }
        }
    }
}


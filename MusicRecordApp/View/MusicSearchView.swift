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
    let imageManager = ImageManager()
    
    @Binding var isPresented: Bool
    @EnvironmentObject var sharedDateManager: SharedDataManager
    @ObservedObject private var searchManager = MusicSearchManager.shared
    @State private var navigateToWriteView = false
    @State private var selectedSong: Song?

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
                    .onTapGesture {
                        selectedSong = song  // 선택한 노래 정보를 저장
                        navigateToWriteView = true  // 네비게이션 링크 활성화
                    }
                }
                .listStyle(PlainListStyle())


                NavigationLink(
                    destination: WriteView(song: selectedSong, text: ""),
                    isActive: $navigateToWriteView
                ) {
                    EmptyView()
                }
            }
            .searchable(text: $searchManager.searchTerm, prompt: "오늘의 음악을 골라볼까요?")
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

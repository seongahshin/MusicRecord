//
//  SwiftUIView.swift
//  MusicRecordApp
//
//  Created by 신승아 on 4/12/24.
//

import SwiftUI
import MusicKit
import SwiftData

struct MusicSearchView: View {
    let musicauthorizationManager = MusicAuthorizationManager()
    let imageManager = ImageManager()
    
    @Binding var isPresented: Bool
    @EnvironmentObject var sharedDateManager: SharedDataManager
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
                    .onTapGesture {
                       /// 선택한 곡의 노래 이미지, 정보
                        if let artworkURL = imageManager.fetchArtworkURL(artwork: song.artwork) {
                            sharedDateManager.selectedSongInfo = SongInfo(image: artworkURL, title: song.title, singer: song.artistName)
                            print("노래 선택 시 데이터 저장 확인: \(String(describing: sharedDateManager.selectedSongInfo))")
                        } else {
                            print("곡 정보 설정에 필요한 데이터가 불완전합니다.")
                        }
                        
                        isPresented = false
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


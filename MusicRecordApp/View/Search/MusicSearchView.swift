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
    /// ✍️ Mark: ObservedObject로 구현하는 것이 적합할까, StateObject로 구현하는 것이 적합할까
    /// 뷰가 리로드 되는 상황을 생각해보자
    /// 매니저를 ObservedObject로 한다면 약간의 혼란이 될 수도 있을 것 같다..
    @ObservedObject private var searchManager = MusicSearchManager.shared
    @State private var navigateToWriteView = false
    
    var body: some View {
        NavigationStack {
            VStack {
                searchResultList()
            }
            // searchTerm을 안에서 사용 -> 저장할 것이 아니니..
            .searchable(text: $searchManager.searchTerm, prompt: "오늘의 음악을 골라볼까요?")
            .onChange(of: searchManager.searchTerm) {
                /// ✍️ Mark : 검색 시 느려지는 현상
                /// Term, Songs 분리
                Task {
                    await MusicSearchManager.shared.requestUpdatedSearchResults()
                }
            }
            .onAppear {
                musicauthorizationManager.requestCloudServiceAuthorization()
            }
        }
    }
    
    @ViewBuilder
    func searchResultList() -> some View {
        List(searchManager.songs, id: \.id) { song in
            NavigationLink(destination: WriteView(song: song, text: "")) {
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
            
        }
        .listStyle(PlainListStyle())
    }
}


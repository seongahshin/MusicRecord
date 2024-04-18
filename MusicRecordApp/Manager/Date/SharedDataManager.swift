//
//  SharedDateManager.swift
//  MusicRecordApp
//
//  Created by 신승아 on 4/13/24.
//

import SwiftUI
import MusicKit

struct SongInfo {
    let image: String
    let title: String
    let singer: String
    let id: String
}

class SharedDataManager: ObservableObject {
    @Published var selectedDate: String? = Date().formattedDate()
    @Published var selectedSongInfo: SongInfo?
    @Published var nowPlayingID: String?
    
    init(selectedDate: String? = nil, selectedSongInfo: SongInfo? = nil, nowPlayingID: String? = nil) {
        self.selectedDate = selectedDate
        self.selectedSongInfo = selectedSongInfo
        self.nowPlayingID = nowPlayingID
    }
}

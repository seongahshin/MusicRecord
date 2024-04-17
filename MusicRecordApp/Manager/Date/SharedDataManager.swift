//
//  SharedDateManager.swift
//  MusicRecordApp
//
//  Created by 신승아 on 4/13/24.
//

import SwiftUI

struct SongInfo {
    let image: String
    let title: String
    let singer: String
}

class SharedDataManager: ObservableObject {
    @Published var selectedDate: String?
    @Published var selectedSongInfo: SongInfo?
    
    init(selectedDate: String? = nil, selectedSongInfo: SongInfo? = nil) {
        self.selectedDate = selectedDate
        self.selectedSongInfo = selectedSongInfo
    }
}

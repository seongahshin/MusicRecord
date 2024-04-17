//
//  MusicKitManager.swift
//  MusicRecordApp
//
//  Created by 신승아 on 4/12/24.
//

import Foundation
import MusicKit
import Alamofire

class MusicSearchManager: ObservableObject {
    @Published var songs: [Song] = []
    @Published var searchTerm: String = ""
    
    static let shared = MusicSearchManager()
    
    func requestUpdatedSearchResults() async {
        guard !searchTerm.isEmpty else {
            DispatchQueue.main.async {
                self.songs = []
            }
            return
        }
        
        do {
            var searchRequest = MusicCatalogSearchRequest(term: searchTerm, types: [Song.self])
            searchRequest.limit = 5
            
            let searchResponse = try await searchRequest.response()
            await MainActor.run {
                self.songs = searchResponse.songs.compactMap { $0 }  // 응답에서 곡 정보를 추출하여 저장
            }
        } catch {
            print("Error during the search: \(error)")
        }
    }
    
}


//
//  WriteView.swift
//  MusicRecordApp
//
//  Created by 신승아 on 4/15/24.
//

import SwiftUI
import MusicKit

struct WriteView: View {
    let imageManager = ImageManager()
    var song: Song?
    @State var text: String
    
    @EnvironmentObject var sharedDateManager: SharedDataManager
    @Environment(\.modelContext) var modelContext
    
    var title: String {
        "\(song?.title ?? "제목 없음")와\n함께한 오늘,\n어떤 이야기가 있었나요?"
    }
    
    var subTitle: String {
        "오늘의 좋았던 점, 힘들었던 점, 어떤 이야기든 좋아요.\n세상에 의미없는 이야기란 존재하지 않는답니다!"
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            writeContent()
        }
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button("저장") {
                    saveData()
                    print("Diary entry saved.")
                }
            }
        }
    }
    
    @ViewBuilder
    func writeContent() -> some View {
        Text(title)
            .font(.title)
            .fontWeight(.bold)
            .multilineTextAlignment(.leading)
            .padding(.top, 0)
            .padding(.horizontal)
        
        Text(subTitle)
            .font(.subheadline)
            .foregroundColor(.secondary)
            .padding([.leading, .bottom, .trailing])
        
        TextEditor(text: $text)
            .frame(minHeight: 150)
            .padding()
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(.gray, lineWidth: 1)
            )
            .padding([.leading, .bottom, .trailing])
            .font(.system(size: 14))
    }
    
    func saveData() {

        print("Selected Date: \(String(describing: sharedDateManager.selectedDate))")
        print("Selected Song Info: \(String(describing: sharedDateManager.selectedSongInfo))")
        
        let record = Record(date: sharedDateManager.selectedDate ?? "", records: [
            DayRecord(id: UUID(), albumImage: imageManager.fetchArtworkURL(artwork: song!.artwork), songTitle: song!.title, singer: song!.artistName, detailRecord: text)
        ])
        print("저장된 데이터 확인: \(record)")
    
        modelContext.insert(record)
        do {
            try modelContext.save()
            print(modelContext.sqliteCommand)
            print("데이터 저장 완료")
        } catch {
            print("데이터 저장 실패: \(error)")
        }
        
        initSelectedSongInfo()
    }
    
    func initSelectedSongInfo() {
        sharedDateManager.selectedSongInfo = nil
    }
    
    
}

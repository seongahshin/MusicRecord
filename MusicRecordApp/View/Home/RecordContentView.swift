//
//  NoRecordContentView.swift
//  MusicRecordApp
//
//  Created by 신승아 on 5/2/24.
//

import SwiftUI
import SwiftData

struct RecordContentView: View {
    let imageManager = ImageManager()
    var songInfo: SongInfo
    
    @State private var text: String = ""
    @State private var showingAlert = false
    @State private var isPlaying = false
    
    @Environment(\.modelContext) var modelContext
    @EnvironmentObject var sharedDateManager: SharedDataManager
    
    @Binding var selectedDate: String
    
    /// ✍️ Mark : Query, recordArray
    @Query private var dateRecord: [Record]
    
    var recordArray: [Record] {
        return dateRecord.filter { record in
            record.date == selectedDate
        }
    }
    
    var recordText: String
    
    var body: some View {
        VStack {
            HStack {
                Spacer()
                menuButton()
            }
            contentView()
        }
        .alert("정말 삭제하시겠습니까?", isPresented: $showingAlert) {
            Button("아니오", role: .cancel) {}
            Button("네", role: .destructive) {
                deleteRecord()
            }
        }
        .padding()
    }
    
    /// ✍️ Mark - ViewBuilder를 사용해서 구현하는 것이 이 상황에 적합할까 / 어떤 상황에서 ViewBuilder를 사용하는 것이 좋을까?
    @ViewBuilder
    func contentView() -> some View {
        
        ZStack {
            
            AsyncImage(url: URL(string: songInfo.image))
                .frame(width: 200, height: 200)
                .cornerRadius(20)
                .clipped()
            
            Button {
                playButtonClicked()
            } label: {
                
                if songInfo.id == sharedDateManager.nowPlayingID {
                    Image(systemName: "pause.circle.fill")
                        .font(.system(size: 50)) // 아이콘 크기 조절
                        .foregroundColor(.white) // 아이콘 색상
                        .background(Color.black.opacity(0.4)) // 투명한 검은색 배경
                        .clipShape(Circle()) // 원형으로 클리핑
                } else {
                    Image(systemName: "play.circle.fill")
                        .font(.system(size: 50)) // 아이콘 크기 조절
                        .foregroundColor(.white) // 아이콘 색상
                        .background(Color.black.opacity(0.4)) // 투명한 검은색 배경
                        .clipShape(Circle()) // 원형으로 클리핑
                }
                
            }
            
            
        }
        
        Text(songInfo.title)
            .font(.title)
            .fontWeight(.bold)
            .padding(.top, 8)
            .multilineTextAlignment(.center)
        
        Text(songInfo.singer)
            .font(.headline)
            .foregroundColor(.secondary)
            .padding(.bottom, 8)
        
        Text(recordText)
            .font(.body) // 글꼴 크기 설정
            .frame(maxWidth: .infinity, maxHeight: .infinity,alignment: .leading) // 최대 너비를 무한대로 설정하고 왼쪽 정렬
            .padding() // 텍스트 주변에 패딩 추가
            .background(Color.white) // 배경색을 흰색으로 설정
            .overlay(
                RoundedRectangle(cornerRadius: 10) // 모서리가 둥근 사각형
                    .stroke(Color.gray, lineWidth: 1) // 회색 테두리
                    .shadow(color: .cyan, radius: 30)
            )
            .padding() // 외부 패딩 추가
    }
    
    @ViewBuilder
    func menuButton() -> some View {
        Menu {
            Button(role: .destructive, action: showAlert) {
                Label("삭제하기", systemImage: "trash")
            }
        } label: {
            Image(systemName: "ellipsis")
                .resizable()
                .scaledToFit()
                .frame(width: 15, height: 15)
                .padding(10)
                .foregroundColor(.gray)
        }
    }
    
}

extension RecordContentView {
    
    func showAlert() {
        showingAlert = true
    }
    
    func deleteRecord() {
        modelContext.delete(recordArray[0])
    }
    
    func playButtonClicked() {
        if !isPlaying {
            MusicPlayerManager.shared.playMusic(by: songInfo.id)
            sharedDateManager.nowPlayingID = songInfo.id
        } else {
            MusicPlayerManager.shared.pauseMusic(by: songInfo.id)
            sharedDateManager.nowPlayingID = ""
        }
        isPlaying.toggle()
    }
    
}

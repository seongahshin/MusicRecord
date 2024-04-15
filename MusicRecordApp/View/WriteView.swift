//
//  WriteView.swift
//  MusicRecordApp
//
//  Created by 신승아 on 4/15/24.
//

import SwiftUI
import MusicKit

struct WriteView: View {
    var song: Song?
    
    @State var text: String
    
    var body: some View {
        let title = "\(String(describing: song!.title))와\n함께한 오늘,\n어떤 이야기가 있었나요?"
        let subTitle = "오늘의 좋았던 점, 힘들었던 점, 어떤 이야기든 좋아요.\n세상에 의미없는 이야기란 존재하지 않는답니다!"
        
        VStack(alignment: .leading, spacing: 20) {
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
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button("저장") {
                    // 일기 저장 로직을 여기에 추가하세요.
                    print("Diary entry saved.")
                }
            }
        }
        
    }
}

//#Preview {
//    WriteView()
//}

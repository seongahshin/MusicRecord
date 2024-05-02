//
//  NoRecordContentView.swift
//  MusicRecordApp
//
//  Created by 신승아 on 5/2/24.
//

import SwiftUI
import SwiftData

struct noRecordContentView: View {
    
    @State private var showingModal = false
    
    var body: some View {
        ZStack {
            Rectangle()
                .foregroundStyle(.cyan)
                .ignoresSafeArea(.all, edges: .bottom)
            
            addRecordButton()
            
        }
    }
    
    @ViewBuilder
    func addRecordButton() -> some View {
        Button(action: {
            showingModal = true
        }, label: {
            
            VStack(spacing: 10) {
                Image(systemName: "plus")
                    .font(.title)
                
                Text("기록 추가하기")
                    .fontWeight(.medium)
                    .font(.system(size: 20))
            }
        })
        .foregroundStyle(.blue)
        .frame(width: 150, height: 150)
        .background(RoundedRectangle(cornerRadius: 20)
            .foregroundStyle(.white)
            .shadow(color: .gray, radius: 3, x: 0, y:0)
        )
        .sheet(isPresented: $showingModal) {
            MusicSearchView(isPresented: $showingModal)
        }
    }
}

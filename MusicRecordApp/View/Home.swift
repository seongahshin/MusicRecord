//
//  Home.swift
//  MusicRecordApp
//
//  Created by 신승아 on 4/11/24.
//

import SwiftUI
import MusicKit
import SwiftData

struct Home: View {
    @EnvironmentObject var sharedDateManager: SharedDataManager
    
    @State private var currentDate: String = Date().formattedDate()
    @State private var weekSlider: [[Date.WeekDay]] = []
    @State private var currentWeekIndex: Int = 1
    @State private var createWeek: Bool = false
    /// Animation Namespace
    @Namespace private var animation
    
    @Query private var dateRecord: [Record]
    
    var recordArray: [Record] {
        return dateRecord.filter { record in
            record.date == currentDate
        }
    }
    
    var body: some View {
        VStack(spacing: 0 ,content: {
            HeaderView()
            selectRecordView()
        })
        .vSpacing(.top)
        .onAppear(perform: {
            sharedDateManager.selectedDate = Date().formattedDate()
            fetchDate()
        })
    }
    
    func fetchDate() {
        if weekSlider.isEmpty {
            let currentWeek = Date().fetcWeek()
            
            if let firstDate = currentWeek.first?.date {
                weekSlider.append(firstDate.createPreviousWeek())
            }
            
            weekSlider.append(currentWeek)
            
            if let lastDate = currentWeek.last?.date {
                weekSlider.append(lastDate.createNextWeek())
            }
        }
    }
    
    @ViewBuilder
    func selectRecordView() -> some View {
        if !recordArray.isEmpty {
            // 현재 선택된 노래가 있는 상태이고 해당 날짜에 저장된 노래가 있는 상태
            let songInfo = recordArray[0].records[0]
            if let image = songInfo.albumImage {
                RecordContentView(songInfo: SongInfo(image: image, title: songInfo.songTitle, singer: songInfo.singer, id: songInfo.songID), selectedDate: $currentDate, recordText: songInfo.detailRecord)
            }
        } else {
            noRecordContentView()
        }
    }
    
    @ViewBuilder
    func HeaderView() -> some View {
        VStack(alignment: .leading, spacing: 6) {
            HStack(spacing: 5) {
                Text(currentDate)
                    .foregroundStyle(.blue)
            }
            .font(.title.bold())
            
            /// Week Slider
            TabView(selection: $currentWeekIndex) {
                ForEach(weekSlider.indices, id: \.self) { index in
                    let week = weekSlider[index]
                    WeekView(week)
                        .padding(.horizontal, 15)
                        .tag(index)
                }
            }
            .padding(.horizontal, -15)
            .tabViewStyle(.page(indexDisplayMode: .never))
            .frame(height: 90)
            
        }
        .padding(15)
        .background(.white)
        .onChange(of: currentWeekIndex, initial: false) { oldValue, newValue in
            /// Creating When it reaches first/last Page
            if newValue == 0 || newValue == (weekSlider.count - 1) {
                createWeek = true
            }
        }
    }
    
    /// Week View
    @ViewBuilder
    func WeekView(_ week: [Date.WeekDay]) -> some View {
        HStack(spacing: 0) {
            ForEach(week) { day in
                VStack(spacing: 8) {
                    Text(day.date.format("E"))
                        .font(.callout)
                        .fontWeight(.medium)
                        .textScale(.secondary)
                        .foregroundStyle(.gray)
                    
                    Text(day.date.format("dd"))
                        .font(.callout)
                        .fontWeight(.bold)
                        .textScale(.secondary)
                        .foregroundStyle(isSameDate(day.date.formattedDate(), currentDate) ? .white : .gray)
                        .frame(width: 35, height: 35)
                        .background(content: {
                            if isSameDate(day.date.formattedDate(), currentDate) {
                                Circle()
                                    .fill(.blue)
                                    .matchedGeometryEffect(id: "TABINDICATOR", in: animation)
                                
                            }
                            
                            /// Indicator to Show, Which is Today's Date
                            if day.date.isToday {
                                Circle()
                                    .fill(.cyan)
                                    .frame(width: 5, height: 5)
                                    .vSpacing(.bottom)
                                    .offset(y: 11)
                            }
                            
                        })
                        .background(.white.shadow(.drop(radius: 1)), in: .circle)
                }
                .hSpacing(.center)
                .contentShape(.rect)
                .onTapGesture {
                    /// Updating Current Date
                    withAnimation(.snappy) {
                        sharedDateManager.selectedDate = day.date.formattedDate()
                        print("날짜 클릭했을 때 date: \(day.date)")
                        currentDate = day.date.formattedDate()
                    }
                }
            }
        }
        .background {
            GeometryReader {
                let minX = $0.frame(in: .global).minX
                Color.clear
                    .preference(key: OffsetKey.self, value: minX)
                    .onPreferenceChange(OffsetKey.self) { value in
                        /// When the Offset reasches 15 and if the createWeek is toggled then simply generating next set of week
                        if value.rounded() == 15 && createWeek {
                            paginateWeek()
                            createWeek = false
                        }
                        
                    }
            }
        }
    }
    
    func paginateWeek() {
        /// SafeCheck
        if weekSlider.indices.contains(currentWeekIndex) {
            if let firstDate = weekSlider[currentWeekIndex].first?.date, currentWeekIndex == 0 {
                /// Inserting New Week at 0th Index and Removing Last Array Item
                weekSlider.insert(firstDate.createPreviousWeek(), at: 0)
                weekSlider.removeLast()
                currentWeekIndex = 1
            }
            
            if let lastDate = weekSlider[currentWeekIndex].last?.date, currentWeekIndex == (weekSlider.count - 1) {
                /// Inserting New Week at Last Index and Removing First Array Item
                weekSlider.append(lastDate.createNextWeek())
                weekSlider.removeFirst()
                currentWeekIndex = weekSlider.count - 2
            }
        }
    }
    
}

struct RecordContentView: View {
    let imageManager = ImageManager()
    var songInfo: SongInfo
    
    @State private var text: String = ""
    @State private var showingAlert = false
    @State private var isPlaying = false
    @Environment(\.modelContext) var modelContext
    @EnvironmentObject var sharedDateManager: SharedDataManager
    @Binding var selectedDate: String
    
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
    
    @ViewBuilder
    func contentView() -> some View {
        
        ZStack {
            
            AsyncImage(url: URL(string: songInfo.image))
                .frame(width: 200, height: 200)
                .cornerRadius(20)
                .clipped()
            
            Button {
                playToggle()
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
    
    func playToggle() {
        if !isPlaying {
            MusicPlayerManager.shared.playMusic(by: songInfo.id)
            sharedDateManager.nowPlayingID = songInfo.id
//            print("\(songInfo.id), \(sharedDateManager.nowPlayingID)")
        } else {
            MusicPlayerManager.shared.pauseMusic(by: songInfo.id)
            sharedDateManager.nowPlayingID = ""
//            print("\(songInfo.id), \(MusicPlayerManager.shared.nowPlayingID)")
        }
        isPlaying.toggle()
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
    
    func showAlert() {
        showingAlert = true
    }
    
    func deleteRecord() {
        
        modelContext.delete(recordArray[0])
    }
    
}

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

//#Preview {
//    Home()
//}


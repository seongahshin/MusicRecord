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
    
    var recort: [Record] {
        print("Record 전체 확인: \(dateRecord.count)")
        return dateRecord.filter { record in
            record.date == currentDate
        }
    }
    
    var body: some View {
        VStack(spacing: 0 ,content: {
            HeaderView()
            
            if let songInfo = sharedDateManager.selectedSongInfo {
                RecordContentView(songInfo: songInfo, selectedDate: $currentDate)
            } else {
                if recort.isEmpty {
                    noRecordContentView()
                } else {
                    let songInfo = recort[0].records[0]
                    if let image = songInfo.albumImage {
                        RecordContentView(songInfo: SongInfo(image: image, title: songInfo.songTitle, singer: songInfo.singer), selectedDate: $currentDate)
                    }
                }
                
            }
        })
        .vSpacing(.top)
        .onAppear(perform: {
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
        })
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
    @Environment(\.modelContext) var modelContext
    @EnvironmentObject var sharedDateManager: SharedDataManager
    @Binding var selectedDate: String
    
    var body: some View {
        VStack {
            HStack {
                Spacer()
                saveButton()
            }

            AsyncImage(url: URL(string: songInfo.image))
                .frame(width: 200, height: 200)
                .cornerRadius(20)
                .clipped()

            Text(songInfo.title)
                .font(.title)
                .fontWeight(.bold)
                .padding(.top, 8)
            
            Text(songInfo.singer)
                .font(.headline)
                .foregroundColor(.secondary)
                .padding(.bottom, 8)

            Spacer()

            TextEditor(text: $text)
                .padding()
                .border(Color.gray, width: 1)
                .padding()
//
            Spacer()
        }
        .padding()
    }
    
    @ViewBuilder
    func saveButton() -> some View {
        Button("저장") {

            // sharedDateManager 상태 확인
            print("Selected Date: \(String(describing: sharedDateManager.selectedDate))")
            print("Selected Song Info: \(String(describing: sharedDateManager.selectedSongInfo))")

            if let song = sharedDateManager.selectedSongInfo {
                let record = Record(date: selectedDate, records: [
                    DayRecord(id: UUID(), albumImage: song.image, songTitle: song.title, singer: song.singer, detailRecord: text)
                ])
                print("저장된 데이터 확인: \(record)")
                // CoreData Context에 데이터 저장
                modelContext.insert(record)
                do {
                    try modelContext.save()
                    print(modelContext.sqliteCommand)
                    print("데이터 저장 완료")
                } catch {
                    print("데이터 저장 실패: \(error)")
                }
            } else {
                print("필요한 데이터가 없어 저장을 진행하지 못했습니다.")
            }
        }
        .bold()
        .padding(.horizontal, 10)
        .buttonStyle(DefaultButtonStyle())
        .foregroundStyle(.red)
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

#Preview {
    Home()
}


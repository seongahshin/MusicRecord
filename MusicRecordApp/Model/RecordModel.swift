//
//  RecordModel.swift
//  MusicRecordApp
//
//  Created by 신승아 on 4/13/24.
//

import Foundation
import SwiftData
import MusicKit
import SwiftUI

@Model
class DayRecord {
    @Attribute(.unique) var id: UUID = UUID()
    var albumImage: String?
    var songID: String
    var songTitle: String
    var singer: String
    var detailRecord: String
    
    // SwiftLint - 라이브러리
    init(id: UUID,
         albumImage: String? = nil,
         songID: String,
         songTitle: String,
         singer: String,
         detailRecord: String) {
        self.id = id
        self.albumImage = albumImage
        self.songID = songID
        self.songTitle = songTitle
        self.singer = singer
        self.detailRecord = detailRecord
    }
}

@Model
// RecordGrop..?이라는 표현..?
// RecordInfo ..? 지양..?
class Record {
    @Attribute(.unique) var date: String
    /// ✍️ Mark : deleteRule 를 nullify로 하는 것이 맞을까
    /// Record 안에 records -> dayRecords 로 변경
    @Relationship(deleteRule: .nullify) var records: [DayRecord]
    
    init(date: String, records: [DayRecord]) {
        self.date = date
        self.records = records
    }
}



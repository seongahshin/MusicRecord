//
//  Date+Extension.swift
//  MusicRecordApp
//
//  Created by 신승아 on 4/11/24.
//

import SwiftUI

extension Date {
    func format(_ format: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        return formatter.string(from: self)
    }
    
    /// Checking Whether the Date is Today
    var isToday: Bool {
        return Calendar.current.isDateInToday(self)
    }
    
    /// Fetching Week Based on given Date
    func fetcWeek(_ date: Date = .init()) -> [WeekDay] {
        let calendar = Calendar.current
        let startOfDate = calendar.startOfDay(for: date)
        
        var week: [WeekDay] = []
        let weekForDate = calendar.dateInterval(of: .weekOfMonth, for: startOfDate)
        guard let startOfWeek = weekForDate?.start else {
            return []
        }
        
        /// Iterating to get the Full Week
        (0..<7).forEach { index in
            if let weekDay = calendar.date(byAdding: .day, value: index, to: startOfWeek) {
                week.append(.init(date: weekDay))
            }
        }
        
        return week
    }
    
    /// Creating Next Week, base on the Last Current Week's Date
    func createNextWeek() ->  [WeekDay] {
        let calendar = Calendar.current
        let startOfLastDate = calendar.startOfDay(for: self)
        guard let nextDate = calendar.date(byAdding: .day, value: 1, to: startOfLastDate) else {
            return []
        }
        return fetcWeek(nextDate)
    }
    
    /// Creating Previous Week, base on the Last Current Week's Date
    func createPreviousWeek() ->  [WeekDay] {
        let calendar = Calendar.current
        let startOfFirstDate = calendar.startOfDay(for: self)
        guard let previousDate = calendar.date(byAdding: .day, value: -1, to: startOfFirstDate) else {
            return []
        }
        return fetcWeek(previousDate)
    }
    
    /// 지금은 안쓰고 있긴 함 but 언젠가 사용할 일이 있을 것 ..
//    func getTimeZoneDate() -> String {
//        let now = Date() // 시스템 시간대를 기준으로 현재 시간
//        let dateFormatter = DateFormatter()
//        dateFormatter.timeZone = TimeZone.current // 현재 시스템 시간대 사용
//        dateFormatter.dateStyle = .medium
//        dateFormatter.timeStyle = .medium
//
//        let dateString = dateFormatter.string(from: now)
//        return dateString
//    }
    
    /// 데이터에 저장하는 쿼리명
    func formattedDate() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        return dateFormatter.string(from: self)
    }
    
    /// 월로 저장할 때 쓰일듯
//    func formatToMonth() -> String {
//        let dateFormatter = DateFormatter()
//        dateFormatter.dateFormat = "MM"
//        return dateFormatter.string(from: self)
//    }
    
    struct WeekDay: Identifiable {
        var id: UUID = .init()
        var date: Date
    }
}


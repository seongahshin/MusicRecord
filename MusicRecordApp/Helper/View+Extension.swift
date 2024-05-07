//
//  View+Extension.swift
//  MusicRecordApp
//
//  Created by 신승아 on 4/11/24.
//

import SwiftUI

/// Custom View Extensions
extension View {
    /// Custom Spacer
    @ViewBuilder
    func hSpacing(_ alignment: Alignment) -> some View {
        self
            .frame(maxWidth: .infinity, alignment: alignment)
    }
    
    @ViewBuilder
    func vSpacing(_ alignment: Alignment) -> some View {
        self
            .frame(maxHeight: .infinity, alignment: alignment)
    }
    
    /// Checking Two dates are same
    /// 위치, 형식 : 이게 여기에 있어야 되나
    func isSameDate(_ date1: String, _ date2: String) -> Bool {
        if date1 == date2 {
            return true
        } else {
            return false
        }
        //        return Calendar.current.isDate(date1, inSameDayAs: date2)
    }
}


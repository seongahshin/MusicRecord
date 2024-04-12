//
//  OffsetKey.swift
//  MusicRecordApp
//
//  Created by 신승아 on 4/11/24.
//

import SwiftUI

struct OffsetKey: PreferenceKey {
    static var defaultValue: CGFloat = 0
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = nextValue()
    }
}

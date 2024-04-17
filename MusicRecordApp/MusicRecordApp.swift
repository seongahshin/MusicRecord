//
//  MusicRecordAppApp.swift
//  MusicRecordApp
//
//  Created by 신승아 on 4/11/24.
//

import SwiftUI
import SwiftData

@main
struct MusicRecordApp: App {
    
    /// SwiftData modelContainer 구성
    var modelContainer: ModelContainer = {
        let schema = Schema([Record.self, DayRecord.self])
    let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)
        
    do {
        return try ModelContainer(for: schema, configurations:
                                    [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()
    
    var sharedDateManager = SharedDataManager()
    
    var body: some Scene {
        WindowGroup {
            Home()
                .modelContainer(modelContainer)
                .environmentObject(sharedDateManager)
        }
    }
}

extension ModelContext {
    var sqliteCommand: String {
        if let url = container.configurations.first?.url.path(percentEncoded: false) {
            "sqlite3 \"\(url)\""
        } else {
            "No SQLite database found."
        }
    }
}

//
//  MusicAuthorizationManager.swift
//  MusicRecordApp
//
//  Created by 신승아 on 4/13/24.
//

import StoreKit

class MusicAuthorizationManager {
    func requestCloudServiceAuthorization() {
        SKCloudServiceController.requestAuthorization { status in
            switch status {
            case .authorized:
                print("Authorized")
                self.requestMediaLibraryAccess()
            case .denied, .restricted, .notDetermined:
                print("Access denied or restricted")
            @unknown default:
                fatalError("Unknown authorization status")
            }
        }
    }
    
    func requestMediaLibraryAccess() {
        let controller = SKCloudServiceController()
        controller.requestCapabilities { (capabilities, error) in
            if let error = error {
                print("Error requesting capabilities: \(error)")
                return
            }
            if capabilities.contains(.musicCatalogPlayback) {
                print("Music catalog playback is available.")
            } else {
                print("Cannot play back music catalog.")
            }
        }
    }
}

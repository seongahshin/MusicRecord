//
//  MusicPlayerManager.swift
//  MusicRecordApp
//
//  Created by 신승아 on 4/17/24.
//

import MusicKit
import MediaPlayer

class MusicPlayerManager {

    var musicPlayer: MPMusicPlayerController?
    
    static let shared = MusicPlayerManager()

    init() {
        musicPlayer = MPMusicPlayerController.applicationMusicPlayer
        configureMusicPlayer()
    }

    func configureMusicPlayer() {
        // Add a notification observer to catch music player state changes
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(musicPlayerStateChanged),
                                               name: .MPMusicPlayerControllerPlaybackStateDidChange,
                                               object: musicPlayer)

        musicPlayer?.beginGeneratingPlaybackNotifications()
    }

    func playMusic(by id: String) {
        // Create a music player set queue with item ID
        let descriptor = MPMusicPlayerStoreQueueDescriptor(storeIDs: [id])
        musicPlayer?.setQueue(with: descriptor)
        musicPlayer?.play()
    }
    
    func pauseMusic(by id: String) {
        let descriptor = MPMusicPlayerStoreQueueDescriptor(storeIDs: [id])
        musicPlayer?.setQueue(with: descriptor)
        musicPlayer?.pause()
    }

    @objc func musicPlayerStateChanged(notification: NSNotification) {
        guard let player = notification.object as? MPMusicPlayerController else { return }
        switch player.playbackState {
        case .playing:
            print("Music is playing")
        case .paused:
            print("Music paused")
        case .stopped:
            print("Music stopped")
        default:
            print("Music player state: \(player.playbackState.rawValue)")
        }
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
        musicPlayer?.endGeneratingPlaybackNotifications()
    }
}


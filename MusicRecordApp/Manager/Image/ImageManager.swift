//
//  ImageManager.swift
//  MusicRecordApp
//
//  Created by 신승아 on 4/13/24.
//

import Foundation
import MusicKit

class ImageManager {

    func fetchArtworkURL(artwork: Artwork?) -> String? {
        guard let artwork = artwork else {
            print("Artwork 정보가 없습니다.")
            return nil
        }
        
        let width = 200
        let height = 200
        
        return artwork.url(width: width, height: height)?.absoluteString
    }


}

//
//  ImageManager.swift
//  MusicRecordApp
//
//  Created by 신승아 on 4/13/24.
//

import Foundation
import MusicKit

class ImageManager {
    
    // String값 가져오는 의미 담기도록 변수명 변경
    // static 으로 변경
    // 공용으로 쓰이는 공간이 아니기 때문에 -> 안에서 같이 쓰일 데이터도 없고 함수 하나이기 때문에 
    func fetchArtworkURL(artwork: Artwork?) -> String? {
        guard let artwork = artwork else {
            print("Artwork 정보가 없습니다.")
            return nil
        }
        
        /// ✍️ Mark - 고정값으로 주는 것이 맞을까
        // 실제 해상도 웹사이트 들어가서 점검해보기
        let width = 200
        let height = 200
        
        return artwork.url(width: width, height: height)?.absoluteString
    }
    
    
}

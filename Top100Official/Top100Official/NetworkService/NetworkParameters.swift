//
//  NetworkParameters.swift
//  Top100Official
//
//  Created by Consultant on 5/21/22.
//

import Foundation

enum NetworkParams {
    case albumList
    case albumCoverImage(path: String)
    
    var url: URL? {
        switch self {
        case .albumList:
            guard let urlComponents = URLComponents(string: "https://rss.applemarketingtools.com/api/v2/us/music/most-played/100/albums.json") else { return nil }
            
            return urlComponents.url
            
        case .albumCoverImage(path: let path):
            return URL(string: path)
        }
    }
    
}

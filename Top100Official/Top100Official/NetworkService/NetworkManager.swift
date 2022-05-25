//
//  NetworkManager.swift
//  Top100Official
//
//  Created by Consultant on 5/21/22.
//

import Foundation

protocol DataFetcher {
    func fetchAlbums(url: URL?, completion: @escaping (Result<[Result1], Error>) -> Void)
    func cacheImage(url: URL?, id: String)
//    func fetchData(url: URL?, completion: @escaping (Result<Data, Error>) -> Void)
}

class NetworkManager {
    
    let session: URLSession
    
    init(session: URLSession = URLSession.shared) {
        self.session = session
    }
    
}

extension NetworkManager: DataFetcher {
    func fetchAlbums(url: URL?, completion: @escaping (Result<[Result1], Error>) -> Void){
        
        guard let url = url else {
            completion(.failure(NetworkError.badURL))
            return
        }
        
        self.session.dataTask(with: url){ data, response, error in
            
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                completion(.failure(NetworkError.badData))
                return
            }
            
            do {
                let model = try JSONDecoder().decode(musicModel.self, from: data)
                
                for i in 0..<model.feed.results.count{
                    self.cacheImage(url: NetworkParams.albumCoverImage(path: model.feed.results[i].artworkUrl100).url, id: model.feed.results[i].id)
                }
                completion(.success(model.feed.results))
            } catch {
                completion(.failure(error))
            }
        }.resume()
        
        
    }
    
    func cacheImage(url: URL?, id: String){
        guard let url = url else {
            print(NetworkError.badURL)
            return
        }
        
        self.session.dataTask(with: url) {data, response, error in
            
            if let error = error {
                print(error)
                return
            }
            
            guard let data = data else {
                print(NetworkError.badData)
                return
            }
            
            ImageCache.shared.setImageData(key: id, data: data)
            
        }.resume()
    }
}


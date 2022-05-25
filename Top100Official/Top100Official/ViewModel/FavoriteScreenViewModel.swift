//
//  FavoriteScreenViewModel.swift
//  Top100Official
//
//  Created by Consultant on 5/22/22.
//

import Foundation
import UIKit

protocol FavoriteScreenSetup{
    func bind(updateHandler: @escaping () -> Void)
    func getFavAlbum() -> [String:Favorite]
    func numOfFavAlbum() -> Int
    func setCell(title: UILabel, name: UILabel, image: UIImageView, index: Int)
    func reloadData()
    func getID(index: Int) -> String
}

class FavoriteScreenTableViewModel: FavoriteScreenSetup{
    
    private var favAlbum: [String:Favorite]{
        didSet {
            self.updateHandler?()
        }
    }
    
    var updateHandler: (() -> Void)?
    
    init(album: [String:Favorite] = CoreDataManager.coreDataBase.loadData()) {
        self.favAlbum = album
    }
    
    func bind(updateHandler: @escaping () -> Void) {
        self.updateHandler = updateHandler
    }
    
    func getFavAlbum() -> [String:Favorite] {
        return self.favAlbum
    }
    
    func numOfFavAlbum() -> Int {
        return self.favAlbum.count
    }
    
    func setCell(title: UILabel, name: UILabel, image: UIImageView, index: Int) {
        let keys = getKeys()
        
        title.text = self.favAlbum[keys[index]]?.albumName
        name.text = self.favAlbum[keys[index]]?.artistName
        guard let data = ImageCache.shared.getImageData(key: keys[index]) else {
            return
        }
        image.image = UIImage(data:data)!
        
    }
    
    func getID(index: Int) -> String{
        let keys = getKeys()
        return keys[index]
    }
    
    private func getKeys() -> [String]{
        var keys: [String] = []
        
        for key in self.favAlbum.keys {
                keys.append(key)
        }
        return keys
    }
    
    func reloadData(){
        self.favAlbum = CoreDataManager.coreDataBase.loadData()
    }
    
}

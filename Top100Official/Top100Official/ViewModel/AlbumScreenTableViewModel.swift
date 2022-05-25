//
//  InitialScreenViewModel.swift
//  Top100Official
//
//  Created by Consultant on 5/20/22.
//

import Foundation
import UIKit

protocol AlbumTableSetup{
    func setTableTitleLabel(label: UILabel, cellIndex: Int)
    func setNumberOfTableRows()->Int
    func bind(updateHandler: @escaping () -> Void)
    func getAlbums()
    func passData(title: String) -> [Result1]?
}

class AlbumScreenTableViewModel: AlbumTableSetup{
    
    var albums: [Result1] {
        didSet {
            self.updateHandler?()
        }
    }
    
    var updateHandler: (() -> Void)?
    let tableCellTitle:  tableCellLabelTitle
    let count: Int
    let network: DataFetcher
    
    init(albums: [Result1] = [], titles: tableCellLabelTitle = tableCellLabelTitle(), network: DataFetcher = NetworkManager()){
        self.tableCellTitle = titles
        self.count = titles.titles.count
        self.albums = albums
        self.network = network
    }
    
    func setNumberOfTableRows()->Int{
        return self.count
    }
    
    func setTableTitleLabel(label: UILabel, cellIndex: Int){
        label.text = self.tableCellTitle.titles[cellIndex]
    }
    
    func bind(updateHandler: @escaping () -> Void) {
        self.updateHandler = updateHandler
    }
    
    func getAlbums(){
        self.network.fetchAlbums(url: NetworkParams.albumList.url){
            [weak self] (result: Result<[Result1], Error>) in
            
            switch result {
            case .success(let albumList):
                self?.albums.append(contentsOf: albumList)
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func passData(title: String) -> [Result1]? {
        var cellAlbumData: [Result1] = []
        
        if self.albums.isEmpty == false {
            if title == "Top 5 Albums of the Week"{
                for i in 0...4 {
                    cellAlbumData.append(self.albums[i])
                }
            }
            else if title == "Coming in at 6 - 20" {
                for i in 5...19 {
                    cellAlbumData.append(self.albums[i])
                }
            }
            else if title == "Coming in at 21 - 40" {
                for i in 20...39 {
                    cellAlbumData.append(self.albums[i])
                }
            }
            else if title == "Coming in at 41 - 60" {
                for i in 40...59 {
                    cellAlbumData.append(self.albums[i])
                }
            }
            else if title == "To the bottom 61 - 80" {
                for i in 60...79 {
                    cellAlbumData.append(self.albums[i])
                }
            }
            else if title == "Rounding out the Top 100 Albums" {
                for i in 80...99 {
                    cellAlbumData.append(self.albums[i])
                }
            }
            else{
                print("invalid cell title")
                return nil
            }
        }

        
        return cellAlbumData
    }
}

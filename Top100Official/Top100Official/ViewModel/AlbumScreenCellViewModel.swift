//
//  AlbumScreenCellViewModel.swift
//  Top100Official
//
//  Created by Consultant on 5/20/22.
//

import Foundation
import UIKit

protocol AlbumCellSetup {
    func cellCount(title: String) -> Int
    func bind(updateHandler: @escaping () -> Void)
    func recieveModel(model: [Result1])
    func setAlbumTitle(label: UILabel ,index: Int)
    func setArtistName(label: UILabel ,index: Int)
    func getImageData(image: UIImageView, index: Int)
    func getID(index: Int) -> String
    func retrieveSelectedData(index: Int) -> Result1?
}

class AlbumScreenCellViewModel: AlbumCellSetup{
    let cellsPerRow:  numberCellsperTablerow
    
    var albumsForCell: [Result1] {
        didSet {
            self.updateHandler?()
        }
    }
    
    var updateHandler: (() -> Void)?
    
    init(album: [Result1] = [], num: numberCellsperTablerow = numberCellsperTablerow()){
        self.cellsPerRow = num
        self.albumsForCell = []
    }
    
    func cellCount(title: String) -> Int{
        if title == "Top 5 Albums of the Week"{
            return self.cellsPerRow.numCells[0]
        }
        else if title == "Coming in at 6 - 20"{
            return self.cellsPerRow.numCells[1]
        }
        else {
            return self.cellsPerRow.numCells[2]
        }
        
    }
    
    func bind(updateHandler: @escaping () -> Void) {
        self.updateHandler = updateHandler
    }
    
    func recieveModel(model: [Result1]){
        self.albumsForCell = model
    }
    
    func setAlbumTitle(label: UILabel ,index: Int){
        if self.albumsForCell.isEmpty == false {
            label.text =  self.albumsForCell[index].name
        }
    }
    
    func setArtistName(label: UILabel ,index: Int){
        if self.albumsForCell.isEmpty == false {
            label.text = self.albumsForCell[index].artistName
        }
    }
    
    func getID(index: Int) -> String{
        if self.albumsForCell.isEmpty == false {
            let id = self.albumsForCell[index].id
            return id
        }
        return ""
    }
    
    func getImageData(image: UIImageView, index: Int){
        if self.albumsForCell.isEmpty == false {
            
            guard let data = ImageCache.shared.getImageData(key: self.albumsForCell[index].id) else {
                return
            }
            
            image.image = UIImage(data: data)
        }
        
    }
    
    func retrieveSelectedData(index: Int) -> Result1?
    {
        if self.albumsForCell.isEmpty == false {
            return self.albumsForCell[index]
        }
        else{
            return nil
        }
    }
}

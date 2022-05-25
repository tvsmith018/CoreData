//
//  AlbumTableViewCell.swift
//  Top100Official
//
//  Created by Consultant on 5/20/22.
//

import UIKit
protocol CollectionViewCellDelegate: AnyObject {
    func collectionView(collectionviewcell: AlbumCollectionViewCell?, index: Int, didTappedInTableViewCell: AlbumTableViewCell)
    
}

class AlbumTableViewCell: UITableViewCell {

    static let reuseId = "\(AlbumTableViewCell.self)"
    var albumContentModel: AlbumCellSetup
    
    weak var cellDelegate: CollectionViewCellDelegate?
    
    lazy var musicTableCellTitle: UILabel = {
        let label = UILabel(frame: .zero)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .white
        label.layer.opacity = 0.85
        label.font = UIFont(name:"Noteworthy", size: 17.0)
        label.layer.cornerRadius = 15.0
        label.clipsToBounds = true
        label.text = "Cell Title"
        label.numberOfLines = 0
        label.textAlignment = .center
        label.backgroundColor = UIColor.colorFromHex("#efc8b1")

        return label
    }()
    
    lazy var musicCollection: UICollectionView = {
        
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .horizontal
        flowLayout.itemSize = CGSize(width: 283, height: 180)
        flowLayout.minimumLineSpacing = 2.0
        flowLayout.minimumInteritemSpacing = 5.0
        
        let collection = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        collection.translatesAutoresizingMaskIntoConstraints = false
        collection.layer.cornerRadius = 50.0
        collection.clipsToBounds = true
        collection.backgroundColor = UIColor.colorFromHex("#F6E3D8")
        
        return collection
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        self.albumContentModel = AlbumScreenCellViewModel()
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.setupCell()

    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private func setupCell() {
        self.contentView.backgroundColor = UIColor.colorFromHex("#F6E3D8")
        self.contentView.addSubview(self.musicTableCellTitle)
        self.contentView.addSubview(self.musicCollection)
        
        self.musicCollection.showsHorizontalScrollIndicator = false
        
        self.musicTableCellTitle.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -8).isActive = true
        self.musicTableCellTitle.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 8).isActive = true
        self.musicTableCellTitle.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 8).isActive = true
        self.musicTableCellTitle.bottomAnchor.constraint(equalTo: self.musicCollection.topAnchor, constant: -8).isActive = true
        
        self.musicCollection.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -8).isActive = true
        self.musicCollection.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 8).isActive = true
        self.musicCollection.topAnchor.constraint(equalTo: self.musicTableCellTitle.bottomAnchor, constant: 8).isActive = true
        self.musicCollection.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -8).isActive = true
        
        self.musicCollection.dataSource = self
        self.musicCollection.delegate = self
        self.musicCollection.register(AlbumCollectionViewCell.self,forCellWithReuseIdentifier: AlbumCollectionViewCell.reuseId)
        
    }
    
    func recieveData(model: [Result1]){
        self.albumContentModel.bind { [weak self] in
            DispatchQueue.main.async {
                self?.musicCollection.reloadData()
            }
        }
        self.albumContentModel.recieveModel(model: model)
    }
    
}

extension AlbumTableViewCell: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UICollectionViewDelegate{
    
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let title = self.musicTableCellTitle.text ?? ""
        
        return self.albumContentModel.cellCount(title: title)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AlbumCollectionViewCell.reuseId, for: indexPath) as? AlbumCollectionViewCell {
            
            cell.layer.cornerRadius = 8
            cell.configure(image: UIImage(named: "question-mark")!, artist: "Artist Name", title: "Artist Title", id: "")
            
            self.albumContentModel.setAlbumTitle(label: cell.albumTitle, index: indexPath.row)
            self.albumContentModel.setArtistName(label: cell.Artist, index: indexPath.row)
            self.albumContentModel.getImageData(image: cell.albumCover, index: indexPath.row)
            cell.id = self.albumContentModel.getID(index: indexPath.row)
            cell.dataResult = self.albumContentModel.retrieveSelectedData(index: indexPath.row)
            
            
            guard let id = cell.id else {
                return cell
            }
             
            if CoreDataManager.coreDataBase.checkDatabase(id: id) == false {
                let image: UIImage = UIImage(systemName: "star")!
                cell.favoriteButton.setImage(image, for: .normal)
            }
            else {
                let image: UIImage = UIImage(systemName: "star.fill")!
                cell.favoriteButton.setImage(image, for: .normal)
            }
            
            return cell
        }
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: collectionView.frame.size.width, height: collectionView.frame.size.width/1.7)
        }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as? AlbumCollectionViewCell
        self.cellDelegate?.collectionView(collectionviewcell: cell, index: indexPath.item, didTappedInTableViewCell: self)
    
    }
    
}

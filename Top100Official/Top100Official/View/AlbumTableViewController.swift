//
//  AlbumTableViewController.swift
//  Top100Official
//
//  Created by Consultant on 5/20/22.
//

import UIKit

class AlbumTableViewController: UIViewController {

    lazy var AlbumTableView: UITableView = {
        let table = UITableView(frame: .zero)
        table.translatesAutoresizingMaskIntoConstraints = false
        table.backgroundColor = .white
        return table
    }()
    
    var albumScreenModelType: AlbumTableSetup
    
    
    init(viewModel: AlbumTableSetup) {
        self.albumScreenModelType = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.albumScreenModelType.bind { [weak self] in
            DispatchQueue.main.async {
                self?.AlbumTableView.reloadData()
            }
        }
        self.albumScreenModelType.getAlbums()
        
        
        self.setupView()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        DispatchQueue.main.async {
            self.AlbumTableView.reloadData()
        }
        self.albumScreenModelType.getAlbums()
    }
    
    private func setupView(){
        self.setupTable()
        
        self.view.addSubview(self.AlbumTableView)
        self.view.backgroundColor = UIColor.colorFromHex("#F6E3D8")
        self.AlbumTableView.bindToSuperView(insets: UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10))
        
    }
    
    private func setupTable(){
        self.AlbumTableView.dataSource = self
        self.AlbumTableView.delegate = self
        self.AlbumTableView.register(AlbumTableViewCell.self, forCellReuseIdentifier: AlbumTableViewCell.reuseId)
        self.AlbumTableView.showsVerticalScrollIndicator = false
        
    }
}

extension AlbumTableViewController: UITableViewDelegate, UITableViewDataSource {
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.albumScreenModelType.setNumberOfTableRows()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 250
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: AlbumTableViewCell.reuseId, for: indexPath) as? AlbumTableViewCell {
            
            self.albumScreenModelType.setTableTitleLabel(label: cell.musicTableCellTitle, cellIndex: indexPath.row)
            
            if self.albumScreenModelType.passData(title: cell.musicTableCellTitle.text ?? "nothing") != nil{
                cell.recieveData(model: self.albumScreenModelType.passData(title: cell.musicTableCellTitle.text ?? "nothing")!)
            }
            cell.cellDelegate = self
            return cell
       }
        return UITableViewCell()
    }
    
}

extension AlbumTableViewController: CollectionViewCellDelegate {
    func collectionView(collectionviewcell: AlbumCollectionViewCell?, index: Int, didTappedInTableViewCell: AlbumTableViewCell) {
        
        let detailViewController = DetailViewController()
        detailViewController.id = collectionviewcell?.id
        guard let image = ImageCache.shared.getImageData(key: collectionviewcell?.id ?? "") else {
            return
        }
        detailViewController.Artist.text = collectionviewcell?.Artist.text
        detailViewController.albumTitle.text = collectionviewcell?.albumTitle.text
        detailViewController.albumCover.image = UIImage(data: image)
        
        var genreTitle: String = ""
        guard let count = collectionviewcell?.dataResult?.genres.count else {
            return
        }
        for i in 0 ..< count {
            guard let genre = collectionviewcell?.dataResult?.genres[i].name else{
                return
            }
            
            genreTitle += genre + "\n"
        }
        
        detailViewController.genres.text = genreTitle
        
        guard let date1 = collectionviewcell?.dataResult?.releaseDate else {
            return
        }
        
        detailViewController.releaseDate.text = date1
        self.present(detailViewController, animated: true)
    }
}

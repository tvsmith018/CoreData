//
//  FavoriteAlbumViewController.swift
//  Top100Official
//
//  Created by Consultant on 5/20/22.
//

import UIKit

class FavoriteAlbumViewController: UIViewController {
    
    let favViewModel: FavoriteScreenSetup
    
    lazy var favAlbumTableView: UITableView = {
        let table = UITableView(frame: .zero)
        table.translatesAutoresizingMaskIntoConstraints = false
        table.backgroundColor = .white
        return table
    }()
    
    init(viewModel: FavoriteScreenSetup = FavoriteScreenTableViewModel()) {
        self.favViewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupView()
        
        
//        self.favViewModel.bind { [weak self] in
//            DispatchQueue.main.async {
//                self?.favAlbumTableView.reloadData()
//            }
//        }

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.favViewModel.bind{[weak self] in
            DispatchQueue.main.async {
                self?.favAlbumTableView.reloadData()
            }
        }
        self.favViewModel.reloadData()
    }
    
    private func setupView(){
        self.setupTable()
        
        self.view.addSubview(self.favAlbumTableView)
        self.view.backgroundColor = UIColor.colorFromHex("#efc8b1")
        self.favAlbumTableView.bindToSuperView(insets: UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10))
        
    }
    
    private func setupTable(){
        self.favAlbumTableView.dataSource = self
        self.favAlbumTableView.delegate = self
        self.favAlbumTableView.register(FavAlbumTableViewCell.self, forCellReuseIdentifier: FavAlbumTableViewCell.reuseId)
        self.favAlbumTableView.showsVerticalScrollIndicator = false
        
    }

}

extension FavoriteAlbumViewController: UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.favViewModel.numOfFavAlbum()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        guard let cell = tableView.dequeueReusableCell(withIdentifier: FavAlbumTableViewCell.reuseId, for: indexPath) as? FavAlbumTableViewCell else {
            return UITableViewCell()
        }
        
        self.favViewModel.setCell(title: cell.albumTitle, name: cell.Artist, image: cell.albumCover, index: indexPath.row)
        cell.cellID = self.favViewModel.getID(index: indexPath.row)
        
        if (CoreDataManager.coreDataBase.checkDatabase(id: cell.cellID ?? "") == true) {
            
            let image: UIImage = UIImage(systemName: "star.fill")!
            
            cell.favoriteButton.setImage(image, for: .normal)
        }
        return cell
    }
   
}

extension FavoriteAlbumViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
        
}

extension FavoriteAlbumViewController: UITabBarDelegate{
    func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
            print("Test")
        }
}

//
//  DetailViewController.swift
//  Top100Official
//
//  Created by Consultant on 5/24/22.
//

import UIKit

class DetailViewController: UIViewController {
    var id: String?
    
    lazy var Artist: UILabel = {
        let label: UILabel = UILabel(frame: .zero)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .white
        label.backgroundColor = UIColor.colorFromHex("#efc8b1")
        label.font = UIFont(name:"Noteworthy", size: 13)
        label.layer.cornerRadius = 10.0
        label.clipsToBounds = true
        label.text = "Artist Name"
        label.textColor = .white
        label.textAlignment = .center
        label.numberOfLines = 0
        label.heightAnchor.constraint(equalToConstant: 15).isActive = true
        label.widthAnchor.constraint(equalToConstant: 15).isActive = true
        return label
    }()
    
    lazy var albumTitle: UILabel = {
        let label: UILabel = UILabel(frame: .zero)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .white
        label.backgroundColor = UIColor.colorFromHex("#efc8b1")
        label.font = UIFont(name:"Noteworthy", size: 15)
        label.layer.cornerRadius = 10.0
        label.clipsToBounds = true
        label.text = "Album Title"
        label.textColor = .white
        label.textAlignment = .center
        label.numberOfLines = 0
        label.heightAnchor.constraint(equalToConstant: 20).isActive = true
        label.widthAnchor.constraint(equalToConstant: 20).isActive = true
        return label
    }()
    lazy var genres: UILabel = {
        let label: UILabel = UILabel(frame: .zero)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .white
        label.backgroundColor = UIColor.colorFromHex("#efc8b1")
        label.font = UIFont(name:"Noteworthy", size: 15)
        label.layer.cornerRadius = 10.0
        label.clipsToBounds = true
        label.text = "Album Title"
        label.textColor = .white
        label.textAlignment = .center
        label.numberOfLines = 0
        label.heightAnchor.constraint(equalToConstant: 20).isActive = true
        label.widthAnchor.constraint(equalToConstant: 20).isActive = true
        return label
    }()
    lazy var releaseDate: UILabel = {
        let label: UILabel = UILabel(frame: .zero)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .white
        label.backgroundColor = UIColor.colorFromHex("#efc8b1")
        label.font = UIFont(name:"Noteworthy", size: 15)
        label.layer.cornerRadius = 10.0
        label.clipsToBounds = true
        label.text = "Album Title"
        label.textColor = .white
        label.textAlignment = .center
        label.numberOfLines = 0
        label.heightAnchor.constraint(equalToConstant: 20).isActive = true
        label.widthAnchor.constraint(equalToConstant: 20).isActive = true
        return label
    }()
    
    lazy var albumCover: UIImageView = {
        let image: UIImageView = UIImageView(frame: .zero)
        image.translatesAutoresizingMaskIntoConstraints = false
        image.image = UIImage(named: "question-mark")
        image.contentMode =  .scaleAspectFit
        image.layer.cornerRadius = 10.0
        image.clipsToBounds = true
        image.heightAnchor.constraint(equalToConstant: 80).isActive = true
        image.widthAnchor.constraint(equalToConstant: 80).isActive = true
        
        return image
    }()
    
    lazy var favoriteButton: UIButton = {
        let button: UIButton = UIButton(frame: .zero)
        
        
        let image: UIImage = UIImage(systemName: "star")!
        
        button.setImage(image, for: .normal)
        button.tintColor = UIColor.colorFromHex("#efc8b1")
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
        return button
    }()
     
    lazy var vStack: UIStackView = {
        let stack = UIStackView(frame: .zero)
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.alignment = .fill
        stack.contentMode = .scaleAspectFit
        stack.spacing = 5
        
        
        return stack
    }()
    
    lazy var hStack: UIStackView = {
        let stack = UIStackView(frame: .zero)
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .horizontal
        return stack
    }()
    
    lazy var hStack2: UIStackView = {
        let stack = UIStackView(frame: .zero)
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .horizontal
        return stack
    }()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        self.setupPage()
    }
    
    private func setupPage(){
        self.vStack.addArrangedSubview(self.albumTitle)
        self.vStack.addArrangedSubview(self.Artist)
        
        self.hStack.addArrangedSubview(self.albumCover)
        self.hStack.addArrangedSubview(self.favoriteButton)
        self.vStack.addArrangedSubview(self.hStack)
        
        self.hStack2.addArrangedSubview(self.releaseDate)
        self.hStack2.addArrangedSubview(self.genres)
        self.hStack2.distribution = .fillEqually
        self.vStack.addArrangedSubview(self.hStack2)
        
        self.view.addSubview(self.vStack)
        
        self.vStack.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: 15).isActive = true
        self.vStack.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor, constant: -15).isActive = true
        self.vStack.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 15).isActive = true
        self.vStack.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: -15).isActive = true

    }

    @objc
       func buttonAction() {
           guard let id = self.id else{return}
           if (CoreDataManager.coreDataBase.checkDatabase(id: id)) == true {
               CoreDataManager.coreDataBase.delete(id: id)
               let image: UIImage = UIImage(systemName: "star")!
               self.favoriteButton.setImage(image, for: .normal)
           }
           else{
               CoreDataManager.coreDataBase.addFavoriteAlbum(artistName: self.Artist.text ?? "", albumTitle: self.albumTitle.text ?? "", id: self.id ?? "")
               let image: UIImage = UIImage(systemName: "star.fill")!
               self.favoriteButton.setImage(image, for: .normal)
           }
       }
}

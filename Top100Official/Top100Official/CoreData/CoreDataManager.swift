//
//  CoreData.swift
//  Top100Official
//
//  Created by Consultant on 5/22/22.
//

import Foundation
import CoreData

final class CoreDataManager {
    private lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "Top100Official")
        container.loadPersistentStores { description, error in
            if let error = error {
                fatalError("Something went wrong, \(error)")
            }
        }
        return container
    }()
    
//    private lazy var mainContext: NSManagedObjectContext = {
//        let moc = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
//        moc.persistentStoreCoordinator = self.persistentContainer.persistentStoreCoordinator
//        return moc
//    }()
//
//    private lazy var backgroundContext: NSManagedObjectContext = {
//        let moc = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
//        moc.parent = self.mainContext
//        return moc
//    }()
    
    static let coreDataBase = CoreDataManager()
    
    private var favAlbum: [String:Favorite]{
        didSet {
            self.updateHandler?()
        }
    }
    
    var updateHandler: (() -> Void)?
    
    private init(album: [String:Favorite] = [:]) {
        self.favAlbum = album
    }
    
}

extension CoreDataManager {
    
    func bind(updateHandler: @escaping () -> Void) {
        self.updateHandler = updateHandler
    }
    
    func fetchData() {
        let context = self.persistentContainer.viewContext
        let request: NSFetchRequest<Favorite> = Favorite.fetchRequest()
        
        do {
            let results = try context.fetch(request)
            if results != []{
                for i in 0 ..< results.count {
                    guard let id = results[i].id else {
                        return
                    }
                    
                    if (id == ""){
                        context.delete(results[i])
                    }
                    else {
                    self.favAlbum[id] = results[i]
                    }
                }
            }
        } catch {
            print(error)
        }
    }
    
    func loadData() -> [String:Favorite]{
        self.fetchData()
        
        return self.favAlbum
        
    }
    
    func addFavoriteAlbum(artistName: String, albumTitle: String, id: String) {
        let context = self.persistentContainer.viewContext
        guard let entity = NSEntityDescription.entity(forEntityName: "Favorite", in: context) else { return }
        
        let favoriteAlbum = Favorite(entity: entity, insertInto: context)
        favoriteAlbum.artistName = artistName
        favoriteAlbum.albumName = albumTitle
        favoriteAlbum.id = id
        favoriteAlbum.favorite = true
        
        saveContext()
    }
    
    func checkDatabase(id: String)->Bool{
        
        let context = persistentContainer.viewContext
        let request: NSFetchRequest<Favorite> = Favorite.fetchRequest()
        request.predicate = NSPredicate(format: "id Like %@", id)
        let object = try! context.fetch(request)
        
        if object.count == 0 {
            return false
        }
        else {
            return true
        }
    }
    
    func saveContext() {
        let context = self.persistentContainer.viewContext
        
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                fatalError("Error Saving: \(error)")
            }
        }
    }
    
    func delete(id:String) {
        let request: NSFetchRequest<Favorite> = Favorite.fetchRequest()
        let context = self.persistentContainer.viewContext
        request.predicate = NSPredicate(format: "id Like %@", id)
        request.includesPropertyValues = false
        
        guard let objects = try? context.fetch(request) else {
            return
        }
        
        for object in objects{
            context.delete(object)
        }
        
        if context.hasChanges {
            do {
                try context.save()
                self.favAlbum.removeValue(forKey: id)
            } catch {
                fatalError("Error Saving: \(error)")
            }
        }
    }
}

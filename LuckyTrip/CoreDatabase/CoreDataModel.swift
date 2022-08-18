//
//  CoreDataModel.swift
//  LuckyTrip
//
//  Created by Rana Alhaj on 17/08/2022.
//  To handle the saved destinations in core data


import Foundation
import UIKit
import CoreData

class CoreDataModel{
    
    private init() {}
    static let shared:CoreDataModel = CoreDataModel()
    
    func saveDestinations(id:Int,cityName:String,countryName:String,thumbnailImage: String?,thumbnailType : String?, descriptionText: String? , isVideo: Int)
    {
        let context = CoreDataModel.shared.persistentContainer.viewContext
        
        let entity = SavedDestinations(context: context)
        entity.id = Int32(id)
        entity.city = cityName
        entity.country_name = countryName
        entity.thumbnailImage = thumbnailImage
        entity.thumbnailType = thumbnailType
        entity.descriptionText = thumbnailType
        entity.isVideo = Int32(isVideo)
        CoreDataModel.shared.saveContext()
        print("success saved in core data")
    }
    
    func getSavedDestinations(complation:(([SavedDestinations]?)->Void))
    {
        let context = CoreDataModel.shared.persistentContainer.viewContext
        
        let fetchRequest : NSFetchRequest<SavedDestinations> =  SavedDestinations.fetchRequest()
        
        do
        {
            let data = try context.fetch(fetchRequest)
            complation(data)
        }
        catch
        {
            complation(nil)
        }
    }
    func getOneSavedDestination(id:Int32,complation:((SavedDestinations?)->Void)){
        let context = CoreDataModel.shared.persistentContainer.viewContext
        
        let fetchRequest : NSFetchRequest<SavedDestinations> =  SavedDestinations.fetchRequest()
        let sortPredicate = NSPredicate(format: "id LIKE %@", "\(id)")
        
        fetchRequest.predicate = sortPredicate
        do
        {
            let data = try context.fetch(fetchRequest)
            if data.count > 0
            {
                complation(data[0])
            }
            else
            {
                complation(nil)
            }
        }
        catch
        {
            complation(nil)
        }
        
    }
    
    lazy var persistentContainer: NSPersistentContainer = {
        
        let container = NSPersistentContainer(name: "LuckyTrip")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    // MARK: - Core Data Saving support
    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    
    func destinationExist(item: DestinationModel,  complation:((Bool?)->Void))
    {
        let context = CoreDataModel.shared.persistentContainer.viewContext
        
        let fetchRequest : NSFetchRequest<SavedDestinations> =  SavedDestinations.fetchRequest()
        
        do
        {
            let data = try context.fetch(fetchRequest)
            if data.contains(where: {$0.id == item.id }) {
                complation(true)
            }else{
                complation(false)
            }
        }
        catch
        {
            complation(false)
        }
    }
    
    func deleteSavedDest(item: SavedDestinations){
        let context = persistentContainer.viewContext
        let fetchRequest : NSFetchRequest<SavedDestinations> =  SavedDestinations.fetchRequest()
        if let result = try? context.fetch(fetchRequest) {
           // for object in result {
                context.delete(item)
           // }
        }
        
        do {
            try context.save()
        } catch {
          
        }
    }
    
    
}

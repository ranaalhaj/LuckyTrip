//
//  CoreDataModel.swift//
//  Created by Rana Alhaj on 14/8/2022.
//

import Foundation
import UIKit
import CoreData

class CoreDataModel{

    private init() {}
    static let shared:CoreDataModel = CoreDataModel()

    func saveDestinations(id:Int,cityName:String,countryName:String,thumbnailImage: String?,thumbnailType : String?, descriptionText: String?)
    {
        let context = CoreDataModel.shared.persistentContainer.viewContext

        let entity = SavedDestinations(context: context)
        entity.id = Int32(id)
        entity.city = cityName
        entity.country_name = countryName
        entity.thumbnailImage = thumbnailImage
        entity.thumbnailType = thumbnailType
        entity.descriptionText = thumbnailType
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
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
         */
        let container = NSPersistentContainer(name: "LuckyTrip")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.

                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
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
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    
//    func deleteContext(){
//        let context = persistentContainer.viewContext
//        if let result = try? context.fetch(fetchRequest) {
//            for object in result {
//                context.delete(object)
//            }
//        }
//
//        do {
//            try context.save()
//        } catch {
//            //Handle error
//        }
//    }

    
    func destinationExist(item: DestinationModel,  complation:((Bool?)->Void))
    {
        let context = CoreDataModel.shared.persistentContainer.viewContext

        let fetchRequest : NSFetchRequest<SavedDestinations> =  SavedDestinations.fetchRequest()

        do
        {
           let data = try context.fetch(fetchRequest)
            if data.contains(where: {$0.id == item.id ?? 0}) {
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
    
    
}

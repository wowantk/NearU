//
//  CoreDataManager.swift
//  testddd
//
//  Created by macbook on 27.04.2021.
//

import Foundation
import CoreData

final class CoreDataManager {
    
    static let sharedManager = CoreDataManager()
    private var context: NSManagedObjectContext { persistentContainer.viewContext }
    private weak var  manager :ObserverManager?
    private init() {}
    
    lazy var persistentContainer: NSPersistentContainer = {
        
        let container = NSPersistentContainer(name: "Model")
        
        
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    
    func saveContext () {
        let context = CoreDataManager.sharedManager.persistentContainer.viewContext
        if context.hasChanges {
            do {
                
                for object in context.insertedObjects{
                    if let signatureObject = object as? SignatureManagedObject {
                        signatureObject.sign()
                    }
                }
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    
    
    func insertPlace(p:Place){
        let newPlace = PlaceObject(context: self.context)
        newPlace.id = p.id
        newPlace.name = p.name
        newPlace.adress = p.adress
        newPlace.category = p.category
        newPlace.city = p.city
        newPlace.country = p.country
        newPlace.lat = p.lat
        newPlace.long = p.long
        saveContext()
    }
    
    func deleteAll(){
        //        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "PlaceObject")
        //        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        //        do {
        //            try context.execute(deleteRequest)
        //        } catch let error as NSError {
        //            print(error)
        //        }
        //        context.refreshAllObjects()
        var arr:[PlaceObject] = []
        do {
            arr = try context.fetch(PlaceObject.fetchRequest())
        }
        catch{
            fatalError()
        }
        
        for ob in arr{
            context.delete(ob)
        }
        saveContext()
    }
    
    func delete(id:UUID){
        var arr:[PlaceObject] = []
        do {
            arr = try context.fetch(PlaceObject.fetchRequest())
        }
        catch{
            fatalError()
        }
        if let deletElement = arr.first(where: {$0.id == id}) {
            context.delete(deletElement)
        }else{
            fatalError()
        }
        saveContext()
    }
    
    private var placesFRC: NSFetchedResultsController<PlaceObject>?
    
}

//MARK: -Delegate
extension CoreDataManager : PlacesRepository {    
    func subDelegate(v: ObserverManager ) {
        manager = v
    }
    
    var count: Int {
        return placesFRC?.sections?.first?.numberOfObjects ?? 0 
    }
    
    func place(at index: IndexPath) -> Place {
        let p = placesFRC?.object(at: index)
        return Place(id: (p?.id)!, name: (p?.name)!, category: (p?.category)!, adress: (p?.adress)!, city: (p?.city)!, country: (p?.country)!, long: (p?.long)!, lat: (p?.lat)!)
    }
    
    
    func insert(p:Place) {
        insertPlace(p: p)
    }
    
    func removeAll() {
        deleteAll()
    }
    
    
    func fetch() {
        if placesFRC == nil  {
            let nameSortDescriptor = NSSortDescriptor(key: "date_created", ascending: true)
            let fetch: NSFetchRequest<PlaceObject> = PlaceObject.fetchRequest()
            fetch.sortDescriptors = [nameSortDescriptor]
            placesFRC = NSFetchedResultsController(
                fetchRequest: fetch,
                managedObjectContext: context,
                sectionNameKeyPath: nil,
                cacheName: nil)
            placesFRC?.delegate = manager
        }
        try? placesFRC?.performFetch()
    }
    
    func remove(id: UUID) {
        delete(id: id)
    }
    
    
}

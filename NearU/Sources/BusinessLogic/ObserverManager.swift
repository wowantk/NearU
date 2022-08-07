//
//  ObserverManager.swift
//  testddd
//
//  Created by macbook on 28.04.2021.
//

import Foundation
import CoreData
class ObserverManager : NSObject, NSFetchedResultsControllerDelegate {
        
    private lazy var subscribers = [ObserverSubscriber]()
    private var doArr : [SubscriptionEvent : [IndexPath] ]  = [:]
    
    func add(subscriber: ObserverSubscriber) {
        doArr[.delete] = [IndexPath]()
        doArr[.insert] = [IndexPath]()
        doArr[.update] = [IndexPath]()
        subscribers.append(subscriber)
        }
    
    func controllerWillChangeContent(_ controller:
      NSFetchedResultsController<NSFetchRequestResult>) {
        subscribers.forEach({$0.startUp()})
    }

    func controller(_ controller:
      NSFetchedResultsController<NSFetchRequestResult>,
      didChange anObject: Any,
      at indexPath: IndexPath?,
      for type: NSFetchedResultsChangeType,
      newIndexPath: IndexPath?) {
      
      switch type {
      case .insert:
        doArr[.insert]?.append(newIndexPath!)
      case .delete:
        doArr[.delete]?.append(indexPath!)
      case .move:
        doArr[.delete]?.append(indexPath!)
        doArr[.insert]?.append(indexPath!)
      case .update:
        doArr[.update]?.append(indexPath!)
      @unknown default:
        print("Unexpected NSFetchedResultsChangeType")
      }
    }
    

    func controllerDidChangeContent(_ controller:
      NSFetchedResultsController<NSFetchRequestResult>) {
        for (key, value) in doArr {
            let sort: (IndexPath, IndexPath) -> Bool = key == .delete
                ? { $0 > $1 }
                : { $0 < $1 }
            let sortedArr = value.sorted(by: sort)
            for index in sortedArr {
                subscribers.forEach({$0.receive(index: index, event: key)})
            }
        }
        doArr[.delete] = [IndexPath]()
        doArr[.insert] = [IndexPath]()
        doArr[.update] = [IndexPath]()
        subscribers.forEach({$0.endUp()})
    }
    
}

protocol ObserverSubscriber {
    func receive(index:IndexPath,event: SubscriptionEvent)
    func startUp()
    func endUp()
}

enum SubscriptionEvent : String {
     case update
     case insert
     case delete
}

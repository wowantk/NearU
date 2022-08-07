//
//  PlacesManager.swift
//  testddd
//
//  Created by macbook on 22.04.2021.
//

import Foundation

protocol PlacesRepository: AnyObject {
    
    var count: Int { get }
    
    func removeAll()
    func fetch()
    func place(at index: IndexPath) -> Place
    func remove(id:UUID)
    func insert(p:Place)
    
    func subDelegate(v:ObserverManager)
}

final class PlacesManager {
    static  let changeSegment = Notification.Name(rawValue: "changeSegmentNotificationKey")
    
    var placesRepository: PlacesRepository!
    var observerManager  = ObserverManager()
    static let shared = PlacesManager()
    
    private init() {}
    
    func addDelegate(){
        placesRepository.subDelegate(v: observerManager)
    }
    
    func addPlace(p:Place?){
        guard let place = p else {return}
        placesRepository.insert(p: place)
    }
    
    func getArrCount() -> Int{
        placesRepository.count
    }
    
    func getPlace(at index: IndexPath) -> Place {
        placesRepository.place(at: index)
    }
    
    
    func remove(pId:UUID) {
        placesRepository.remove(id: pId)
    }
    
    func removeAll() {
        placesRepository.removeAll()
    }
    
    func copy( p:inout Place) {
        p.id = UUID()
        placesRepository.insert(p: p)
        
    }
}



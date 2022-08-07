//
//  SearchBusiness.swift
//  testddd
//
//  Created by macbook on 23.04.2021.
//

import Foundation

class SearchBussins {
    
    private(set) var savedArr:[Place] = []
    private var item: DispatchWorkItem?
    private var task: Cancellable?
    weak var delegate:SearchControlerDelegate?
    

}

//MARK: -publicInterface
extension SearchBussins {
    func search(text:String?,completion: @escaping ([Place]) -> Void) {
        _ = task?.cancel()
        item?.cancel()
        
        item = DispatchWorkItem { [self] in
            task =  Services.performRequest(object: self.makeQuery(text)) { [weak self] (isSucces, response,error) in
                if isSucces {
                    self?.handle(response: response)
                }else{
                    self?.delegate?.presentAlertError(err: error!)
                }
                completion(self!.savedArr)
            }
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute:  item!)
    }
}

//MARK: -privateInterface
private extension SearchBussins {
    private func makeQuery(_ text: String?) -> Search {
        return Search(
            latitude: LocationManager.shared.getLongitude(),
            longtide: LocationManager.shared.getLatitude(),
            placeName: text)
    }
    
    private func handle(response: Location?) {
        savedArr = []
        guard let arr = response?.response.venues else {return}
        for place  in arr{
            let name = place.name
            let category = place.categories.first?.name ?? "No Category information"
            let city = place.location.formattedAddress.count > 2 ? place.location.formattedAddress[1] : "default"
            let country = place.location.formattedAddress.count > 3 ? place.location.formattedAddress[2] : "default"
            let adress = place.location.formattedAddress[0]
            let lat = place.location.lat
            let lng = place.location.lng
            let currentPlace = Place(id: UUID(), name: name, category: category, adress: adress, city: city, country: country, long: "\(lng)", lat: "\(lat)")
            savedArr.append(currentPlace)
        }
    }
    
}

protocol SearchControlerDelegate : AnyObject  {
    func presentAlertError(err:Error)
}

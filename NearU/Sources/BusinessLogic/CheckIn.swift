import Foundation
final class CheckIn {
    var savedPlace:Place?
    weak var delegate:CheckinDelegate?
   
    
}

//MARK: -publicInterface
extension CheckIn{
    func nearest (completion: @escaping (Place) -> Void) {
        _ =  Services.performRequest(object: makeQuery(nil)) { [weak self] (isSucces, response,error) in
            guard let strongSelf = self else {return}
            if isSucces{
                strongSelf.handle(response: response)
                completion(strongSelf.savedPlace!)
            }else{
                self?.delegate?.presentErrorAlert(err: error!)
            }
            
        }
    }
}

//MARK: -PrivateInterface
private extension CheckIn {
    private func makeQuery(_ text: String?) -> Search {
        return Search(
            latitude: LocationManager.shared.getLongitude(),
            longtide: LocationManager.shared.getLatitude(),
            placeName: text)
    }
    
    private func handle(response: Location?) {
        guard let res = response?.response.venues else {return}
        let name = res.first?.name ?? "DefaultName"
        let category = res.first?.categories.first?.name ?? "No Category information"
        let adress =  res.first?.location.formattedAddress[0] ?? "No adress information"
        let city =  res.first?.location.formattedAddress[1] ?? "No city information"
        let country =  res.first?.location.formattedAddress[2] ?? "No country information"
        let lat =  res.first?.location.lat ??  0.0
        let lng =  res.first?.location.lng ?? 0.0
        
        savedPlace = Place(id:UUID(),name: name, category: category,adress:adress ,city: city ,country: country, long: "\(lng)", lat: "\(lat)")
    }
}

protocol CheckinDelegate: AnyObject {
    func presentErrorAlert(err:Error)
}







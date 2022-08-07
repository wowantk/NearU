//
//  Services.swift
//  TestUrlSession
//
//  Created by Volodymyr on 4/19/21.
//

import Foundation
import Alamofire

protocol Cancellable: AnyObject {
    func cancel() -> Self
}

extension DataRequest : Cancellable {
    
}


final class Services {
    static func performRequest(
        object: Search,
        completion: @escaping ( _ isSuccess: Bool,  _ response: Location?,_ er:Error?) -> ()
    ) -> Cancellable {
        
        let paramService = ParamService(long: object.longtide, ling: object.latitude,name: object.placeName)
        
        let task = AF.request("https://api.foursquare.com/v3/venues/search"
                              , method: .get, parameters: paramService.returnParam(), encoding: ArrayEncoding(), headers: nil, interceptor: nil, requestModifier: .none).response { (response) in
                                
                                let wrappedCompletion: (Bool, Location?,Error?) ->() = { (success, location,error) in
                                    DispatchQueue.main.async {
                                        completion(success, location,error)
                                    }
                                }
                                
                                guard let data = response.data else {return}
                                
                                do {
                                    let result =  try JSONDecoder().decode(Location.self, from: data)
                                    wrappedCompletion(true, result,nil)
                                } catch {
                                    print(error.localizedDescription)
                                    wrappedCompletion(false, nil,error)
                                }
                              }
        return task
        
    }
}

struct ArrayEncoding: ParameterEncoding {
    func encode(_ urlRequest: URLRequestConvertible, with parameters: Parameters?) throws -> URLRequest {
        var request = try URLEncoding().encode(urlRequest, with: parameters)
        request.url = URL(string: request.url!.absoluteString.replacingOccurrences(of: "%20%2C%20", with: ","))
        print(request)
        return request
    }
}


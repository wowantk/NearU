//
//  UrlServices.swift
//  TestUrlSession
//
//  Created by Volodymyr on 4/19/21.
//

import Foundation
final class ParamService {
   private var param = ["client_id":"EHZXMK4NVIDNAG4MZ51FPOPZDDHQTLNOJAKCWQMHA0AIQIAQ",
                 "client_secret":"JW2JEWANJBQEVN5XWIHSZAWOBG4FNKZLQEDKFRNW1I5EWKJV",
                 "v":"20210419",
                 "intent":"checkin",
                 "limit":"20"
    ]
    
    
    
    func returnParam() -> [String:String]?{
        return param
    }
    
    init(long:String,ling:String,name : String?) {
        param["ll"] = long + "," + ling
        guard let n = name  else {
            return
        }
        param["query"] = n
    }
}

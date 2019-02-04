//
//  VenuesAPI.swift
//  ZigZagExam
//
//  Created by Eliric Rivera on 03/02/2019.
//  Copyright © 2019 Eliric Rivera. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
class VenuesAPI: WebApi {
    class var instance: VenuesAPI { return VenuesAPI() }
    let clientID = "VKTUBAFLPUHVZKSV1EX4YF00XX05PLG0RL3P3A1MWM15BQEF"
    let clientSecret = "SUB4JCDEDP1DPJZNFRRJIKSETXO0GDP20CVIECMBC5AFA2G4"
    func getVenueSearch(lat:Double, lng:Double ,version:String, onSuccess: @escaping ([Venue])->Void, onError: @escaping (Error)->Void) {
        
        let url = buildUrl(paths: ["venues/search?ll=\(lat),\(lng)&client_id=\(clientID)&client_secret=\(clientSecret)&v=\(version)"])
        Alamofire.request(url).responseData { (response) in
            if response.result.value != nil{
                guard let data = response.data else{
                    return
                }
                do {
                    let json = try JSONSerialization.jsonObject(with: data, options: .mutableLeaves) as? NSDictionary
                    let jsonResponse = json?["response"] as! NSDictionary
                    var venuesArray = [Venue]()
                    let venues = jsonResponse["venues"] as! NSArray
                    for venue in venues as! [NSDictionary]{
                        var myVenue = Venue()
                        
                        let location = venue["location"] as! NSDictionary
                        var address = ""
                        
                        let formattedAddress =  location["formattedAddress"] as! NSArray
                        for format in formattedAddress{
                            if address == ""{
                                address = format as! String
                            }
                            else{
                                address = "\(address) \(format)"
                            }
                        }
                        myVenue.id = venue["id"] as! String
                        myVenue.name = venue["name"] as! String
                        myVenue.address = address
                        myVenue.distance = location["distance"] as! Int
                        venuesArray.append(myVenue)
                    }
                    onSuccess(venuesArray)
                    
                } catch {
                    onError(error)
                }
                
            }
            else{
                onError(response.result.error!)
            }
        }
    }
}

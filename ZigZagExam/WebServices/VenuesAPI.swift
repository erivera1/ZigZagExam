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
//                        let categoryArray = venue["categories"] as! NSArray
//                        var stringCategory = ""
//                        var stringIcon = ""
//                        if categoryArray.count > 0{
//                            let category = categoryArray[0] as! NSDictionary
//                            guard let cat = category["name"] else{
//                                return
//                            }
//                            stringCategory = cat as! String
//
//                            guard let icon = category["icon"] else{
//                                return
//                            }
//                            let iconDict = icon as! NSDictionary
//                            guard let prefix = iconDict["prefix"] else{
//                                return
//                            }
//                            guard let suffix = iconDict["suffix"] else{
//                                return
//                            }
//                            stringIcon = "\(prefix)bg_64\(suffix)"
//                        }
//                        else{
//                            stringIcon = ""
//                            stringCategory = "No Category"
//                        }
                        
                        myVenue.id = venue["id"] as! String
                        myVenue.name = venue["name"] as! String
                        myVenue.address = address
//                        myVenue.category = stringCategory
                        myVenue.distance = location["distance"] as! Int
//                        myVenue.icon = stringIcon
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

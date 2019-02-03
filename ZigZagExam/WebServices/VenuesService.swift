//
//  VenuesService.swift
//  ZigZagExam
//
//  Created by Eliric Rivera on 03/02/2019.
//  Copyright © 2019 Eliric Rivera. All rights reserved.
//

import UIKit

class VenuesService {
    class var instance: VenuesService { return VenuesService() }
    func getVenueSearch(lat: Double,lng:Double,version:String, onSuccess: @escaping ([Venue])->Void, onError: @escaping (String)->Void) {
        VenuesAPI.instance.getVenueSearch(
            lat:lat,
            lng:lng,
            version:version,
            onSuccess: {
                category in
                DispatchQueue.main.async { onSuccess(category) }
        },
            onError: {
                error in
                DispatchQueue.main.async { onError(error.localizedDescription) }
        })
    }

}
